/// Representa el resultado y metadatos de una verificación de actualización.
class AppUpdateInfo {
  final bool isAvailable;
  final String currentVersion;
  final String? latestVersion;
  final String? changelog;
  final String? apkUrl;

  const AppUpdateInfo({
    required this.isAvailable,
    required this.currentVersion,
    this.latestVersion,
    this.changelog,
    this.apkUrl,
  });

  @override
  String toString() {
    return 'AppUpdateInfo(available: $isAvailable, current: $currentVersion, latest: $latestVersion)';
  }
}
