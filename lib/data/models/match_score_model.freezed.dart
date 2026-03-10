// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_score_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MatchScoreModel _$MatchScoreModelFromJson(Map<String, dynamic> json) {
  return _MatchScoreModel.fromJson(json);
}

/// @nodoc
mixin _$MatchScoreModel {
  String get userId => throw _privateConstructorUsedError;
  UserProfileModel get profile => throw _privateConstructorUsedError;
  double get compatibilityScore => throw _privateConstructorUsedError;
  double get skillOverlapScore => throw _privateConstructorUsedError;
  double get availabilityScore => throw _privateConstructorUsedError;
  double get locationScore => throw _privateConstructorUsedError;
  double get languageScore => throw _privateConstructorUsedError;
  MatchedSkillsModel get matchedSkills => throw _privateConstructorUsedError;

  /// Serializes this MatchScoreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchScoreModelCopyWith<MatchScoreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchScoreModelCopyWith<$Res> {
  factory $MatchScoreModelCopyWith(
    MatchScoreModel value,
    $Res Function(MatchScoreModel) then,
  ) = _$MatchScoreModelCopyWithImpl<$Res, MatchScoreModel>;
  @useResult
  $Res call({
    String userId,
    UserProfileModel profile,
    double compatibilityScore,
    double skillOverlapScore,
    double availabilityScore,
    double locationScore,
    double languageScore,
    MatchedSkillsModel matchedSkills,
  });

  $UserProfileModelCopyWith<$Res> get profile;
  $MatchedSkillsModelCopyWith<$Res> get matchedSkills;
}

