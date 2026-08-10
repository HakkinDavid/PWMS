import 'dart:io';
import 'package:platinum_world_management_system/src/features/catalog/domain/catalog_item.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/subspecies.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/attachment.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/world_entity.dart';
import 'package:platinum_world_management_system/src/features/entities/domain/instance_magnitude.dart';
import 'package:platinum_world_management_system/src/features/catalog/domain/numismatic_recognition_models.dart';
import 'package:platinum_world_management_system/src/features/catalog/infrastructure/catalog_repository.dart';
import 'package:platinum_world_management_system/src/features/entities/infrastructure/entity_repository.dart';

class NumismaticAttributes {
  final double? faceValueNumber;
  final String? faceValueStr;
  final String? currencyName;
  final String? currencyCode;
  final String? country;
  final String? year;
  final String? material;
  final String? grade;

  const NumismaticAttributes({
    this.faceValueNumber,
    this.faceValueStr,
    this.currencyName,
    this.currencyCode,
    this.country,
    this.year,
    this.material,
    this.grade,
  });
}

class NumismaticCongruenceIssue {
  final String subspeciesId;
  final String? instanceId;
  final String issueType; // 'magnitude_mismatch', 'duplicate_subspecies', 'attachment_mismatch', 'missing_magnitudes'
  final String description;
  final NumismaticAttributes expectedAttributes;
  final NumismaticAttributes? foundAttributes;

  const NumismaticCongruenceIssue({
    required this.subspeciesId,
    this.instanceId,
    required this.issueType,
    required this.description,
    required this.expectedAttributes,
    this.foundAttributes,
  });
}

class NumismaticDataHelper {
  static const List<String> numismaticSpeciesNames = ['Moneda', 'Billete'];

  /// Checks if a catalog species is a numismatic species (Moneda or Billete).
  static bool isNumismaticSpecies(CatalogItem species) {
    final nameLower = species.name.trim().toLowerCase();
    if (numismaticSpeciesNames.any((n) => n.toLowerCase() == nameLower)) {
      return true;
    }
    if (species.description != null &&
        species.description!.toLowerCase().contains('numismátic')) {
      return true;
    }
    return false;
  }

  /// Builds a deterministic subspecies title for coins or banknotes.
  /// Format: "[Denominación] [Divisa] - [País] ([Año])" or without year if null.
  static String buildSubspeciesName({
    double? faceValueNumber,
    String? faceValueStr,
    String? currencyName,
    String? currencyCode,
    String? country,
    String? year,
  }) {
    final denom = (faceValueStr != null && faceValueStr.trim().isNotEmpty)
        ? faceValueStr.trim()
        : (faceValueNumber != null
            ? (faceValueNumber % 1 == 0
                ? faceValueNumber.toInt().toString()
                : faceValueNumber.toString())
            : '');

    final curr = (currencyName != null && currencyName.trim().isNotEmpty)
        ? currencyName.trim()
        : (currencyCode != null && currencyCode.trim().isNotEmpty
            ? currencyCode.trim()
            : '');

    final cty = (country != null && country.trim().isNotEmpty)
        ? country.trim()
        : '';

    final yr = (year != null && year.trim().isNotEmpty) ? year.trim() : null;

    final firstPart = [denom, curr].where((s) => s.isNotEmpty).join(' ');
    final titleParts = <String>[];
    if (firstPart.isNotEmpty) titleParts.add(firstPart);
    if (cty.isNotEmpty) titleParts.add(cty);

    var mainText = titleParts.join(' - ');
    if (yr != null) {
      mainText = mainText.isNotEmpty ? '$mainText ($yr)' : '($yr)';
    }

    if (mainText.isEmpty) {
      return 'Pieza Numismática';
    }

    return mainText;
  }

  /// Builds deterministic subspecies notes string.
  static String buildSubspeciesNotes({
    String? currencyName,
    String? currencyCode,
    String? year,
    String? composition,
  }) {
    final curr = currencyName ?? currencyCode;
    final notesParts = <String>[];
    if (curr != null && curr.trim().isNotEmpty) {
      notesParts.add('Moneda: ${curr.trim()}');
    }
    if (year != null && year.trim().isNotEmpty) {
      notesParts.add('Año: ${year.trim()}');
    }
    if (composition != null && composition.trim().isNotEmpty) {
      notesParts.add('Material: ${composition.trim()}');
    }
    return notesParts.join(' | ');
  }

  /// Sanitizes text for file names.
  static String sanitizeFileName(String text) {
    return text.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }

