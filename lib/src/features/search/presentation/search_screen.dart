import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/providers.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _selectedTypeFilter = 'Todos';

  final List<String> _typeFilters = [
    'Todos',
    'Herramienta',
    'Caja / Contenedor',
    'Documento',
    'Vehículo',
    'Animal',
    'Proyecto',
    'Idea',
    'Recuerdo',
    'Lugar',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(searchQueryProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final placesState = ref.watch(placeListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            hintText: 'Buscar por nombre, alias, etiqueta, nota...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            ref.read(searchQueryProvider.notifier).state = val;
            setState(() {});
          },
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _typeFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _typeFilters[index];
                final isSelected = filter == _selectedTypeFilter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedTypeFilter = filter);
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Search Results
          Expanded(
            child: searchResultsAsync.when(
              data: (results) {
                final filtered = _selectedTypeFilter == 'Todos'
                    ? results
                    : results.where((e) => e.type.toLowerCase() == _selectedTypeFilter.toLowerCase()).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: theme.colorScheme.primary.withAlpha(100)),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron elementos en tu mundo',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final entity = filtered[index];

                    String locationName = 'Sin ubicación';
                    if (entity.placeId != null) {
                      placesState.whenData((places) {
                        final found = places.where((p) => p.id == entity.placeId).firstOrNull;
                        if (found != null) locationName = found.name;
                      });
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primary.withAlpha(30),
                          child: FutureBuilder<String>(
                            future: entity.mainPhotoPath != null
                                ? ref.read(fileStorageServiceProvider).getAbsolutePath(entity.mainPhotoPath!)
                                : Future.value(''),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data!.isNotEmpty && File(snapshot.data!).existsSync()) {
                                return ClipOval(
                                  child: Image.file(
                                    File(snapshot.data!),
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return Icon(Icons.category, color: theme.colorScheme.primary);
                            },
                          ),
                        ),
                        title: Text(
                          entity.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            Text(entity.type, style: TextStyle(color: theme.colorScheme.secondary)),
                            const SizedBox(width: 8),
                            const Text('•'),
                            const SizedBox(width: 8),
                            const Icon(Icons.location_on_outlined, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(locationName, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          context.push('/entity/${entity.id}');
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error en búsqueda: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
