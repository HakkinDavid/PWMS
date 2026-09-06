import '../../../core/constants/app_technical_strings.dart';
import '../../../core/database/app_database.dart';
import 'catalog_item.dart';
import 'subspecies.dart';
import '../../entities/domain/world_entity.dart';
import '../../entities/domain/i_entity_repository.dart';
import '../infrastructure/catalog_repository.dart';
import 'numismatics/numismatic_dictionary.dart';
import 'numismatics/numismatic_parser.dart';
import 'numismatics/numismatic_domain_rules.dart';
import 'numismatics/numismatic_matrix.dart';

export '../../../core/constants/app_technical_strings.dart' show NumismaticEmissionRuleData;
export 'numismatics/numismatic_dictionary.dart';
export 'numismatics/numismatic_parser.dart';
export 'numismatics/numismatic_domain_rules.dart';
export 'numismatics/numismatic_matrix.dart';

/// Facade for numismatic dictionary, parsing, and domain rules.
class NumismaticDataHelper {
  NumismaticDataHelper._();

  // Static constants from NumismaticDictionary
  static const List<String> numismaticSpeciesNames = NumismaticDictionary.numismaticSpeciesNames;
  static const Map<String, String> currencyMap = NumismaticDictionary.currencyMap;
  static const List<String> countries = NumismaticDictionary.countries;
  static const Map<String, List<String>> countryToCurrenciesMap = NumismaticDictionary.countryToCurrenciesMap;
  static const List<String> denominations = NumismaticDictionary.denominations;
  static const List<String> grades = NumismaticDictionary.grades;
  static const List<String> coinMaterials = NumismaticDictionary.coinMaterials;
  static const List<String> specialEditionReasons = NumismaticDictionary.specialEditionReasons;

  static List<String> getCurrenciesForCountry(String? country, {int? year, bool? isBanknote}) =>
      NumismaticMatrix.getCurrencies(country: country, year: year, isBanknote: isBanknote ?? false);

  static Map<String, String> getCurrencyMapForCountry(String? country, {int? year, bool? isBanknote}) {
    final codes = getCurrenciesForCountry(country, year: year, isBanknote: isBanknote);
    final result = <String, String>{};
    for (final code in codes) {
      if (currencyMap.containsKey(code)) {
        result[code] = currencyMap[code]!;
      }
    }
    return result;
  }

  static List<NumismaticEmissionRuleData> findRules(String? country, int? year, {bool? isBanknote}) =>
      NumismaticMatrix.findRules(country, year, isBanknote: isBanknote ?? false);

  static NumismaticEmissionRuleData? findRule(
    String? country,
    int? year, {
    String? currencyCode,
    String? denomination,
    bool? isBanknote,
  }) =>
      NumismaticMatrix.findRule(
        country,
        year,
        currencyCode: currencyCode,
        denomination: denomination,
        isBanknote: isBanknote ?? false,
      );

  static String? inferCurrency({String? country, int? year, bool? isBanknote}) =>
      NumismaticMatrix.inferCurrency(country: country, year: year, isBanknote: isBanknote ?? false);

  static List<String> getDenominationsForCountry({
    String? country,
    int? year,
    String? currencyCode,
    bool? isBanknote,
  }) =>
      NumismaticMatrix.getDenominations(
        country: country,
        year: year,
        currencyCode: currencyCode,
        isBanknote: isBanknote ?? false,
      );

  static String? inferMaterial({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
    bool? isBanknote,
  }) =>
      NumismaticMatrix.inferMaterial(
        country: country,
        year: year,
        currencyCode: currencyCode,
        denomination: denomination,
        isBanknote: isBanknote ?? false,
      );

  static ({bool isSpecial, String? reason})? checkSpecialEdition({
    String? country,
    int? year,
    String? currencyCode,
    String? denomination,
    bool? isBanknote,
  }) =>
      NumismaticMatrix.checkSpecialEdition(
        country: country,
        year: year,
        currencyCode: currencyCode,
        denomination: denomination,
        isBanknote: isBanknote ?? false,
      );

  static bool matchesDenomination(String d1, String d2) =>
      NumismaticMatrix.matchesDenomination(d1, d2);

  // Parsing methods from NumismaticParser
  static String resolveCurrencyIsoCode(String codeOrName) =>
      NumismaticParser.resolveCurrencyIsoCode(codeOrName);

  static String resolveCurrencyName(String codeOrName, {double? count}) =>
      NumismaticParser.resolveCurrencyName(codeOrName, count: count);

  static String resolveGrade(String raw) => NumismaticParser.resolveGrade(raw);

  static String resolveMaterial(String raw) => NumismaticParser.resolveMaterial(raw);

  static String resolveSpecialEditionReason(String raw) =>
      NumismaticParser.resolveSpecialEditionReason(raw);

  static bool areCurrenciesEquivalent(String? c1, String? c2, {double? count}) =>
      NumismaticParser.areCurrenciesEquivalent(c1, c2, count: count);

  static bool isNumismaticSpecies(CatalogItem species) =>
      NumismaticParser.isNumismaticSpecies(species);

