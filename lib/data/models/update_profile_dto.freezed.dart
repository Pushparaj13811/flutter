// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateProfileDto _$UpdateProfileDtoFromJson(Map<String, dynamic> json) {
  return _UpdateProfileDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateProfileDto {
  String? get fullName => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  List<String>? get languages => throw _privateConstructorUsedError;
  List<SkillModel>? get skillsToTeach => throw _privateConstructorUsedError;
  List<SkillModel>? get skillsToLearn => throw _privateConstructorUsedError;
  List<String>? get interests => throw _privateConstructorUsedError;
  AvailabilityModel? get availability => throw _privateConstructorUsedError;
  String? get preferredLearningStyle => throw _privateConstructorUsedError;

  /// Serializes this UpdateProfileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateProfileDtoCopyWith<UpdateProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProfileDtoCopyWith<$Res> {
  factory $UpdateProfileDtoCopyWith(
    UpdateProfileDto value,
    $Res Function(UpdateProfileDto) then,
  ) = _$UpdateProfileDtoCopyWithImpl<$Res, UpdateProfileDto>;
  @useResult
  $Res call({
    String? fullName,
    String? bio,
    String? location,
    String? timezone,
    List<String>? languages,
    List<SkillModel>? skillsToTeach,
    List<SkillModel>? skillsToLearn,
    List<String>? interests,
    AvailabilityModel? availability,
    String? preferredLearningStyle,
  });

  $AvailabilityModelCopyWith<$Res>? get availability;
}

