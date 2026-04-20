class AdminSkillModel {
  final String id;
  final String name;
  final String category;
  final int usageCount;
  final bool isActive;
  final String createdAt;

  const AdminSkillModel({
    this.id = '',
    this.name = '',
    this.category = '',
    this.usageCount = 0,
    this.isActive = true,
    this.createdAt = '',
  });

  factory AdminSkillModel.fromMap(Map<String, dynamic> map) {
    return AdminSkillModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      usageCount: (map['usageCount'] as num?)?.toInt() ?? 0,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  /// Legacy compatibility alias
  factory AdminSkillModel.fromJson(Map<String, dynamic> json) =
      AdminSkillModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'usageCount': usageCount,
        'isActive': isActive,
        'createdAt': createdAt,
      };
}
