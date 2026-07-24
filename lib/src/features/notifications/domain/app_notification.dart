class AppNotification {
  final String id;
  final String type; // 'expired', 'expiring_soon', 'unsatisfied_need'
  final String title;
  final String message;
  final String targetId; // entityId or speciesId
  final String targetType; // 'entity' or 'species'
  final String status; // 'active', 'snoozed', 'dismissed'
  final DateTime? snoozedUntil;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.targetId,
    required this.targetType,
    this.status = 'active',
    this.snoozedUntil,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive {
    if (status == 'dismissed') return false;
    if (status == 'snoozed' && snoozedUntil != null) {
      return DateTime.now().isAfter(snoozedUntil!);
    }
    return status == 'active';
  }

  AppNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    String? targetId,
    String? targetType,
    String? status,
    DateTime? snoozedUntil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      status: status ?? this.status,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
