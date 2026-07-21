import '../../../core/constants/app_strings.dart';
import 'location_node.dart';

class LocationBreadcrumb {
  final String ancestorPath;
  final String targetName;

  const LocationBreadcrumb({
    required this.ancestorPath,
    required this.targetName,
  });

  String get fullPath => ancestorPath.isNotEmpty ? '$ancestorPath $targetName' : targetName;
}

class LocationPathHelper {
  LocationPathHelper._();

  static LocationBreadcrumb buildBreadcrumbPath(String? locationId, List<LocationNode> allNodes) {
    if (locationId == null) {
      return const LocationBreadcrumb(ancestorPath: '', targetName: AppStrings.rootLocationName);
    }

    final List<String> nodeNames = [];
    String? currentId = locationId;

    while (currentId != null) {
      final node = allNodes.where((n) => n.id == currentId).firstOrNull;
      if (node != null) {
        nodeNames.insert(0, node.name);
        currentId = node.parentLocationId;
      } else {
        break;
      }
    }

    if (nodeNames.isEmpty) {
      return const LocationBreadcrumb(ancestorPath: '', targetName: AppStrings.rootLocationName);
    }

    final targetName = nodeNames.last;
    final ancestors = [AppStrings.rootLocationName, ...nodeNames.sublist(0, nodeNames.length - 1)];
    final ancestorPath = '${ancestors.join(' > ')} >';

    return LocationBreadcrumb(
      ancestorPath: ancestorPath,
      targetName: targetName,
    );
  }
}
