// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeaderboardEntryModel _$LeaderboardEntryModelFromJson(
  Map<String, dynamic> json,
) {
  return _LeaderboardEntryModel.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntryModel {
  String get userId => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  int get sessionsCompleted => throw _privateConstructorUsedError;
  int get reviewsGiven => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  UserProfileModel? get user => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntryModelCopyWith<LeaderboardEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntryModelCopyWith<$Res> {
  factory $LeaderboardEntryModelCopyWith(
    LeaderboardEntryModel value,
    $Res Function(LeaderboardEntryModel) then,
  ) = _$LeaderboardEntryModelCopyWithImpl<$Res, LeaderboardEntryModel>;
  @useResult
  $Res call({
    String userId,
    int rank,
    int points,
    int sessionsCompleted,
    int reviewsGiven,
    double averageRating,
    UserProfileModel? user,
  });

  $UserProfileModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$LeaderboardEntryModelCopyWithImpl<
  $Res,
  $Val extends LeaderboardEntryModel
>
    implements $LeaderboardEntryModelCopyWith<$Res> {
  _$LeaderboardEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? rank = null,
    Object? points = null,
    Object? sessionsCompleted = null,
    Object? reviewsGiven = null,
    Object? averageRating = null,
    Object? user = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionsCompleted: null == sessionsCompleted
                ? _value.sessionsCompleted
                : sessionsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            reviewsGiven: null == reviewsGiven
                ? _value.reviewsGiven
                : reviewsGiven // ignore: cast_nullable_to_non_nullable
                      as int,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LeaderboardEntryModelImplCopyWith<$Res>
    implements $LeaderboardEntryModelCopyWith<$Res> {
  factory _$$LeaderboardEntryModelImplCopyWith(
    _$LeaderboardEntryModelImpl value,
    $Res Function(_$LeaderboardEntryModelImpl) then,
  ) = __$$LeaderboardEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int rank,
    int points,
    int sessionsCompleted,
    int reviewsGiven,
    double averageRating,
    UserProfileModel? user,
  });

  @override
  $UserProfileModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$LeaderboardEntryModelImplCopyWithImpl<$Res>
    extends
        _$LeaderboardEntryModelCopyWithImpl<$Res, _$LeaderboardEntryModelImpl>
    implements _$$LeaderboardEntryModelImplCopyWith<$Res> {
  __$$LeaderboardEntryModelImplCopyWithImpl(
    _$LeaderboardEntryModelImpl _value,
    $Res Function(_$LeaderboardEntryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? rank = null,
    Object? points = null,
    Object? sessionsCompleted = null,
    Object? reviewsGiven = null,
    Object? averageRating = null,
    Object? user = freezed,
  }) {
    return _then(
      _$LeaderboardEntryModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionsCompleted: null == sessionsCompleted
            ? _value.sessionsCompleted
            : sessionsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        reviewsGiven: null == reviewsGiven
            ? _value.reviewsGiven
            : reviewsGiven // ignore: cast_nullable_to_non_nullable
                  as int,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardEntryModelImpl implements _LeaderboardEntryModel {
  const _$LeaderboardEntryModelImpl({
    required this.userId,
    required this.rank,
    this.points = 0,
    this.sessionsCompleted = 0,
    this.reviewsGiven = 0,
    this.averageRating = 0.0,
    this.user,
  });

  factory _$LeaderboardEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntryModelImplFromJson(json);

  @override
  final String userId;
  @override
  final int rank;
  @override
  @JsonKey()
  final int points;
  @override
  @JsonKey()
  final int sessionsCompleted;
  @override
  @JsonKey()
  final int reviewsGiven;
  @override
  @JsonKey()
  final double averageRating;
  @override
  final UserProfileModel? user;

  @override
  String toString() {
    return 'LeaderboardEntryModel(userId: $userId, rank: $rank, points: $points, sessionsCompleted: $sessionsCompleted, reviewsGiven: $reviewsGiven, averageRating: $averageRating, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardEntryModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.sessionsCompleted, sessionsCompleted) ||
                other.sessionsCompleted == sessionsCompleted) &&
            (identical(other.reviewsGiven, reviewsGiven) ||
                other.reviewsGiven == reviewsGiven) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    rank,
    points,
    sessionsCompleted,
    reviewsGiven,
    averageRating,
    user,
  );

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntryModelImplCopyWith<_$LeaderboardEntryModelImpl>
  get copyWith =>
      __$$LeaderboardEntryModelImplCopyWithImpl<_$LeaderboardEntryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntryModelImplToJson(this);
  }
}

abstract class _LeaderboardEntryModel implements LeaderboardEntryModel {
  const factory _LeaderboardEntryModel({
    required final String userId,
    required final int rank,
    final int points,
    final int sessionsCompleted,
    final int reviewsGiven,
    final double averageRating,
    final UserProfileModel? user,
  }) = _$LeaderboardEntryModelImpl;

  factory _LeaderboardEntryModel.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntryModelImpl.fromJson;

  @override
  String get userId;
  @override
  int get rank;
  @override
  int get points;
  @override
  int get sessionsCompleted;
  @override
  int get reviewsGiven;
  @override
  double get averageRating;
  @override
  UserProfileModel? get user;

  /// Create a copy of LeaderboardEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntryModelImplCopyWith<_$LeaderboardEntryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
