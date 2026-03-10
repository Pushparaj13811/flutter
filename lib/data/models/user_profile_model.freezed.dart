// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) {
  return _UserProfileModel.fromJson(json);
}

/// @nodoc
mixin _$UserProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  List<String> get languages => throw _privateConstructorUsedError;
  List<SkillModel> get skillsToTeach => throw _privateConstructorUsedError;
  List<SkillModel> get skillsToLearn => throw _privateConstructorUsedError;
  List<String> get interests => throw _privateConstructorUsedError;
  AvailabilityModel get availability => throw _privateConstructorUsedError;
  String get preferredLearningStyle => throw _privateConstructorUsedError;
  String get joinedAt => throw _privateConstructorUsedError;
  String get lastActive => throw _privateConstructorUsedError;
  UserStatsModel get stats => throw _privateConstructorUsedError;

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileModelCopyWith<UserProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileModelCopyWith<$Res> {
  factory $UserProfileModelCopyWith(
    UserProfileModel value,
    $Res Function(UserProfileModel) then,
  ) = _$UserProfileModelCopyWithImpl<$Res, UserProfileModel>;
  @useResult
  $Res call({
    String id,
    String username,
    String email,
    String fullName,
    String? avatar,
    String? bio,
    String? location,
    String? timezone,
    List<String> languages,
    List<SkillModel> skillsToTeach,
    List<SkillModel> skillsToLearn,
    List<String> interests,
    AvailabilityModel availability,
    String preferredLearningStyle,
    String joinedAt,
    String lastActive,
    UserStatsModel stats,
  });

  $AvailabilityModelCopyWith<$Res> get availability;
  $UserStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res, $Val extends UserProfileModel>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? fullName = null,
    Object? avatar = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? timezone = freezed,
    Object? languages = null,
    Object? skillsToTeach = null,
    Object? skillsToLearn = null,
    Object? interests = null,
    Object? availability = null,
    Object? preferredLearningStyle = null,
    Object? joinedAt = null,
    Object? lastActive = null,
    Object? stats = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
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
            languages: null == languages
                ? _value.languages
                : languages // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            skillsToTeach: null == skillsToTeach
                ? _value.skillsToTeach
                : skillsToTeach // ignore: cast_nullable_to_non_nullable
                      as List<SkillModel>,
            skillsToLearn: null == skillsToLearn
                ? _value.skillsToLearn
                : skillsToLearn // ignore: cast_nullable_to_non_nullable
                      as List<SkillModel>,
            interests: null == interests
                ? _value.interests
                : interests // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            availability: null == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as AvailabilityModel,
            preferredLearningStyle: null == preferredLearningStyle
                ? _value.preferredLearningStyle
                : preferredLearningStyle // ignore: cast_nullable_to_non_nullable
                      as String,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            lastActive: null == lastActive
                ? _value.lastActive
                : lastActive // ignore: cast_nullable_to_non_nullable
                      as String,
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as UserStatsModel,
          )
          as $Val,
    );
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AvailabilityModelCopyWith<$Res> get availability {
    return $AvailabilityModelCopyWith<$Res>(_value.availability, (value) {
      return _then(_value.copyWith(availability: value) as $Val);
    });
  }

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStatsModelCopyWith<$Res> get stats {
    return $UserStatsModelCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserProfileModelImplCopyWith<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  factory _$$UserProfileModelImplCopyWith(
    _$UserProfileModelImpl value,
    $Res Function(_$UserProfileModelImpl) then,
  ) = __$$UserProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String username,
    String email,
    String fullName,
    String? avatar,
    String? bio,
    String? location,
    String? timezone,
    List<String> languages,
    List<SkillModel> skillsToTeach,
    List<SkillModel> skillsToLearn,
    List<String> interests,
    AvailabilityModel availability,
    String preferredLearningStyle,
    String joinedAt,
    String lastActive,
    UserStatsModel stats,
  });

  @override
  $AvailabilityModelCopyWith<$Res> get availability;
  @override
  $UserStatsModelCopyWith<$Res> get stats;
}