  /// Builds deterministic filename for attachments.
  static String buildAttachmentFileName({
    required String subspeciesName,
    required String instanceId,
    required String side, // 'anverso' or 'reverso'
    required String extension,
  }) {
    final sanitizedSubname = sanitizeFileName(subspeciesName);
    final ext = extension.startsWith('.') ? extension.substring(1) : extension;
    return '$sanitizedSubname ($instanceId) ($side).$ext';
  }

  /// Extracts numismatic attributes from an instance's magnitudes.
  static NumismaticAttributes extractAttributesFromInstance(WorldEntity entity) {
    double? faceVal;
    String? year;
    String? currency;
    String? material;
    String? grade;

    for (final mag in entity.magnitudes) {
      if (mag.propertyName == 'Valor nominal') {
        faceVal = mag.magnitudeValue;
      } else if (mag.propertyName == 'Acuñación') {
        if (mag.magnitudeValue > 0) {
          year = mag.magnitudeValue.toInt().toString();
        } else if (mag.stringValue != null && mag.stringValue!.isNotEmpty) {
          year = mag.stringValue;
        }
      } else if (mag.propertyName == 'Divisa') {
        currency = mag.stringValue;
      } else if (mag.propertyName == 'Material') {
        material = mag.stringValue;
      } else if (mag.propertyName == 'Grado') {
        grade = mag.stringValue;
      }
    }

    return NumismaticAttributes(
      faceValueNumber: faceVal,
      currencyName: currency,
      year: year,
      material: material,
      grade: grade,
    );
  }

  /// Parses subspecies title to extract denomination, currency, country, year.
  static NumismaticAttributes parseSubspeciesName(String name) {
    // Pattern: "5 Pesos Mexicanos - México (2022)" or "5 Pesos Mexicanos - México"
    final yearRegex = RegExp(r'\(([^)]+)\)\s*$');
    final match = yearRegex.firstMatch(name);
    String? year;
    String mainText = name;

    if (match != null) {
      year = match.group(1)?.trim();
      mainText = name.substring(0, match.start).trim();
      if (mainText.endsWith('-')) {
        mainText = mainText.substring(0, mainText.length - 1).trim();
      }
    }

    final dashParts = mainText.split(' - ');
    String? denomAndCurr;
    String? country;

    if (dashParts.length >= 2) {
      denomAndCurr = dashParts[0].trim();
      country = dashParts.sublist(1).join(' - ').trim();
    } else {
      denomAndCurr = mainText.trim();
    }

    double? faceValue;
    String? faceValStr;
    String? currency;

    if (denomAndCurr != null && denomAndCurr.isNotEmpty) {
      final firstSpace = denomAndCurr.indexOf(' ');
      if (firstSpace > 0) {
        final numPart = denomAndCurr.substring(0, firstSpace).trim();
        final parsed = double.tryParse(numPart);
        if (parsed != null) {
          faceValue = parsed;
          faceValStr = numPart;
          currency = denomAndCurr.substring(firstSpace + 1).trim();
        } else {
          currency = denomAndCurr;
        }
      } else {
        final parsed = double.tryParse(denomAndCurr);
        if (parsed != null) {
          faceValue = parsed;
          faceValStr = denomAndCurr;
        } else {
          currency = denomAndCurr;
        }
      }
    }

    return NumismaticAttributes(
      faceValueNumber: faceValue,
      faceValueStr: faceValStr,
      currencyName: currency,
      country: country,
      year: year,
    );
  }