  static bool isCoin(CatalogItem species) =>
      NumismaticParser.isCoinSpecies(species);

  static bool isBanknotePiece({
    CatalogItem? species,
    WorldEntity? instance,
    String? material,
    String? subspeciesName,
  }) =>
      NumismaticParser.isBanknotePiece(
        species: species,
        instance: instance,
        material: material,
        subspeciesName: subspeciesName,
      );

  static bool isCoinPiece({
    CatalogItem? species,
    WorldEntity? instance,
    String? material,
    String? subspeciesName,
  }) =>
      NumismaticParser.isCoinPiece(
        species: species,
        instance: instance,
        material: material,
        subspeciesName: subspeciesName,
      );

  static String buildSubspeciesName({
    double? faceValueNumber,
    String? faceValueStr,
    String? currencyName,
    String? currencyCode,
    String? country,
    String? year,
  }) =>
      NumismaticParser.buildSubspeciesName(
        faceValueNumber: faceValueNumber,
        faceValueStr: faceValueStr,
        currencyName: currencyName,
        currencyCode: currencyCode,
        country: country,
        year: year,
      );

  static String buildSubspeciesNotes({
    String? currencyName,
    String? currencyCode,
    String? year,
    String? composition,
  }) =>
      NumismaticParser.buildSubspeciesNotes(
        currencyName: currencyName,
        currencyCode: currencyCode,
        year: year,
        composition: composition,
      );

  static String sanitizeFileName(String text) =>
      NumismaticParser.sanitizeFileName(text);

  static String buildInstanceDisplayName(NumismaticAttributes attrs, {String? defaultSpeciesName}) =>
      NumismaticParser.buildInstanceDisplayName(attrs, defaultSpeciesName: defaultSpeciesName);

  static String buildAttachmentFileName({
    required String subspeciesName,
    required String instanceId,
    required String side,
    required String extension,
  }) =>
      NumismaticParser.buildAttachmentFileName(
        subspeciesName: subspeciesName,
        instanceId: instanceId,
        side: side,
        extension: extension,
      );

  static NumismaticAttributes extractAttributesFromInstance(WorldEntity entity) =>
      NumismaticParser.extractAttributesFromInstance(entity);

  static NumismaticAttributes parseSubspeciesName(String name) =>
      NumismaticParser.parseSubspeciesName(name);

  // Domain rules & Congruence from NumismaticDomainRules
  static String? checkInstanceSubspeciesCongruence({
    required Subspecies subspecies,
    required WorldEntity instance,
  }) =>
      NumismaticDomainRules.checkInstanceSubspeciesCongruence(
        subspecies: subspecies,
        instance: instance,
      );

  static Map<String, List<Subspecies>> findDuplicateSubspeciesGroups(
          List<Subspecies> subspeciesList) =>
      NumismaticDomainRules.findDuplicateSubspeciesGroups(subspeciesList);

  static Future<Subspecies> repairSubspeciesFromInstance({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) =>
      NumismaticDomainRules.repairSubspeciesFromInstance(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        subspecies: subspecies,
        instance: instance,
      );

  static Future<void> mergeDuplicateSubspecies({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies canonicalSubspecies,
    required List<Subspecies> duplicateSubspeciesList,
  }) =>
      NumismaticDomainRules.mergeDuplicateSubspecies(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        canonicalSubspecies: canonicalSubspecies,
        duplicateSubspeciesList: duplicateSubspeciesList,
      );

  static Future<void> repairAttachmentFileNames({
    required CatalogRepository catalogRepo,
    required IEntityRepository entityRepo,
    required Subspecies subspecies,
    required WorldEntity instance,
  }) =>
      NumismaticDomainRules.repairAttachmentFileNames(
        catalogRepo: catalogRepo,
        entityRepo: entityRepo,
        subspecies: subspecies,
        instance: instance,
      );

  static String deriveInstanceName(WorldEntity entity, {String? defaultSpeciesName}) =>
      NumismaticParser.deriveInstanceName(entity, defaultSpeciesName: defaultSpeciesName);

  static bool isNumismaticInstance(WorldEntity entity, [CatalogItem? species]) =>
      NumismaticParser.isNumismaticEntity(entity, species);

  static Future<void> repairAndStandardizeImportedData(AppDatabase db) =>
      NumismaticDomainRules.repairAndStandardizeImportedData(db);

  static List<NumismaticEmissionOutlier> checkEmissionOutliers({
    required WorldEntity instance,
    CatalogItem? species,
  }) =>
      NumismaticDomainRules.checkEmissionOutliers(
        instance: instance,
        species: species,
      );

  static Future<WorldEntity> repairEmissionOutlier({
    required IEntityRepository entityRepo,
    required CatalogRepository catalogRepo,
    required WorldEntity instance,
    required NumismaticEmissionOutlier outlier,
    String? customValue,
  }) =>
      NumismaticDomainRules.repairEmissionOutlier(
        entityRepo: entityRepo,
        catalogRepo: catalogRepo,
        instance: instance,
        outlier: outlier,
        customValue: customValue,
      );
}