/// @nodoc
class __$$UserProfileModelImplCopyWithImpl<$Res>
    extends _$UserProfileModelCopyWithImpl<$Res, _$UserProfileModelImpl>
    implements _$$UserProfileModelImplCopyWith<$Res> {
  __$$UserProfileModelImplCopyWithImpl(
    _$UserProfileModelImpl _value,
    $Res Function(_$UserProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? email = null,
    Object? fullName = null,
    Object? avatar = freezed,
    Object? bio = freezed,
    Object? location = freezed,
    Object? timezone = freezed,
    Object? languages = null,
    Object? skillsToTeach = null,
    Object? skillsToLearn = null,
    Object? interests = null,
    Object? availability = null,
    Object? preferredLearningStyle = null,
    Object? joinedAt = null,
    Object? lastActive = null,
    Object? stats = null,
  }) {
    return _then(
      _$UserProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
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
        languages: null == languages
            ? _value._languages
            : languages // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        skillsToTeach: null == skillsToTeach
            ? _value._skillsToTeach
            : skillsToTeach // ignore: cast_nullable_to_non_nullable
                  as List<SkillModel>,
        skillsToLearn: null == skillsToLearn
            ? _value._skillsToLearn
            : skillsToLearn // ignore: cast_nullable_to_non_nullable
                  as List<SkillModel>,
        interests: null == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        availability: null == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as AvailabilityModel,
        preferredLearningStyle: null == preferredLearningStyle
            ? _value.preferredLearningStyle
            : preferredLearningStyle // ignore: cast_nullable_to_non_nullable
                  as String,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        lastActive: null == lastActive
            ? _value.lastActive
            : lastActive // ignore: cast_nullable_to_non_nullable
                  as String,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as UserStatsModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileModelImpl implements _UserProfileModel {
  const _$UserProfileModelImpl({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.avatar,
    this.bio,
    this.location,
    this.timezone,
    final List<String> languages = const [],
    final List<SkillModel> skillsToTeach = const [],
    final List<SkillModel> skillsToLearn = const [],
    final List<String> interests = const [],
    required this.availability,
    this.preferredLearningStyle = 'visual',
    required this.joinedAt,
    required this.lastActive,
    required this.stats,
  }) : _languages = languages,
       _skillsToTeach = skillsToTeach,
       _skillsToLearn = skillsToLearn,
       _interests = interests;

  factory _$UserProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String email;
  @override
  final String fullName;
  @override
  final String? avatar;
  @override
  final String? bio;
  @override
  final String? location;
  @override
  final String? timezone;
  final List<String> _languages;
  @override
  @JsonKey()
  List<String> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  final List<SkillModel> _skillsToTeach;
  @override
  @JsonKey()
  List<SkillModel> get skillsToTeach {
    if (_skillsToTeach is EqualUnmodifiableListView) return _skillsToTeach;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsToTeach);
  }

  final List<SkillModel> _skillsToLearn;
  @override
  @JsonKey()
  List<SkillModel> get skillsToLearn {
    if (_skillsToLearn is EqualUnmodifiableListView) return _skillsToLearn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsToLearn);
  }

  final List<String> _interests;
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  final AvailabilityModel availability;
  @override
  @JsonKey()
  final String preferredLearningStyle;
  @override
  final String joinedAt;
  @override
  final String lastActive;
  @override
  final UserStatsModel stats;

  @override
  String toString() {
    return 'UserProfileModel(id: $id, username: $username, email: $email, fullName: $fullName, avatar: $avatar, bio: $bio, location: $location, timezone: $timezone, languages: $languages, skillsToTeach: $skillsToTeach, skillsToLearn: $skillsToLearn, interests: $interests, availability: $availability, preferredLearningStyle: $preferredLearningStyle, joinedAt: $joinedAt, lastActive: $lastActive, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
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
                other.preferredLearningStyle == preferredLearningStyle) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.lastActive, lastActive) ||
                other.lastActive == lastActive) &&
            (identical(other.stats, stats) || other.stats == stats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    email,
    fullName,
    avatar,
    bio,
    location,
    timezone,
    const DeepCollectionEquality().hash(_languages),
    const DeepCollectionEquality().hash(_skillsToTeach),
    const DeepCollectionEquality().hash(_skillsToLearn),
    const DeepCollectionEquality().hash(_interests),
    availability,
    preferredLearningStyle,
    joinedAt,
    lastActive,
    stats,
  );

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      __$$UserProfileModelImplCopyWithImpl<_$UserProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileModelImplToJson(this);
  }
}