/// @nodoc
class _$UpdateProfileDtoCopyWithImpl<$Res, $Val extends UpdateProfileDto>
    implements $UpdateProfileDtoCopyWith<$Res> {
  _$UpdateProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? timezone = freezed,
    Object? languages = freezed,
    Object? skillsToTeach = freezed,
    Object? skillsToLearn = freezed,
    Object? interests = freezed,
    Object? availability = freezed,
    Object? preferredLearningStyle = freezed,
  }) {
    return _then(
      _value.copyWith(
            fullName: freezed == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            timezone: freezed == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String?,
            languages: freezed == languages
                ? _value.languages
                : languages // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            skillsToTeach: freezed == skillsToTeach
                ? _value.skillsToTeach
                : skillsToTeach // ignore: cast_nullable_to_non_nullable
                      as List<SkillModel>?,
            skillsToLearn: freezed == skillsToLearn
                ? _value.skillsToLearn
                : skillsToLearn // ignore: cast_nullable_to_non_nullable
                      as List<SkillModel>?,
            interests: freezed == interests
                ? _value.interests
                : interests // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            availability: freezed == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as AvailabilityModel?,
            preferredLearningStyle: freezed == preferredLearningStyle
                ? _value.preferredLearningStyle
                : preferredLearningStyle // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailabilityModelCopyWith<$Res>? get availability {
    if (_value.availability == null) {
      return null;
    }

    return $AvailabilityModelCopyWith<$Res>(_value.availability!, (value) {
      return _then(_value.copyWith(availability: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateProfileDtoImplCopyWith<$Res>
    implements $UpdateProfileDtoCopyWith<$Res> {
  factory _$$UpdateProfileDtoImplCopyWith(
    _$UpdateProfileDtoImpl value,
    $Res Function(_$UpdateProfileDtoImpl) then,
  ) = __$$UpdateProfileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? fullName,
    String? bio,
    String? location,
    String? timezone,
    List<String>? languages,
    List<SkillModel>? skillsToTeach,
    List<SkillModel>? skillsToLearn,
    List<String>? interests,
    AvailabilityModel? availability,
    String? preferredLearningStyle,
  });

  @override
  $AvailabilityModelCopyWith<$Res>? get availability;
}

/// @nodoc
class __$$UpdateProfileDtoImplCopyWithImpl<$Res>
    extends _$UpdateProfileDtoCopyWithImpl<$Res, _$UpdateProfileDtoImpl>
    implements _$$UpdateProfileDtoImplCopyWith<$Res> {
  __$$UpdateProfileDtoImplCopyWithImpl(
    _$UpdateProfileDtoImpl _value,
    $Res Function(_$UpdateProfileDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? timezone = freezed,
    Object? languages = freezed,
    Object? skillsToTeach = freezed,
    Object? skillsToLearn = freezed,
    Object? interests = freezed,
    Object? availability = freezed,
    Object? preferredLearningStyle = freezed,
  }) {
    return _then(
      _$UpdateProfileDtoImpl(
        fullName: freezed == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        timezone: freezed == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String?,
        languages: freezed == languages
            ? _value._languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        skillsToTeach: freezed == skillsToTeach
            ? _value._skillsToTeach
            : skillsToTeach // ignore: cast_nullable_to_non_nullable
                  as List<SkillModel>?,
        skillsToLearn: freezed == skillsToLearn
            ? _value._skillsToLearn
            : skillsToLearn // ignore: cast_nullable_to_non_nullable
                  as List<SkillModel>?,
        interests: freezed == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        availability: freezed == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as AvailabilityModel?,
        preferredLearningStyle: freezed == preferredLearningStyle
            ? _value.preferredLearningStyle
            : preferredLearningStyle // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateProfileDtoImpl implements _UpdateProfileDto {
  const _$UpdateProfileDtoImpl({
    this.fullName,
    this.bio,
    this.location,
    this.timezone,
    final List<String>? languages,
    final List<SkillModel>? skillsToTeach,
    final List<SkillModel>? skillsToLearn,
    final List<String>? interests,
    this.availability,
    this.preferredLearningStyle,
  }) : _languages = languages,
       _skillsToTeach = skillsToTeach,
       _skillsToLearn = skillsToLearn,
       _interests = interests;

  factory _$UpdateProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProfileDtoImplFromJson(json);

  @override
  final String? fullName;
  @override
  final String? bio;
  @override
  final String? location;
  @override
  final String? timezone;
  final List<String>? _languages;
  @override
  List<String>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SkillModel>? _skillsToTeach;
  @override
  List<SkillModel>? get skillsToTeach {
    final value = _skillsToTeach;
    if (value == null) return null;
    if (_skillsToTeach is EqualUnmodifiableListView) return _skillsToTeach;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SkillModel>? _skillsToLearn;
  @override
  List<SkillModel>? get skillsToLearn {
    final value = _skillsToLearn;
    if (value == null) return null;
    if (_skillsToLearn is EqualUnmodifiableListView) return _skillsToLearn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _interests;
  @override
  List<String>? get interests {
    final value = _interests;
    if (value == null) return null;
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final AvailabilityModel? availability;
  @override
  final String? preferredLearningStyle;

  @override
  String toString() {
    return 'UpdateProfileDto(fullName: $fullName, bio: $bio, location: $location, timezone: $timezone, languages: $languages, skillsToTeach: $skillsToTeach, skillsToLearn: $skillsToLearn, interests: $interests, availability: $availability, preferredLearningStyle: $preferredLearningStyle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileDtoImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            const DeepCollectionEquality().equals(
              other._languages,
              _languages,
            ) &&
            const DeepCollectionEquality().equals(
              other._skillsToTeach,
              _skillsToTeach,
            ) &&
            const DeepCollectionEquality().equals(
              other._skillsToLearn,
              _skillsToLearn,
            ) &&
            const DeepCollectionEquality().equals(
              other._interests,
              _interests,
            ) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.preferredLearningStyle, preferredLearningStyle) ||
                other.preferredLearningStyle == preferredLearningStyle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    bio,
    location,
    timezone,
    const DeepCollectionEquality().hash(_languages),
    const DeepCollectionEquality().hash(_skillsToTeach),
    const DeepCollectionEquality().hash(_skillsToLearn),
    const DeepCollectionEquality().hash(_interests),
    availability,
    preferredLearningStyle,
  );

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileDtoImplCopyWith<_$UpdateProfileDtoImpl> get copyWith =>
      __$$UpdateProfileDtoImplCopyWithImpl<_$UpdateProfileDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProfileDtoImplToJson(this);
  }
}

abstract class _UpdateProfileDto implements UpdateProfileDto {
  const factory _UpdateProfileDto({
    final String? fullName,
    final String? bio,
    final String? location,
    final String? timezone,
    final List<String>? languages,
    final List<SkillModel>? skillsToTeach,
    final List<SkillModel>? skillsToLearn,
    final List<String>? interests,
    final AvailabilityModel? availability,
    final String? preferredLearningStyle,
  }) = _$UpdateProfileDtoImpl;

  factory _UpdateProfileDto.fromJson(Map<String, dynamic> json) =
      _$UpdateProfileDtoImpl.fromJson;

  @override
  String? get fullName;
  @override
  String? get bio;
  @override
  String? get location;
  @override
  String? get timezone;
  @override
  List<String>? get languages;
  @override
  List<SkillModel>? get skillsToTeach;
  @override
  List<SkillModel>? get skillsToLearn;
  @override
  List<String>? get interests;
  @override
  AvailabilityModel? get availability;
  @override
  String? get preferredLearningStyle;

  /// Create a copy of UpdateProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProfileDtoImplCopyWith<_$UpdateProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
