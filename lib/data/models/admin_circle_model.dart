class AdminCircleModel {
  final String id;
  final String name;
  final String description;
  final int memberCount;
  final bool isFeatured;
  final bool isActive;
  final String createdAt;
  final String? imageUrl;

  const AdminCircleModel({
    this.id = '',
    this.name = '',
    this.description = '',
    this.memberCount = 0,
    this.isFeatured = false,
    this.isActive = true,
    this.createdAt = '',
    this.imageUrl,
  });

  factory AdminCircleModel.fromMap(Map<String, dynamic> map) {
    final members = map['members'] as List?;
    final memberCount = (map['memberCount'] as num?)?.toInt() ?? members?.length ?? 0;
    final createdAt = map['createdAt'];
    String createdAtStr = '';
    if (createdAt is String) {
      createdAtStr = createdAt;
    } else if (createdAt != null) {
      try {
        createdAtStr = (createdAt as dynamic).toDate().toIso8601String() as String;
      } catch (_) {}
    }
    return AdminCircleModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      memberCount: memberCount,
      isFeatured: map['isFeatured'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: createdAtStr,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  /// Legacy compatibility alias
  factory AdminCircleModel.fromJson(Map<String, dynamic> json) =
      AdminCircleModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'memberCount': memberCount,
        'isFeatured': isFeatured,
        'isActive': isActive,
        'createdAt': createdAt,
        'imageUrl': imageUrl,
      };
}
