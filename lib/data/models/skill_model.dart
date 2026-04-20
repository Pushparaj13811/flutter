enum SkillLevel {
  beginner('beginner'),
  intermediate('intermediate'),
  advanced('advanced'),
  expert('expert');

  const SkillLevel(this.value);
  final String value;

  static SkillLevel fromString(String s) {
    return SkillLevel.values.firstWhere(
      (l) => l.value == s,
      orElse: () => SkillLevel.beginner,
    );
  }
}

enum SkillCategory {
  frontend('Frontend'),
  backend('Backend'),
  programming('Programming'),
  dataScience('Data Science'),
  devOps('DevOps'),
  cloud('Cloud'),
  design('Design'),
  blockchain('Blockchain'),
  security('Security'),
  mobile('Mobile'),
  other('Other');

  const SkillCategory(this.value);
  final String value;
}

class SkillModel {
  final String id;
  final String name;
  final String category;
  final SkillLevel level;

  const SkillModel({
    this.id = '',
    this.name = '',
    this.category = '',
    this.level = SkillLevel.beginner,
  });

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      id: map['id'] as String? ?? map['name'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      level: SkillLevel.fromString(map['level'] as String? ?? 'beginner'),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'level': level.value,
      };

  SkillModel copyWith({
    String? id,
    String? name,
    String? category,
    SkillLevel? level,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      level: level ?? this.level,
    );
  }
}
