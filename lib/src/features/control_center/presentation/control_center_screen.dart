import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/audit_rule_registry.dart';
import '../domain/audit_rule_strategy.dart';

class ControlCenterScreen extends ConsumerStatefulWidget {
  const ControlCenterScreen({super.key});

  @override
  ConsumerState<ControlCenterScreen> createState() => _ControlCenterScreenState();
}

class _ControlCenterScreenState extends ConsumerState<ControlCenterScreen> {
  final AuditRuleRegistry _registry = AuditRuleRegistry();
  List<AuditCardData> _cards = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateAuditCards();
  }

  Future<void> _generateAuditCards() async {
    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      final catalogRepo = ref.read(catalogRepositoryProvider);
      final entityRepo = ref.read(entityRepositoryProvider);
      final locationRepo = ref.read(locationRepositoryProvider);
      final relationRepo = ref.read(relationRepositoryProvider);

      final locRows = await db.select(db.instanceLocationsTable).get();
      final directLocMap = {for (var r in locRows) r.instanceId: r.locationId};

      final speciesList = await catalogRepo.getAllCatalogItems();
      final subspeciesList = await catalogRepo.getAllSubspecies();
      final entitiesList = await entityRepo.getAllEntities();
      final locationNodes = await locationRepo.getAllNodes();
      final relationsList = await relationRepo.getAllRelations();

      final evalContext = AuditEvaluationContext(
        db: db,
        allEntities: entitiesList,
        allCatalog: speciesList,
        allSubspecies: subspeciesList,
        allRelations: relationsList,
        allLocations: locationNodes,
        allSpeciesMagnitudes: const [],
        allInstanceMagnitudes: const [],
        allRequirements: const [],
        effectiveLocationMap: directLocMap,
      );

      final cards = await _registry.evaluateAll(evalContext);

      if (mounted) {
        setState(() {
          _cards = cards;
          _currentIndex = 0;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppToast.showError(context, AppStrings.controlCenterLoadError(e));
      }
    }
  }

  void _advanceCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _cards = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.style_outlined, color: Colors.white),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                AppStrings.controlCenterTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppStrings.regenerateAuditsTooltip,
            onPressed: _generateAuditCards,
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _cards.isEmpty
                ? _buildEmptyState(theme)
                : _buildCardStack(theme),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_outlined, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            Text(
              AppStrings.dataHealthVerifiedTitle,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              AppStrings.dataHealthVerifiedSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _generateAuditCards,
              icon: const Icon(Icons.autorenew),
              label: const Text(AppStrings.runNewAuditAction),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack(ThemeData theme) {
    final card = _cards[_currentIndex];
    final progress = (_currentIndex + 1) / _cards.length;

    return Column(
      children: [
        LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.withAlpha(40)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.reviewCounter(_currentIndex + 1, _cards.length),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(AppStrings.pendingReviews(_cards.length - _currentIndex), style: const TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ),

        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Dismissible(
                key: Key(card.id),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    final ok = await card.onFix(context, ref);
                    if (ok) {
                      await ref.read(activityLoggerServiceProvider).logAuditFixApplied(card.title, card.subtitle);
                    }
                    return ok;
                  } else {
                    return await card.onConfirm(context, ref);
                  }
                },
                onDismissed: (direction) {
                  ref.invalidate(entityListProvider);
                  ref.invalidate(catalogListProvider);
                  ref.invalidate(subspeciesListProvider);
                  ref.invalidate(relationListProvider);
                  _advanceCard();
                },
                background: _buildSwipeBackground(
                  color: Colors.blue.shade700,
                  icon: Icons.check_circle_outline,
                  label: AppStrings.correctAction,
                  alignment: Alignment.centerLeft,
                ),
                secondaryBackground: _buildSwipeBackground(
                  color: Colors.red.shade800,
                  icon: Icons.build_circle_outlined,
                  label: AppStrings.fixAction,
                  alignment: Alignment.centerRight,
                ),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: card.themeColor.withAlpha(100), width: 2),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header Icon and Audit Title
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: card.themeColor.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(card.icon, size: 28, color: card.themeColor),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                card.title,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          // Reusable Tile Widget
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: card.tile,
                          ),

                          // Card Question Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Text(
                              card.question,
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Action buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final ok = await card.onConfirm(context, ref);
                                    if (ok) {
                                      ref.invalidate(entityListProvider);
                                      ref.invalidate(catalogListProvider);
                                      ref.invalidate(subspeciesListProvider);
                                      ref.invalidate(relationListProvider);
                                      _advanceCard();
                                    }
                                  },
                                  icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                                  label: const Text(AppStrings.correctAction, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final ok = await card.onFix(context, ref);
                                    if (ok) {
                                      await ref.read(activityLoggerServiceProvider).logAuditFixApplied(card.title, card.subtitle);
                                      ref.invalidate(entityListProvider);
                                      ref.invalidate(catalogListProvider);
                                      ref.invalidate(subspeciesListProvider);
                                      ref.invalidate(relationListProvider);
                                      _advanceCard();
                                    }
                                  },
                                  icon: const Icon(Icons.build_circle_outlined, size: 18),
                                  label: const Text(AppStrings.fixAction, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: card.themeColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
