class MatchingFiltersModel {
  final String? skillCategory;
  final String? skillName;
  final String? location;
  final double? minRating;
  final double? maxRating;
  final List<String>? availability;
  final String? learningStyle;
  final List<String>? languages;

  const MatchingFiltersModel({
    this.skillCategory,
    this.skillName,
    this.location,
    this.minRating,
    this.maxRating,
    this.availability,
    this.learningStyle,
    this.languages,
  });

  factory MatchingFiltersModel.fromMap(Map<String, dynamic> map) {
    return MatchingFiltersModel(
      skillCategory: map['skillCategory'] as String?,
      skillName: map['skillName'] as String?,
      location: map['location'] as String?,
      minRating: (map['minRating'] as num?)?.toDouble(),
      maxRating: (map['maxRating'] as num?)?.toDouble(),
      availability: (map['availability'] as List?)?.cast<String>(),
      learningStyle: map['learningStyle'] as String?,
      languages: (map['languages'] as List?)?.cast<String>(),
    );
  }

  /// Legacy compatibility alias
  factory MatchingFiltersModel.fromJson(Map<String, dynamic> json) =
      MatchingFiltersModel.fromMap;

  Map<String, dynamic> toMap() => {
        if (skillCategory != null) 'skillCategory': skillCategory,
        if (skillName != null) 'skillName': skillName,
        if (location != null) 'location': location,
        if (minRating != null) 'minRating': minRating,
        if (maxRating != null) 'maxRating': maxRating,
        if (availability != null) 'availability': availability,
        if (learningStyle != null) 'learningStyle': learningStyle,
        if (languages != null) 'languages': languages,
      };

  MatchingFiltersModel copyWith({
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    List<String>? availability,
    String? learningStyle,
    List<String>? languages,
  }) {
    return MatchingFiltersModel(
      skillCategory: skillCategory ?? this.skillCategory,
      skillName: skillName ?? this.skillName,
      location: location ?? this.location,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      availability: availability ?? this.availability,
      learningStyle: learningStyle ?? this.learningStyle,
      languages: languages ?? this.languages,
    );
  }
}