abstract class _UserProfileModel implements UserProfileModel {
  const factory _UserProfileModel({
    required final String id,
    required final String username,
    required final String email,
    required final String fullName,
    final String? avatar,
    final String? bio,
    final String? location,
    final String? timezone,
    final List<String> languages,
    final List<SkillModel> skillsToTeach,
    final List<SkillModel> skillsToLearn,
    final List<String> interests,
    required final AvailabilityModel availability,
    final String preferredLearningStyle,
    required final String joinedAt,
    required final String lastActive,
    required final UserStatsModel stats,
  }) = _$UserProfileModelImpl;

  factory _UserProfileModel.fromJson(Map<String, dynamic> json) =
      _$UserProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get email;
  @override
  String get fullName;
  @override
  String? get avatar;
  @override
  String? get bio;
  @override
  String? get location;
  @override
  String? get timezone;
  @override
  List<String> get languages;
  @override
  List<SkillModel> get skillsToTeach;
  @override
  List<SkillModel> get skillsToLearn;
  @override
  List<String> get interests;
  @override
  AvailabilityModel get availability;
  @override
  String get preferredLearningStyle;
  @override
  String get joinedAt;
  @override
  String get lastActive;
  @override
  UserStatsModel get stats;

  /// Create a copy of UserProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileModelImplCopyWith<_$UserProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailabilityModel _$AvailabilityModelFromJson(Map<String, dynamic> json) {
  return _AvailabilityModel.fromJson(json);
}

/// @nodoc
mixin _$AvailabilityModel {
  bool get monday => throw _privateConstructorUsedError;
  bool get tuesday => throw _privateConstructorUsedError;
  bool get wednesday => throw _privateConstructorUsedError;
  bool get thursday => throw _privateConstructorUsedError;
  bool get friday => throw _privateConstructorUsedError;
  bool get saturday => throw _privateConstructorUsedError;
  bool get sunday => throw _privateConstructorUsedError;

  /// Serializes this AvailabilityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailabilityModelCopyWith<AvailabilityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailabilityModelCopyWith<$Res> {
  factory $AvailabilityModelCopyWith(
    AvailabilityModel value,
    $Res Function(AvailabilityModel) then,
  ) = _$AvailabilityModelCopyWithImpl<$Res, AvailabilityModel>;
  @useResult
  $Res call({
    bool monday,
    bool tuesday,
    bool wednesday,
    bool thursday,
    bool friday,
    bool saturday,
    bool sunday,
  });
}

