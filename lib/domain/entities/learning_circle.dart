class LearningCircle {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final List<String> skillFocus;
  final int membersCount;
  final int maxMembers;
  final bool isJoinedByMe;
  final String createdAt;
  final String updatedAt;

  const LearningCircle({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    this.skillFocus = const [],
    this.membersCount = 0,
    this.maxMembers = 20,
    this.isJoinedByMe = false,
    required this.createdAt,
    required this.updatedAt,
  });
}
