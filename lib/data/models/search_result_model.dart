import 'package:skill_exchange/data/models/user_profile_model.dart';

class SearchFiltersModel {
  final String? query;
  final String? skillCategory;
  final String? skillName;
  final String? location;
  final double? minRating;
  final double? maxRating;
  final String? availability;
  final String? learningStyle;
  final List<String>? languages;

  const SearchFiltersModel({
    this.query,
    this.skillCategory,
    this.skillName,
    this.location,
    this.minRating,
    this.maxRating,
    this.availability,
    this.learningStyle,
    this.languages,
  });

  factory SearchFiltersModel.fromMap(Map<String, dynamic> map) {
    return SearchFiltersModel(
      query: map['query'] as String?,
      skillCategory: map['skillCategory'] as String?,
      skillName: map['skillName'] as String?,
      location: map['location'] as String?,
      minRating: (map['minRating'] as num?)?.toDouble(),
      maxRating: (map['maxRating'] as num?)?.toDouble(),
      availability: map['availability'] as String?,
      learningStyle: map['learningStyle'] as String?,
      languages: (map['languages'] as List?)?.cast<String>(),
    );
  }

  /// Legacy compatibility alias
  factory SearchFiltersModel.fromJson(Map<String, dynamic> json) =
      SearchFiltersModel.fromMap;

  Map<String, dynamic> toMap() => {
        if (query != null) 'query': query,
        if (skillCategory != null) 'skillCategory': skillCategory,
        if (skillName != null) 'skillName': skillName,
        if (location != null) 'location': location,
        if (minRating != null) 'minRating': minRating,
        if (maxRating != null) 'maxRating': maxRating,
        if (availability != null) 'availability': availability,
        if (learningStyle != null) 'learningStyle': learningStyle,
        if (languages != null) 'languages': languages,
      };

  SearchFiltersModel copyWith({
    String? query,
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    String? availability,
    String? learningStyle,
    List<String>? languages,
  }) {
    return SearchFiltersModel(
      query: query ?? this.query,
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

class SearchResultModel {
  final List<UserProfileModel> users;
  final int total;
  final int page;
  final int pageSize;

  const SearchResultModel({
    this.users = const [],
    this.total = 0,
    this.page = 1,
    this.pageSize = 20,
  });

  factory SearchResultModel.fromMap(Map<String, dynamic> map) {
    return SearchResultModel(
      users: (map['users'] as List?)
              ?.map((u) => UserProfileModel.fromMap(
                  Map<String, dynamic>.from(u as Map)))
              .toList() ??
          [],
      total: (map['total'] as num?)?.toInt() ?? 0,
      page: (map['page'] as num?)?.toInt() ?? 1,
      pageSize: (map['pageSize'] as num?)?.toInt() ?? 20,
    );
  }

  /// Legacy compatibility alias
  factory SearchResultModel.fromJson(Map<String, dynamic> json) =
      SearchResultModel.fromMap;

  Map<String, dynamic> toMap() => {
        'users': users.map((u) => u.toMap()).toList(),
        'total': total,
        'page': page,
        'pageSize': pageSize,
      };
}