/// @nodoc
class _$AvailabilityModelCopyWithImpl<$Res, $Val extends AvailabilityModel>
    implements $AvailabilityModelCopyWith<$Res> {
  _$AvailabilityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
  }) {
    return _then(
      _value.copyWith(
            monday: null == monday
                ? _value.monday
                : monday // ignore: cast_nullable_to_non_nullable
                      as bool,
            tuesday: null == tuesday
                ? _value.tuesday
                : tuesday // ignore: cast_nullable_to_non_nullable
                      as bool,
            wednesday: null == wednesday
                ? _value.wednesday
                : wednesday // ignore: cast_nullable_to_non_nullable
                      as bool,
            thursday: null == thursday
                ? _value.thursday
                : thursday // ignore: cast_nullable_to_non_nullable
                      as bool,
            friday: null == friday
                ? _value.friday
                : friday // ignore: cast_nullable_to_non_nullable
                      as bool,
            saturday: null == saturday
                ? _value.saturday
                : saturday // ignore: cast_nullable_to_non_nullable
                      as bool,
            sunday: null == sunday
                ? _value.sunday
                : sunday // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailabilityModelImplCopyWith<$Res>
    implements $AvailabilityModelCopyWith<$Res> {
  factory _$$AvailabilityModelImplCopyWith(
    _$AvailabilityModelImpl value,
    $Res Function(_$AvailabilityModelImpl) then,
  ) = __$$AvailabilityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool monday,
    bool tuesday,
    bool wednesday,
    bool thursday,
    bool friday,
    bool saturday,
    bool sunday,
  });
}

/// @nodoc
class __$$AvailabilityModelImplCopyWithImpl<$Res>
    extends _$AvailabilityModelCopyWithImpl<$Res, _$AvailabilityModelImpl>
    implements _$$AvailabilityModelImplCopyWith<$Res> {
  __$$AvailabilityModelImplCopyWithImpl(
    _$AvailabilityModelImpl _value,
    $Res Function(_$AvailabilityModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
  }) {
    return _then(
      _$AvailabilityModelImpl(
        monday: null == monday
            ? _value.monday
            : monday // ignore: cast_nullable_to_non_nullable
                  as bool,
        tuesday: null == tuesday
            ? _value.tuesday
            : tuesday // ignore: cast_nullable_to_non_nullable
                  as bool,
        wednesday: null == wednesday
            ? _value.wednesday
            : wednesday // ignore: cast_nullable_to_non_nullable
                  as bool,
        thursday: null == thursday
            ? _value.thursday
            : thursday // ignore: cast_nullable_to_non_nullable
                  as bool,
        friday: null == friday
            ? _value.friday
            : friday // ignore: cast_nullable_to_non_nullable
                  as bool,
        saturday: null == saturday
            ? _value.saturday
            : saturday // ignore: cast_nullable_to_non_nullable
                  as bool,
        sunday: null == sunday
            ? _value.sunday
            : sunday // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailabilityModelImpl implements _AvailabilityModel {
  const _$AvailabilityModelImpl({
    this.monday = false,
    this.tuesday = false,
    this.wednesday = false,
    this.thursday = false,
    this.friday = false,
    this.saturday = false,
    this.sunday = false,
  });

  factory _$AvailabilityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailabilityModelImplFromJson(json);

  @override
  @JsonKey()
  final bool monday;
  @override
  @JsonKey()
  final bool tuesday;
  @override
  @JsonKey()
  final bool wednesday;
  @override
  @JsonKey()
  final bool thursday;
  @override
  @JsonKey()
  final bool friday;
  @override
  @JsonKey()
  final bool saturday;
  @override
  @JsonKey()
  final bool sunday;

  @override
  String toString() {
    return 'AvailabilityModel(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailabilityModelImpl &&
            (identical(other.monday, monday) || other.monday == monday) &&
            (identical(other.tuesday, tuesday) || other.tuesday == tuesday) &&
            (identical(other.wednesday, wednesday) ||
                other.wednesday == wednesday) &&
            (identical(other.thursday, thursday) ||
                other.thursday == thursday) &&
            (identical(other.friday, friday) || other.friday == friday) &&
            (identical(other.saturday, saturday) ||
                other.saturday == saturday) &&
            (identical(other.sunday, sunday) || other.sunday == sunday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
  );

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailabilityModelImplCopyWith<_$AvailabilityModelImpl> get copyWith =>
      __$$AvailabilityModelImplCopyWithImpl<_$AvailabilityModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailabilityModelImplToJson(this);
  }
}

abstract class _AvailabilityModel implements AvailabilityModel {
  const factory _AvailabilityModel({
    final bool monday,
    final bool tuesday,
    final bool wednesday,
    final bool thursday,
    final bool friday,
    final bool saturday,
    final bool sunday,
  }) = _$AvailabilityModelImpl;

  factory _AvailabilityModel.fromJson(Map<String, dynamic> json) =
      _$AvailabilityModelImpl.fromJson;

  @override
  bool get monday;
  @override
  bool get tuesday;
  @override
  bool get wednesday;
  @override
  bool get thursday;
  @override
  bool get friday;
  @override
  bool get saturday;
  @override
  bool get sunday;

  /// Create a copy of AvailabilityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailabilityModelImplCopyWith<_$AvailabilityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) {
  return _UserStatsModel.fromJson(json);
}

/// @nodoc
mixin _$UserStatsModel {
  int get connectionsCount => throw _privateConstructorUsedError;
  int get sessionsCompleted => throw _privateConstructorUsedError;
  int get reviewsReceived => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;

  /// Serializes this UserStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsModelCopyWith<UserStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsModelCopyWith<$Res> {
  factory $UserStatsModelCopyWith(
    UserStatsModel value,
    $Res Function(UserStatsModel) then,
  ) = _$UserStatsModelCopyWithImpl<$Res, UserStatsModel>;
  @useResult
  $Res call({
    int connectionsCount,
    int sessionsCompleted,
    int reviewsReceived,
    double averageRating,
  });
}

/// @nodoc
class _$UserStatsModelCopyWithImpl<$Res, $Val extends UserStatsModel>
    implements $UserStatsModelCopyWith<$Res> {
  _$UserStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionsCount = null,
    Object? sessionsCompleted = null,
    Object? reviewsReceived = null,
    Object? averageRating = null,
  }) {
    return _then(
      _value.copyWith(
            connectionsCount: null == connectionsCount
                ? _value.connectionsCount
                : connectionsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionsCompleted: null == sessionsCompleted
                ? _value.sessionsCompleted
                : sessionsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewsReceived: null == reviewsReceived
                ? _value.reviewsReceived
                : reviewsReceived // ignore: cast_nullable_to_non_nullable
                      as int,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserStatsModelImplCopyWith<$Res>
    implements $UserStatsModelCopyWith<$Res> {
  factory _$$UserStatsModelImplCopyWith(
    _$UserStatsModelImpl value,
    $Res Function(_$UserStatsModelImpl) then,
  ) = __$$UserStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int connectionsCount,
    int sessionsCompleted,
    int reviewsReceived,
    double averageRating,
  });
}

/// @nodoc
class __$$UserStatsModelImplCopyWithImpl<$Res>
    extends _$UserStatsModelCopyWithImpl<$Res, _$UserStatsModelImpl>
    implements _$$UserStatsModelImplCopyWith<$Res> {
  __$$UserStatsModelImplCopyWithImpl(
    _$UserStatsModelImpl _value,
    $Res Function(_$UserStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionsCount = null,
    Object? sessionsCompleted = null,
    Object? reviewsReceived = null,
    Object? averageRating = null,
  }) {
    return _then(
      _$UserStatsModelImpl(
        connectionsCount: null == connectionsCount
            ? _value.connectionsCount
            : connectionsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionsCompleted: null == sessionsCompleted
            ? _value.sessionsCompleted
            : sessionsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewsReceived: null == reviewsReceived
            ? _value.reviewsReceived
            : reviewsReceived // ignore: cast_nullable_to_non_nullable
                  as int,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsModelImpl implements _UserStatsModel {
  const _$UserStatsModelImpl({
    this.connectionsCount = 0,
    this.sessionsCompleted = 0,
    this.reviewsReceived = 0,
    this.averageRating = 0.0,
  });

  factory _$UserStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final int connectionsCount;
  @override
  @JsonKey()
  final int sessionsCompleted;
  @override
  @JsonKey()
  final int reviewsReceived;
  @override
  @JsonKey()
  final double averageRating;

  @override
  String toString() {
    return 'UserStatsModel(connectionsCount: $connectionsCount, sessionsCompleted: $sessionsCompleted, reviewsReceived: $reviewsReceived, averageRating: $averageRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsModelImpl &&
            (identical(other.connectionsCount, connectionsCount) ||
                other.connectionsCount == connectionsCount) &&
            (identical(other.sessionsCompleted, sessionsCompleted) ||
                other.sessionsCompleted == sessionsCompleted) &&
            (identical(other.reviewsReceived, reviewsReceived) ||
                other.reviewsReceived == reviewsReceived) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    connectionsCount,
    sessionsCompleted,
    reviewsReceived,
    averageRating,
  );

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      __$$UserStatsModelImplCopyWithImpl<_$UserStatsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsModelImplToJson(this);
  }
}

abstract class _UserStatsModel implements UserStatsModel {
  const factory _UserStatsModel({
    final int connectionsCount,
    final int sessionsCompleted,
    final int reviewsReceived,
    final double averageRating,
  }) = _$UserStatsModelImpl;

  factory _UserStatsModel.fromJson(Map<String, dynamic> json) =
      _$UserStatsModelImpl.fromJson;

  @override
  int get connectionsCount;
  @override
  int get sessionsCompleted;
  @override
  int get reviewsReceived;
  @override
  double get averageRating;

  /// Create a copy of UserStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsModelImplCopyWith<_$UserStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
