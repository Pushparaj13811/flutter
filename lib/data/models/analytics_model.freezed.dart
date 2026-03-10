// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsModel _$AnalyticsModelFromJson(Map<String, dynamic> json) {
  return _AnalyticsModel.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsModel {
  AnalyticsOverview get overview => throw _privateConstructorUsedError;
  List<SkillPopularity> get popularSkills => throw _privateConstructorUsedError;
  List<WeeklyActivity> get weeklyActivity => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsModelCopyWith<AnalyticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsModelCopyWith<$Res> {
  factory $AnalyticsModelCopyWith(
    AnalyticsModel value,
    $Res Function(AnalyticsModel) then,
  ) = _$AnalyticsModelCopyWithImpl<$Res, AnalyticsModel>;
  @useResult
  $Res call({
    AnalyticsOverview overview,
    List<SkillPopularity> popularSkills,
    List<WeeklyActivity> weeklyActivity,
  });

  $AnalyticsOverviewCopyWith<$Res> get overview;
}

/// @nodoc
class _$AnalyticsModelCopyWithImpl<$Res, $Val extends AnalyticsModel>
    implements $AnalyticsModelCopyWith<$Res> {
  _$AnalyticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? popularSkills = null,
    Object? weeklyActivity = null,
  }) {
    return _then(
      _value.copyWith(
            overview: null == overview
                ? _value.overview
                : overview // ignore: cast_nullable_to_non_nullable
                      as AnalyticsOverview,
            popularSkills: null == popularSkills
                ? _value.popularSkills
                : popularSkills // ignore: cast_nullable_to_non_nullable
                      as List<SkillPopularity>,
            weeklyActivity: null == weeklyActivity
                ? _value.weeklyActivity
                : weeklyActivity // ignore: cast_nullable_to_non_nullable
                      as List<WeeklyActivity>,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsOverviewCopyWith<$Res> get overview {
    return $AnalyticsOverviewCopyWith<$Res>(_value.overview, (value) {
      return _then(_value.copyWith(overview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsModelImplCopyWith<$Res>
    implements $AnalyticsModelCopyWith<$Res> {
  factory _$$AnalyticsModelImplCopyWith(
    _$AnalyticsModelImpl value,
    $Res Function(_$AnalyticsModelImpl) then,
  ) = __$$AnalyticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AnalyticsOverview overview,
    List<SkillPopularity> popularSkills,
    List<WeeklyActivity> weeklyActivity,
  });

  @override
  $AnalyticsOverviewCopyWith<$Res> get overview;
}

/// @nodoc
class __$$AnalyticsModelImplCopyWithImpl<$Res>
    extends _$AnalyticsModelCopyWithImpl<$Res, _$AnalyticsModelImpl>
    implements _$$AnalyticsModelImplCopyWith<$Res> {
  __$$AnalyticsModelImplCopyWithImpl(
    _$AnalyticsModelImpl _value,
    $Res Function(_$AnalyticsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overview = null,
    Object? popularSkills = null,
    Object? weeklyActivity = null,
  }) {
    return _then(
      _$AnalyticsModelImpl(
        overview: null == overview
            ? _value.overview
            : overview // ignore: cast_nullable_to_non_nullable
                  as AnalyticsOverview,
        popularSkills: null == popularSkills
            ? _value._popularSkills
            : popularSkills // ignore: cast_nullable_to_non_nullable
                  as List<SkillPopularity>,
        weeklyActivity: null == weeklyActivity
            ? _value._weeklyActivity
            : weeklyActivity // ignore: cast_nullable_to_non_nullable
                  as List<WeeklyActivity>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsModelImpl implements _AnalyticsModel {
  const _$AnalyticsModelImpl({
    required this.overview,
    final List<SkillPopularity> popularSkills = const [],
    final List<WeeklyActivity> weeklyActivity = const [],
  }) : _popularSkills = popularSkills,
       _weeklyActivity = weeklyActivity;

  factory _$AnalyticsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsModelImplFromJson(json);

  @override
  final AnalyticsOverview overview;
  final List<SkillPopularity> _popularSkills;
  @override
  @JsonKey()
  List<SkillPopularity> get popularSkills {
    if (_popularSkills is EqualUnmodifiableListView) return _popularSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularSkills);
  }

  final List<WeeklyActivity> _weeklyActivity;
  @override
  @JsonKey()
  List<WeeklyActivity> get weeklyActivity {
    if (_weeklyActivity is EqualUnmodifiableListView) return _weeklyActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyActivity);
  }

  @override
  String toString() {
    return 'AnalyticsModel(overview: $overview, popularSkills: $popularSkills, weeklyActivity: $weeklyActivity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsModelImpl &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            const DeepCollectionEquality().equals(
              other._popularSkills,
              _popularSkills,
            ) &&
            const DeepCollectionEquality().equals(
              other._weeklyActivity,
              _weeklyActivity,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    overview,
    const DeepCollectionEquality().hash(_popularSkills),
    const DeepCollectionEquality().hash(_weeklyActivity),
  );

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsModelImplCopyWith<_$AnalyticsModelImpl> get copyWith =>
      __$$AnalyticsModelImplCopyWithImpl<_$AnalyticsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsModelImplToJson(this);
  }
}

abstract class _AnalyticsModel implements AnalyticsModel {
  const factory _AnalyticsModel({
    required final AnalyticsOverview overview,
    final List<SkillPopularity> popularSkills,
    final List<WeeklyActivity> weeklyActivity,
  }) = _$AnalyticsModelImpl;

  factory _AnalyticsModel.fromJson(Map<String, dynamic> json) =
      _$AnalyticsModelImpl.fromJson;

  @override
  AnalyticsOverview get overview;
  @override
  List<SkillPopularity> get popularSkills;
  @override
  List<WeeklyActivity> get weeklyActivity;

  /// Create a copy of AnalyticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsModelImplCopyWith<_$AnalyticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsOverview _$AnalyticsOverviewFromJson(Map<String, dynamic> json) {
  return _AnalyticsOverview.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsOverview {
  int get totalUsers => throw _privateConstructorUsedError;
  int get activeUsers => throw _privateConstructorUsedError;
  int get totalSessions => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  int get newUsersThisWeek => throw _privateConstructorUsedError;
  int get sessionsThisWeek => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsOverviewCopyWith<AnalyticsOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsOverviewCopyWith<$Res> {
  factory $AnalyticsOverviewCopyWith(
    AnalyticsOverview value,
    $Res Function(AnalyticsOverview) then,
  ) = _$AnalyticsOverviewCopyWithImpl<$Res, AnalyticsOverview>;
  @useResult
  $Res call({
    int totalUsers,
    int activeUsers,
    int totalSessions,
    double completionRate,
    int newUsersThisWeek,
    int sessionsThisWeek,
  });
}

/// @nodoc
class _$AnalyticsOverviewCopyWithImpl<$Res, $Val extends AnalyticsOverview>
    implements $AnalyticsOverviewCopyWith<$Res> {
  _$AnalyticsOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalSessions = null,
    Object? completionRate = null,
    Object? newUsersThisWeek = null,
    Object? sessionsThisWeek = null,
  }) {
    return _then(
      _value.copyWith(
            totalUsers: null == totalUsers
                ? _value.totalUsers
                : totalUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            activeUsers: null == activeUsers
                ? _value.activeUsers
                : activeUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSessions: null == totalSessions
                ? _value.totalSessions
                : totalSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            newUsersThisWeek: null == newUsersThisWeek
                ? _value.newUsersThisWeek
                : newUsersThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionsThisWeek: null == sessionsThisWeek
                ? _value.sessionsThisWeek
                : sessionsThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsOverviewImplCopyWith<$Res>
    implements $AnalyticsOverviewCopyWith<$Res> {
  factory _$$AnalyticsOverviewImplCopyWith(
    _$AnalyticsOverviewImpl value,
    $Res Function(_$AnalyticsOverviewImpl) then,
  ) = __$$AnalyticsOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalUsers,
    int activeUsers,
    int totalSessions,
    double completionRate,
    int newUsersThisWeek,
    int sessionsThisWeek,
  });
}

/// @nodoc
class __$$AnalyticsOverviewImplCopyWithImpl<$Res>
    extends _$AnalyticsOverviewCopyWithImpl<$Res, _$AnalyticsOverviewImpl>
    implements _$$AnalyticsOverviewImplCopyWith<$Res> {
  __$$AnalyticsOverviewImplCopyWithImpl(
    _$AnalyticsOverviewImpl _value,
    $Res Function(_$AnalyticsOverviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalSessions = null,
    Object? completionRate = null,
    Object? newUsersThisWeek = null,
    Object? sessionsThisWeek = null,
  }) {
    return _then(
      _$AnalyticsOverviewImpl(
        totalUsers: null == totalUsers
            ? _value.totalUsers
            : totalUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        activeUsers: null == activeUsers
            ? _value.activeUsers
            : activeUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSessions: null == totalSessions
            ? _value.totalSessions
            : totalSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        newUsersThisWeek: null == newUsersThisWeek
            ? _value.newUsersThisWeek
            : newUsersThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionsThisWeek: null == sessionsThisWeek
            ? _value.sessionsThisWeek
            : sessionsThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsOverviewImpl implements _AnalyticsOverview {
  const _$AnalyticsOverviewImpl({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.totalSessions = 0,
    this.completionRate = 0.0,
    this.newUsersThisWeek = 0,
    this.sessionsThisWeek = 0,
  });

  factory _$AnalyticsOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsOverviewImplFromJson(json);

  @override
  @JsonKey()
  final int totalUsers;
  @override
  @JsonKey()
  final int activeUsers;
  @override
  @JsonKey()
  final int totalSessions;
  @override
  @JsonKey()
  final double completionRate;
  @override
  @JsonKey()
  final int newUsersThisWeek;
  @override
  @JsonKey()
  final int sessionsThisWeek;

  @override
  String toString() {
    return 'AnalyticsOverview(totalUsers: $totalUsers, activeUsers: $activeUsers, totalSessions: $totalSessions, completionRate: $completionRate, newUsersThisWeek: $newUsersThisWeek, sessionsThisWeek: $sessionsThisWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsOverviewImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.totalSessions, totalSessions) ||
                other.totalSessions == totalSessions) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.newUsersThisWeek, newUsersThisWeek) ||
                other.newUsersThisWeek == newUsersThisWeek) &&
            (identical(other.sessionsThisWeek, sessionsThisWeek) ||
                other.sessionsThisWeek == sessionsThisWeek));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalUsers,
    activeUsers,
    totalSessions,
    completionRate,
    newUsersThisWeek,
    sessionsThisWeek,
  );

  /// Create a copy of AnalyticsOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsOverviewImplCopyWith<_$AnalyticsOverviewImpl> get copyWith =>
      __$$AnalyticsOverviewImplCopyWithImpl<_$AnalyticsOverviewImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsOverviewImplToJson(this);
  }
}

abstract class _AnalyticsOverview implements AnalyticsOverview {
  const factory _AnalyticsOverview({
    final int totalUsers,
    final int activeUsers,
    final int totalSessions,
    final double completionRate,
    final int newUsersThisWeek,
    final int sessionsThisWeek,
  }) = _$AnalyticsOverviewImpl;

  factory _AnalyticsOverview.fromJson(Map<String, dynamic> json) =
      _$AnalyticsOverviewImpl.fromJson;

  @override
  int get totalUsers;
  @override
  int get activeUsers;
  @override
  int get totalSessions;
  @override
  double get completionRate;
  @override
  int get newUsersThisWeek;
  @override
  int get sessionsThisWeek;

  /// Create a copy of AnalyticsOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsOverviewImplCopyWith<_$AnalyticsOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SkillPopularity _$SkillPopularityFromJson(Map<String, dynamic> json) {
  return _SkillPopularity.fromJson(json);
}

/// @nodoc
mixin _$SkillPopularity {
  String get name => throw _privateConstructorUsedError;
  int get teachCount => throw _privateConstructorUsedError;
  int get learnCount => throw _privateConstructorUsedError;

  /// Serializes this SkillPopularity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SkillPopularity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SkillPopularityCopyWith<SkillPopularity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillPopularityCopyWith<$Res> {
  factory $SkillPopularityCopyWith(
    SkillPopularity value,
    $Res Function(SkillPopularity) then,
  ) = _$SkillPopularityCopyWithImpl<$Res, SkillPopularity>;
  @useResult
  $Res call({String name, int teachCount, int learnCount});
}

/// @nodoc
class _$SkillPopularityCopyWithImpl<$Res, $Val extends SkillPopularity>
    implements $SkillPopularityCopyWith<$Res> {
  _$SkillPopularityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillPopularity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? teachCount = null,
    Object? learnCount = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            teachCount: null == teachCount
                ? _value.teachCount
                : teachCount // ignore: cast_nullable_to_non_nullable
                      as int,
            learnCount: null == learnCount
                ? _value.learnCount
                : learnCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SkillPopularityImplCopyWith<$Res>
    implements $SkillPopularityCopyWith<$Res> {
  factory _$$SkillPopularityImplCopyWith(
    _$SkillPopularityImpl value,
    $Res Function(_$SkillPopularityImpl) then,
  ) = __$$SkillPopularityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int teachCount, int learnCount});
}

/// @nodoc
class __$$SkillPopularityImplCopyWithImpl<$Res>
    extends _$SkillPopularityCopyWithImpl<$Res, _$SkillPopularityImpl>
    implements _$$SkillPopularityImplCopyWith<$Res> {
  __$$SkillPopularityImplCopyWithImpl(
    _$SkillPopularityImpl _value,
    $Res Function(_$SkillPopularityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillPopularity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? teachCount = null,
    Object? learnCount = null,
  }) {
    return _then(
      _$SkillPopularityImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        teachCount: null == teachCount
            ? _value.teachCount
            : teachCount // ignore: cast_nullable_to_non_nullable
                  as int,
        learnCount: null == learnCount
            ? _value.learnCount
            : learnCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillPopularityImpl implements _SkillPopularity {
  const _$SkillPopularityImpl({
    required this.name,
    this.teachCount = 0,
    this.learnCount = 0,
  });

  factory _$SkillPopularityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillPopularityImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final int teachCount;
  @override
  @JsonKey()
  final int learnCount;

  @override
  String toString() {
    return 'SkillPopularity(name: $name, teachCount: $teachCount, learnCount: $learnCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillPopularityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teachCount, teachCount) ||
                other.teachCount == teachCount) &&
            (identical(other.learnCount, learnCount) ||
                other.learnCount == learnCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, teachCount, learnCount);

  /// Create a copy of SkillPopularity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillPopularityImplCopyWith<_$SkillPopularityImpl> get copyWith =>
      __$$SkillPopularityImplCopyWithImpl<_$SkillPopularityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillPopularityImplToJson(this);
  }
}

abstract class _SkillPopularity implements SkillPopularity {
  const factory _SkillPopularity({
    required final String name,
    final int teachCount,
    final int learnCount,
  }) = _$SkillPopularityImpl;

  factory _SkillPopularity.fromJson(Map<String, dynamic> json) =
      _$SkillPopularityImpl.fromJson;

  @override
  String get name;
  @override
  int get teachCount;
  @override
  int get learnCount;

  /// Create a copy of SkillPopularity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillPopularityImplCopyWith<_$SkillPopularityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyActivity _$WeeklyActivityFromJson(Map<String, dynamic> json) {
  return _WeeklyActivity.fromJson(json);
}

/// @nodoc
mixin _$WeeklyActivity {
  String get week => throw _privateConstructorUsedError;
  int get sessions => throw _privateConstructorUsedError;
  int get connections => throw _privateConstructorUsedError;

  /// Serializes this WeeklyActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyActivityCopyWith<WeeklyActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyActivityCopyWith<$Res> {
  factory $WeeklyActivityCopyWith(
    WeeklyActivity value,
    $Res Function(WeeklyActivity) then,
  ) = _$WeeklyActivityCopyWithImpl<$Res, WeeklyActivity>;
  @useResult
  $Res call({String week, int sessions, int connections});
}

/// @nodoc
class _$WeeklyActivityCopyWithImpl<$Res, $Val extends WeeklyActivity>
    implements $WeeklyActivityCopyWith<$Res> {
  _$WeeklyActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? week = null,
    Object? sessions = null,
    Object? connections = null,
  }) {
    return _then(
      _value.copyWith(
            week: null == week
                ? _value.week
                : week // ignore: cast_nullable_to_non_nullable
                      as String,
            sessions: null == sessions
                ? _value.sessions
                : sessions // ignore: cast_nullable_to_non_nullable
                      as int,
            connections: null == connections
                ? _value.connections
                : connections // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeeklyActivityImplCopyWith<$Res>
    implements $WeeklyActivityCopyWith<$Res> {
  factory _$$WeeklyActivityImplCopyWith(
    _$WeeklyActivityImpl value,
    $Res Function(_$WeeklyActivityImpl) then,
  ) = __$$WeeklyActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String week, int sessions, int connections});
}

/// @nodoc
class __$$WeeklyActivityImplCopyWithImpl<$Res>
    extends _$WeeklyActivityCopyWithImpl<$Res, _$WeeklyActivityImpl>
    implements _$$WeeklyActivityImplCopyWith<$Res> {
  __$$WeeklyActivityImplCopyWithImpl(
    _$WeeklyActivityImpl _value,
    $Res Function(_$WeeklyActivityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklyActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? week = null,
    Object? sessions = null,
    Object? connections = null,
  }) {
    return _then(
      _$WeeklyActivityImpl(
        week: null == week
            ? _value.week
            : week // ignore: cast_nullable_to_non_nullable
                  as String,
        sessions: null == sessions
            ? _value.sessions
            : sessions // ignore: cast_nullable_to_non_nullable
                  as int,
        connections: null == connections
            ? _value.connections
            : connections // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyActivityImpl implements _WeeklyActivity {
  const _$WeeklyActivityImpl({
    required this.week,
    this.sessions = 0,
    this.connections = 0,
  });

  factory _$WeeklyActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyActivityImplFromJson(json);

  @override
  final String week;
  @override
  @JsonKey()
  final int sessions;
  @override
  @JsonKey()
  final int connections;

  @override
  String toString() {
    return 'WeeklyActivity(week: $week, sessions: $sessions, connections: $connections)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyActivityImpl &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.sessions, sessions) ||
                other.sessions == sessions) &&
            (identical(other.connections, connections) ||
                other.connections == connections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, week, sessions, connections);

  /// Create a copy of WeeklyActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyActivityImplCopyWith<_$WeeklyActivityImpl> get copyWith =>
      __$$WeeklyActivityImplCopyWithImpl<_$WeeklyActivityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyActivityImplToJson(this);
  }
}

abstract class _WeeklyActivity implements WeeklyActivity {
  const factory _WeeklyActivity({
    required final String week,
    final int sessions,
    final int connections,
  }) = _$WeeklyActivityImpl;

  factory _WeeklyActivity.fromJson(Map<String, dynamic> json) =
      _$WeeklyActivityImpl.fromJson;

  @override
  String get week;
  @override
  int get sessions;
  @override
  int get connections;

  /// Create a copy of WeeklyActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyActivityImplCopyWith<_$WeeklyActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
