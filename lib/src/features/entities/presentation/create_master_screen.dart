import 'package:flutter/material.dart';
import 'register_object_modal.dart';

class CreateMasterScreen extends StatelessWidget {
  final String? initialLocationId;
  final bool startInCreateSpecies;
  final dynamic scannedResult;

  const CreateMasterScreen({
    super.key,
    this.initialLocationId,
    this.startInCreateSpecies = false,
    this.scannedResult,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Registro Maestro'),
      ),
      body: SafeArea(
        child: RegisterObjectModal(
          initialLocationId: initialLocationId,
          startInCreateSpecies: startInCreateSpecies,
        ),
      ),
    );
  }
}
