import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/providers.dart';
import '../../entities/presentation/instantiate_species_sheet.dart';
import 'species_detail_view.dart';

class SpeciesDetailScreen extends ConsumerWidget {
  final String speciesId;

  const SpeciesDetailScreen({super.key, required this.speciesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogListProvider);

    return catalogState.when(
      data: (items) {
        final species = items.where((c) => c.id == speciesId).firstOrNull;
        if (species == null) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.emptyCatalog)),
          );
        }

        return Scaffold(
          body: SpeciesDetailView(species: species),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              InstantiateSpeciesSheet.show(context, species: species);
            },
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.instantiateAction),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
