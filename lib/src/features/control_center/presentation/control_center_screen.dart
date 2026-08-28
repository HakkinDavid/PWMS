import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_technical_strings.dart';
import '../../../core/providers/providers.dart';
import '../../../core/widgets/app_toast.dart';
import '../domain/audit_rule_registry.dart';
import '../domain/audit_rule_strategy.dart';

class ControlCenterScreen extends ConsumerStatefulWidget {
  const ControlCenterScreen({super.key});

  @override
  ConsumerState<ControlCenterScreen> createState() => _ControlCenterScreenState();
}

class _ControlCenterScreenState extends ConsumerState<ControlCenterScreen>
    with SingleTickerProviderStateMixin {
  final AuditRuleRegistry _registry = AuditRuleRegistry();
  late TabController _tabController;

  List<AuditCardData> _integrityCards = [];
  List<AuditCardData> _routineCards = [];
  List<AuditCardData> _ignoredCards = [];
  bool _isLoading = true;
  int _integrityIndex = 0;
  int _routineIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _generateAuditCards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        allSpeciesMagnitudes: speciesList.expand((s) => s.magnitudes).toList(),
        allInstanceMagnitudes: entitiesList.expand((e) => e.magnitudes).toList(),
        allRequirements: const [],
        effectiveLocationMap: directLocMap,
      );

      final allCards = await _registry.evaluateAll(evalContext);
      final ignoredRows = await db.getAllIgnoredAuditCards();
      final ignoredIds = {for (var r in ignoredRows) r.cardId};

      final integrityCards = allCards.where((c) => c.category == AuditCategory.integrity && !ignoredIds.contains(c.id)).toList();
      final routineCards = allCards.where((c) => c.category == AuditCategory.routine && !ignoredIds.contains(c.id)).toList();
      final ignoredCards = allCards.where((c) => ignoredIds.contains(c.id)).toList();

      if (mounted) {
        setState(() {
          _integrityCards = integrityCards;
          _routineCards = routineCards;
          _ignoredCards = ignoredCards;
          _integrityIndex = 0;
          _routineIndex = 0;
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

  void _advanceCard(AuditCategory category) {
    if (category == AuditCategory.integrity) {
      if (_integrityIndex < _integrityCards.length - 1) {
        setState(() => _integrityIndex++);
      } else {
        setState(() => _integrityCards = []);
      }
    } else if (category == AuditCategory.routine) {
      if (_routineIndex < _routineCards.length - 1) {
        setState(() => _routineIndex++);
      } else {
        setState(() => _routineCards = []);
      }
    }
  }

  Future<void> _ignoreCard(AuditCardData card, AuditCategory category) async {
    final db = ref.read(databaseProvider);
    final targetId = card.entity?.id ?? card.subspecies?.id ?? card.species?.id;
    final targetType = card.entity != null
        ? AppTechnicalStrings.sourceTypeEntity
        : (card.subspecies != null
            ? AppTechnicalStrings.sourceTypeSubspecies
            : (card.species != null ? AppTechnicalStrings.sourceTypeSpecies : null));
    await db.ignoreAuditCard(
      card.id,
      ruleId: card.type.name,
      targetId: targetId,
      targetType: targetType,
      title: card.title,
      subtitle: card.subtitle,
    );
    if (mounted) {
      AppToast.showInfo(context, AppStrings.cardMarkedAsIgnoredSuccess);
      setState(() {
        if (category == AuditCategory.integrity) {
          _integrityCards.removeWhere((c) => c.id == card.id);
          if (_integrityIndex >= _integrityCards.length && _integrityCards.isNotEmpty) {
            _integrityIndex = _integrityCards.length - 1;
          }
        } else if (category == AuditCategory.routine) {
          _routineCards.removeWhere((c) => c.id == card.id);
          if (_routineIndex >= _routineCards.length && _routineCards.isNotEmpty) {
            _routineIndex = _routineCards.length - 1;
          }
        }
        _ignoredCards.add(card);
      });
    }
  }

  Future<void> _unignoreCard(AuditCardData card) async {
    final db = ref.read(databaseProvider);
    await db.unignoreAuditCard(card.id);
    if (mounted) {
      AppToast.showSuccess(context, AppStrings.cardUnignoredSuccess);
      setState(() {
        _ignoredCards.removeWhere((c) => c.id == card.id);
        if (card.category == AuditCategory.routine) {
          _routineCards.add(card);
        } else {
          _integrityCards.add(card);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final integrityPending = _integrityCards.length - _integrityIndex;
    final routinePending = _routineCards.length - _routineIndex;
    final ignoredCount = _ignoredCards.length;

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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Flexible(
                    child: Text(
                      AppStrings.ccTabIntegrityRules,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  if (integrityPending > 0 && !_isLoading) ...[
                    const SizedBox(width: 4),
                    Badge.count(
                      count: integrityPending,
                      backgroundColor: Colors.redAccent,
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.rule_folder_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Flexible(
                    child: Text(
                      AppStrings.ccTabRoutineChecks,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  if (routinePending > 0 && !_isLoading) ...[
                    const SizedBox(width: 4),
                    Badge.count(
                      count: routinePending,
                      backgroundColor: Colors.blueAccent,
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.visibility_off_outlined, size: 16),
                  const SizedBox(width: 4),
                  const Flexible(
                    child: Text(
                      AppStrings.ccTabIgnored,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  if (ignoredCount > 0 && !_isLoading) ...[
                    const SizedBox(width: 4),
                    Badge.count(
                      count: ignoredCount,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _integrityCards.isEmpty
                      ? _buildEmptyState(theme, category: AuditCategory.integrity)
                      : _buildCardStack(theme, category: AuditCategory.integrity),
                  _routineCards.isEmpty
                      ? _buildEmptyState(theme, category: AuditCategory.routine)
                      : _buildCardStack(theme, category: AuditCategory.routine),
                  _ignoredCards.isEmpty
                      ? _buildEmptyState(theme, category: AuditCategory.ignored)
                      : _buildIgnoredCardsList(theme),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, {required AuditCategory category}) {
    final isIntegrity = category == AuditCategory.integrity;
    final isRoutine = category == AuditCategory.routine;

    final IconData icon;
    final Color iconColor;
    final String title;
    final String subtitle;
    final String? actionLabel;

    if (isIntegrity) {
      icon = Icons.verified_outlined;
      iconColor = Colors.green;
      title = AppStrings.ccIntegrityEmptyTitle;
      subtitle = AppStrings.ccIntegrityEmptySubtitle;
      actionLabel = AppStrings.runNewAuditAction;
    } else if (isRoutine) {
      icon = Icons.inventory_2_outlined;
      iconColor = Colors.blueAccent;
      title = AppStrings.ccRoutineEmptyTitle;
      subtitle = AppStrings.ccRoutineEmptySubtitle;
      actionLabel = AppStrings.runNewRoutineCheckAction;
    } else {
      icon = Icons.visibility_off_outlined;
      iconColor = Colors.blueGrey;
      title = AppStrings.ccIgnoredEmptyTitle;
      subtitle = AppStrings.ccIgnoredEmptySubtitle;
      actionLabel = null;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: iconColor),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _generateAuditCards,
                icon: const Icon(Icons.autorenew),
                label: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIgnoredCardsList(ThemeData theme) {
    final db = ref.read(databaseProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _ignoredCards.length,
      itemBuilder: (context, index) {
        final card = _ignoredCards[index];
        final fixLabel = card.fixLabel ?? AppStrings.fixAction;
        final fixIcon = card.fixIcon ?? Icons.build_circle_outlined;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: card.themeColor.withAlpha(80), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: card.themeColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(card.icon, size: 22, color: card.themeColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.title,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (card.subtitle.isNotEmpty)
                            Text(
                              card.subtitle,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (card.question.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Text(
                      card.question,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _unignoreCard(card),
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text(
                          AppStrings.restoreAction,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                            await db.unignoreAuditCard(card.id);
                            ref.invalidate(entityListProvider);
                            ref.invalidate(catalogListProvider);
                            ref.invalidate(subspeciesListProvider);
                            ref.invalidate(relationListProvider);
                            if (mounted) {
                              setState(() {
                                _ignoredCards.removeWhere((c) => c.id == card.id);
                              });
                            }
                          }
                        },
                        icon: Icon(fixIcon, size: 16),
                        label: Text(
                          fixLabel,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: card.themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardStack(ThemeData theme, {required AuditCategory category}) {
    final isIntegrity = category == AuditCategory.integrity;
    final cards = isIntegrity ? _integrityCards : _routineCards;
    final currentIndex = isIntegrity ? _integrityIndex : _routineIndex;

    final card = cards[currentIndex];
    final progress = (currentIndex + 1) / cards.length;

    final confirmLabel = card.confirmLabel ?? AppStrings.correctAction;
    final fixLabel = card.fixLabel ?? AppStrings.fixAction;
    final confirmIcon = card.confirmIcon ?? Icons.check_circle_outline;
    final fixIcon = card.fixIcon ?? Icons.build_circle_outlined;

    return Column(
      children: [
        LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.withAlpha(40)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.reviewCounter(currentIndex + 1, cards.length),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(AppStrings.pendingReviews(cards.length - currentIndex), style: const TextStyle(fontSize: 11)),
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
                  _advanceCard(category);
                },
                background: _buildSwipeBackground(
                  color: Colors.blue.shade700,
                  icon: confirmIcon,
                  label: confirmLabel,
                  alignment: Alignment.centerLeft,
                ),
                secondaryBackground: _buildSwipeBackground(
                  color: Colors.red.shade800,
                  icon: fixIcon,
                  label: fixLabel,
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
                                      _advanceCard(category);
                                    }
                                  },
                                  icon: Icon(confirmIcon, color: Colors.green, size: 18),
                                  label: Text(
                                    confirmLabel,
                                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                                      _advanceCard(category);
                                    }
                                  },
                                  icon: Icon(fixIcon, size: 18),
                                  label: Text(
                                    fixLabel,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: card.themeColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // "No volver a mostrar" tertiary button
                          TextButton.icon(
                            onPressed: () => _ignoreCard(card, category),
                            icon: const Icon(Icons.visibility_off_outlined, size: 16, color: Colors.blueGrey),
                            label: const Text(
                              AppStrings.doNotShowAgainAction,
                              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                            ),
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
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
