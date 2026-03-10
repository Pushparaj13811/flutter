import 'package:skill_exchange/data/models/skill_model.dart';

class Skill {
  final String id;
  final String name;
  final String category;
  final SkillLevel level;

  const Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.level,
  });
}
