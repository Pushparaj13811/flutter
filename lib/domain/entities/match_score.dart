class MatchScore {
  final String userId;
  final double compatibilityScore;
  final double skillOverlapScore;
  final double availabilityScore;
  final double locationScore;
  final double languageScore;
  final List<String> theyTeach;
  final List<String> youTeach;

  const MatchScore({
    required this.userId,
    required this.compatibilityScore,
    required this.skillOverlapScore,
    required this.availabilityScore,
    required this.locationScore,
    required this.languageScore,
    this.theyTeach = const [],
    this.youTeach = const [],
  });
}
