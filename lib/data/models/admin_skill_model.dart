import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSkillModel {
  final String id;
  final String name;
  final String category;
  final int usageCount;
  final int usersTeaching;
  final int usersLearning;
  final bool isActive;
  final String createdAt;

  const AdminSkillModel({
    this.id = '',
    this.name = '',
    this.category = '',
    this.usageCount = 0,
    this.usersTeaching = 0,
    this.usersLearning = 0,
    this.isActive = true,
    this.createdAt = '',
  });

  factory AdminSkillModel.fromMap(Map<String, dynamic> map) {
    // Handle Timestamp or String for createdAt
    String createdAtStr = '';
    final raw = map['createdAt'];
    if (raw is Timestamp) {
      createdAtStr = raw.toDate().toIso8601String();
    } else if (raw is String) {
      createdAtStr = raw;
    }

    final usersTeaching = (map['usersTeaching'] as num?)?.toInt() ?? 0;
    final usersLearning = (map['usersLearning'] as num?)?.toInt() ?? 0;

    return AdminSkillModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      usageCount: (map['usageCount'] as num?)?.toInt() ?? (usersTeaching + usersLearning),
      usersTeaching: usersTeaching,
      usersLearning: usersLearning,
      isActive: map['isActive'] as bool? ?? true,
      createdAt: createdAtStr,
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
        'usersTeaching': usersTeaching,
        'usersLearning': usersLearning,
        'isActive': isActive,
        'createdAt': createdAt,
      };
}