  /// Checks if instance magnitudes are congruent with subspecies title & notes.
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) {
    final instAttrs = extractAttributesFromInstance(instance);
    final subAttrs = parseSubspeciesName(subspecies.subspeciesName);

    final mismatches = <String>[];

    // Check year
    if (instAttrs.year != null &&
        subAttrs.year != null &&
        instAttrs.year != subAttrs.year) {
      mismatches.add('Año (Instancia: ${instAttrs.year} vs Subespecie: ${subAttrs.year})');
    }

    // Check face value
    if (instAttrs.faceValueNumber != null &&
        subAttrs.faceValueNumber != null &&
        (instAttrs.faceValueNumber! - subAttrs.faceValueNumber!).abs() > 0.001) {
      mismatches.add(
          'Valor Nominal (Instancia: ${instAttrs.faceValueNumber} vs Subespecie: ${subAttrs.faceValueNumber})');
    }

    // Check currency
    if (instAttrs.currencyName != null &&
        subAttrs.currencyName != null &&
        instAttrs.currencyName!.trim().toLowerCase() !=
            subAttrs.currencyName!.trim().toLowerCase()) {
      mismatches.add(
          'Divisa (Instancia: ${instAttrs.currencyName} vs Subespecie: ${subAttrs.currencyName})');
    }

    if (mismatches.isNotEmpty) {
      return 'Incongruencia en ${mismatches.join(", ")} entre la subespecie "${subspecies.subspeciesName}" y la instancia.';
    }

    return null;
  }

  /// Identifies duplicate subspecies under the same species (same normalized title).
  static Map<String, List<Subspecies>> findDuplicateSubspeciesGroups(
      List<Subspecies> subspeciesList) {
    final Map<String, List<Subspecies>> grouped = {};

    for (final sub in subspeciesList) {
      if (sub.subspeciesName.toLowerCase() == 'genérica') continue;
      final key = '${sub.speciesId}_${sub.subspeciesName.trim().toLowerCase()}';
      grouped.putIfAbsent(key, () => []).add(sub);
    }

    grouped.removeWhere((key, list) => list.length <= 1);
    return grouped;
  }

  /// Repairs subspecies title & notes from instance magnitudes deterministically.
  static Future<Subspecies> repairSubspeciesFromInstance({
    required CatalogRepository catalogRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final instAttrs = extractAttributesFromInstance(instance);
    final subAttrs = parseSubspeciesName(subspecies.subspeciesName);

    final newTitle = buildSubspeciesName(
      faceValueNumber: instAttrs.faceValueNumber ?? subAttrs.faceValueNumber,
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      country: subAttrs.country,
      year: instAttrs.year ?? subAttrs.year,
    );

    final newNotes = buildSubspeciesNotes(
      currencyName: instAttrs.currencyName ?? subAttrs.currencyName,
      year: instAttrs.year ?? subAttrs.year,
      composition: instAttrs.material,
    );

    final updated = subspecies.copyWith(
      subspeciesName: newTitle,
      notes: newNotes.isNotEmpty ? newNotes : subspecies.notes,
    );

    await catalogRepo.saveSubspecies(updated);
    return updated;
  }

  /// Merges duplicate subspecies into a canonical subspecies. Reassigns entities and deletes duplicates.
  static Future<void> mergeDuplicateSubspecies({
    required CatalogRepository catalogRepo,
    required EntityRepository entityRepo,
    required Subspecies canonicalSubspecies,
    required List<Subspecies> duplicateSubspeciesList,
  }) async {
    final allEntities = await entityRepo.getAllEntities();

    for (final dup in duplicateSubspeciesList) {
      if (dup.id == canonicalSubspecies.id) continue;

      // Reassign entities belonging to dup
      final entitiesToMove = allEntities.where((e) => e.subspeciesId == dup.id);
      for (final entity in entitiesToMove) {
        final updated = entity.copyWith(subspeciesId: canonicalSubspecies.id);
        await entityRepo.saveEntity(updated);
      }

      // Delete duplicate subspecies
      await catalogRepo.deleteSubspecies(dup.id);
    }
  }

  /// Renames attachment files and updates database records to match current subspecies name.
  static Future<void> repairAttachmentFileNames({
    required CatalogRepository catalogRepo,
    required EntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) async {
    final attachments = await entityRepo.getAttachmentsForInstance(instance.id);
    for (final att in attachments) {
      final isObverse = att.fileName.toLowerCase().contains('(anverso)') ||
          att.fileName.toLowerCase().contains('anverso');
      final side = isObverse ? 'anverso' : 'reverso';

      final file = File(att.filePath);
      final ext = file.path.contains('.') ? file.path.split('.').last : 'jpg';

      final expectedName = buildAttachmentFileName(
        subspeciesName: subspecies.subspeciesName,
        instanceId: instance.id,
        side: side,
        extension: ext,
      );

      if (att.fileName != expectedName) {
        // Renombrar archivo en disco si existe
        if (await file.exists()) {
          final parentDir = file.parent.path;
          final newPath = '$parentDir/$expectedName';
          final renamedFile = await file.rename(newPath);

          // Actualizar en base de datos
          final updatedAtt = att.copyWith(
            fileName: expectedName,
            filePath: renamedFile.path,
          );
          await catalogRepo.updateAttachment(updatedAtt);
        } else {
          // Solo actualizar nombre en DB
          final updatedAtt = att.copyWith(fileName: expectedName);
          await catalogRepo.updateAttachment(updatedAtt);
        }
      }
    }
  }
}