/// @nodoc
class _$MatchScoreModelCopyWithImpl<$Res, $Val extends MatchScoreModel>
    implements $MatchScoreModelCopyWith<$Res> {
  _$MatchScoreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? profile = null,
    Object? compatibilityScore = null,
    Object? skillOverlapScore = null,
    Object? availabilityScore = null,
    Object? locationScore = null,
    Object? languageScore = null,
    Object? matchedSkills = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            profile: null == profile
                ? _value.profile
                : profile // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel,
            compatibilityScore: null == compatibilityScore
                ? _value.compatibilityScore
                : compatibilityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            skillOverlapScore: null == skillOverlapScore
                ? _value.skillOverlapScore
                : skillOverlapScore // ignore: cast_nullable_to_non_nullable
                      as double,
            availabilityScore: null == availabilityScore
                ? _value.availabilityScore
                : availabilityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            locationScore: null == locationScore
                ? _value.locationScore
                : locationScore // ignore: cast_nullable_to_non_nullable
                      as double,
            languageScore: null == languageScore
                ? _value.languageScore
                : languageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            matchedSkills: null == matchedSkills
                ? _value.matchedSkills
                : matchedSkills // ignore: cast_nullable_to_non_nullable
                      as MatchedSkillsModel,
          )
          as $Val,
    );
  }

  /// Create a copy of MatchScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res> get profile {
    return $UserProfileModelCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  /// Create a copy of MatchScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchedSkillsModelCopyWith<$Res> get matchedSkills {
    return $MatchedSkillsModelCopyWith<$Res>(_value.matchedSkills, (value) {
      return _then(_value.copyWith(matchedSkills: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MatchScoreModelImplCopyWith<$Res>
    implements $MatchScoreModelCopyWith<$Res> {
  factory _$$MatchScoreModelImplCopyWith(
    _$MatchScoreModelImpl value,
    $Res Function(_$MatchScoreModelImpl) then,
  ) = __$$MatchScoreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    UserProfileModel profile,
    double compatibilityScore,
    double skillOverlapScore,
    double availabilityScore,
    double locationScore,
    double languageScore,
    MatchedSkillsModel matchedSkills,
  });

  @override
  $UserProfileModelCopyWith<$Res> get profile;
  @override
  $MatchedSkillsModelCopyWith<$Res> get matchedSkills;
}

/// @nodoc
class __$$MatchScoreModelImplCopyWithImpl<$Res>
    extends _$MatchScoreModelCopyWithImpl<$Res, _$MatchScoreModelImpl>
    implements _$$MatchScoreModelImplCopyWith<$Res> {
  __$$MatchScoreModelImplCopyWithImpl(
    _$MatchScoreModelImpl _value,
    $Res Function(_$MatchScoreModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? profile = null,
    Object? compatibilityScore = null,
    Object? skillOverlapScore = null,
    Object? availabilityScore = null,
    Object? locationScore = null,
    Object? languageScore = null,
    Object? matchedSkills = null,
  }) {
    return _then(
      _$MatchScoreModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        profile: null == profile
            ? _value.profile
            : profile // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel,
        compatibilityScore: null == compatibilityScore
            ? _value.compatibilityScore
            : compatibilityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        skillOverlapScore: null == skillOverlapScore
            ? _value.skillOverlapScore
            : skillOverlapScore // ignore: cast_nullable_to_non_nullable
                  as double,
        availabilityScore: null == availabilityScore
            ? _value.availabilityScore
            : availabilityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        locationScore: null == locationScore
            ? _value.locationScore
            : locationScore // ignore: cast_nullable_to_non_nullable
                  as double,
        languageScore: null == languageScore
            ? _value.languageScore
            : languageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        matchedSkills: null == matchedSkills
            ? _value.matchedSkills
            : matchedSkills // ignore: cast_nullable_to_non_nullable
                  as MatchedSkillsModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchScoreModelImpl implements _MatchScoreModel {
  const _$MatchScoreModelImpl({
    required this.userId,
    required this.profile,
    required this.compatibilityScore,
    required this.skillOverlapScore,
    required this.availabilityScore,
    required this.locationScore,
    required this.languageScore,
    required this.matchedSkills,
  });

  factory _$MatchScoreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchScoreModelImplFromJson(json);

  @override
  final String userId;
  @override
  final UserProfileModel profile;
  @override
  final double compatibilityScore;
  @override
  final double skillOverlapScore;
  @override
  final double availabilityScore;
  @override
  final double locationScore;
  @override
  final double languageScore;
  @override
  final MatchedSkillsModel matchedSkills;

  @override
  String toString() {
    return 'MatchScoreModel(userId: $userId, profile: $profile, compatibilityScore: $compatibilityScore, skillOverlapScore: $skillOverlapScore, availabilityScore: $availabilityScore, locationScore: $locationScore, languageScore: $languageScore, matchedSkills: $matchedSkills)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchScoreModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.compatibilityScore, compatibilityScore) ||
                other.compatibilityScore == compatibilityScore) &&
            (identical(other.skillOverlapScore, skillOverlapScore) ||
                other.skillOverlapScore == skillOverlapScore) &&
            (identical(other.availabilityScore, availabilityScore) ||
                other.availabilityScore == availabilityScore) &&
            (identical(other.locationScore, locationScore) ||
                other.locationScore == locationScore) &&
            (identical(other.languageScore, languageScore) ||
                other.languageScore == languageScore) &&
            (identical(other.matchedSkills, matchedSkills) ||
                other.matchedSkills == matchedSkills));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    profile,
    compatibilityScore,
    skillOverlapScore,
    availabilityScore,
    locationScore,
    languageScore,
    matchedSkills,
  );

  /// Create a copy of MatchScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchScoreModelImplCopyWith<_$MatchScoreModelImpl> get copyWith =>
      __$$MatchScoreModelImplCopyWithImpl<_$MatchScoreModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchScoreModelImplToJson(this);
  }
}

abstract class _MatchScoreModel implements MatchScoreModel {
  const factory _MatchScoreModel({
    required final String userId,
    required final UserProfileModel profile,
    required final double compatibilityScore,
    required final double skillOverlapScore,
    required final double availabilityScore,
    required final double locationScore,
    required final double languageScore,
    required final MatchedSkillsModel matchedSkills,
  }) = _$MatchScoreModelImpl;

  factory _MatchScoreModel.fromJson(Map<String, dynamic> json) =
      _$MatchScoreModelImpl.fromJson;

  @override
  String get userId;
  @override
  UserProfileModel get profile;
  @override
  double get compatibilityScore;
  @override
  double get skillOverlapScore;
  @override
  double get availabilityScore;
  @override
  double get locationScore;
  @override
  double get languageScore;
  @override
  MatchedSkillsModel get matchedSkills;

  /// Create a copy of MatchScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchScoreModelImplCopyWith<_$MatchScoreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MatchedSkillsModel _$MatchedSkillsModelFromJson(Map<String, dynamic> json) {
  return _MatchedSkillsModel.fromJson(json);
}

/// @nodoc
mixin _$MatchedSkillsModel {
  List<String> get theyTeach => throw _privateConstructorUsedError;
  List<String> get youTeach => throw _privateConstructorUsedError;

  /// Serializes this MatchedSkillsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MatchedSkillsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchedSkillsModelCopyWith<MatchedSkillsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchedSkillsModelCopyWith<$Res> {
  factory $MatchedSkillsModelCopyWith(
    MatchedSkillsModel value,
    $Res Function(MatchedSkillsModel) then,
  ) = _$MatchedSkillsModelCopyWithImpl<$Res, MatchedSkillsModel>;
  @useResult
  $Res call({List<String> theyTeach, List<String> youTeach});
}

/// @nodoc
class _$MatchedSkillsModelCopyWithImpl<$Res, $Val extends MatchedSkillsModel>
    implements $MatchedSkillsModelCopyWith<$Res> {
  _$MatchedSkillsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchedSkillsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? theyTeach = null, Object? youTeach = null}) {
    return _then(
      _value.copyWith(
            theyTeach: null == theyTeach
                ? _value.theyTeach
                : theyTeach // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            youTeach: null == youTeach
                ? _value.youTeach
                : youTeach // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MatchedSkillsModelImplCopyWith<$Res>
    implements $MatchedSkillsModelCopyWith<$Res> {
  factory _$$MatchedSkillsModelImplCopyWith(
    _$MatchedSkillsModelImpl value,
    $Res Function(_$MatchedSkillsModelImpl) then,
  ) = __$$MatchedSkillsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> theyTeach, List<String> youTeach});
}

/// @nodoc
class __$$MatchedSkillsModelImplCopyWithImpl<$Res>
    extends _$MatchedSkillsModelCopyWithImpl<$Res, _$MatchedSkillsModelImpl>
    implements _$$MatchedSkillsModelImplCopyWith<$Res> {
  __$$MatchedSkillsModelImplCopyWithImpl(
    _$MatchedSkillsModelImpl _value,
    $Res Function(_$MatchedSkillsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchedSkillsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? theyTeach = null, Object? youTeach = null}) {
    return _then(
      _$MatchedSkillsModelImpl(
        theyTeach: null == theyTeach
            ? _value._theyTeach
            : theyTeach // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        youTeach: null == youTeach
            ? _value._youTeach
            : youTeach // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MatchedSkillsModelImpl implements _MatchedSkillsModel {
  const _$MatchedSkillsModelImpl({
    final List<String> theyTeach = const [],
    final List<String> youTeach = const [],
  }) : _theyTeach = theyTeach,
       _youTeach = youTeach;

  factory _$MatchedSkillsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchedSkillsModelImplFromJson(json);

  final List<String> _theyTeach;
  @override
  @JsonKey()
  List<String> get theyTeach {
    if (_theyTeach is EqualUnmodifiableListView) return _theyTeach;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_theyTeach);
  }

  final List<String> _youTeach;
  @override
  @JsonKey()
  List<String> get youTeach {
    if (_youTeach is EqualUnmodifiableListView) return _youTeach;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_youTeach);
  }

  @override
  String toString() {
    return 'MatchedSkillsModel(theyTeach: $theyTeach, youTeach: $youTeach)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchedSkillsModelImpl &&
            const DeepCollectionEquality().equals(
              other._theyTeach,
              _theyTeach,
            ) &&
            const DeepCollectionEquality().equals(other._youTeach, _youTeach));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_theyTeach),
    const DeepCollectionEquality().hash(_youTeach),
  );

  /// Create a copy of MatchedSkillsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchedSkillsModelImplCopyWith<_$MatchedSkillsModelImpl> get copyWith =>
      __$$MatchedSkillsModelImplCopyWithImpl<_$MatchedSkillsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchedSkillsModelImplToJson(this);
  }
}

abstract class _MatchedSkillsModel implements MatchedSkillsModel {
  const factory _MatchedSkillsModel({
    final List<String> theyTeach,
    final List<String> youTeach,
  }) = _$MatchedSkillsModelImpl;

  factory _MatchedSkillsModel.fromJson(Map<String, dynamic> json) =
      _$MatchedSkillsModelImpl.fromJson;

  @override
  List<String> get theyTeach;
  @override
  List<String> get youTeach;

  /// Create a copy of MatchedSkillsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchedSkillsModelImplCopyWith<_$MatchedSkillsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
