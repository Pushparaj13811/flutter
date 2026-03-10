// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return _ReviewModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewModel {
  String get id => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  List<String> get skillsReviewed => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  UserProfileModel? get fromUser => throw _privateConstructorUsedError;
  UserProfileModel? get toUser => throw _privateConstructorUsedError;

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
    ReviewModel value,
    $Res Function(ReviewModel) then,
  ) = _$ReviewModelCopyWithImpl<$Res, ReviewModel>;
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String toUserId,
    int rating,
    String comment,
    List<String> skillsReviewed,
    String? sessionId,
    String createdAt,
    String updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  });

  $UserProfileModelCopyWith<$Res>? get fromUser;
  $UserProfileModelCopyWith<$Res>? get toUser;
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res, $Val extends ReviewModel>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? rating = null,
    Object? comment = null,
    Object? skillsReviewed = null,
    Object? sessionId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromUser = freezed,
    Object? toUser = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUserId: null == fromUserId
                ? _value.fromUserId
                : fromUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            toUserId: null == toUserId
                ? _value.toUserId
                : toUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            comment: null == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String,
            skillsReviewed: null == skillsReviewed
                ? _value.skillsReviewed
                : skillsReviewed // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            sessionId: freezed == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            fromUser: freezed == fromUser
                ? _value.fromUser
                : fromUser // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
            toUser: freezed == toUser
                ? _value.toUser
                : toUser // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get fromUser {
    if (_value.fromUser == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.fromUser!, (value) {
      return _then(_value.copyWith(fromUser: value) as $Val);
    });
  }

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get toUser {
    if (_value.toUser == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.toUser!, (value) {
      return _then(_value.copyWith(toUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReviewModelImplCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$$ReviewModelImplCopyWith(
    _$ReviewModelImpl value,
    $Res Function(_$ReviewModelImpl) then,
  ) = __$$ReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String toUserId,
    int rating,
    String comment,
    List<String> skillsReviewed,
    String? sessionId,
    String createdAt,
    String updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  });

  @override
  $UserProfileModelCopyWith<$Res>? get fromUser;
  @override
  $UserProfileModelCopyWith<$Res>? get toUser;
}

/// @nodoc
class __$$ReviewModelImplCopyWithImpl<$Res>
    extends _$ReviewModelCopyWithImpl<$Res, _$ReviewModelImpl>
    implements _$$ReviewModelImplCopyWith<$Res> {
  __$$ReviewModelImplCopyWithImpl(
    _$ReviewModelImpl _value,
    $Res Function(_$ReviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? rating = null,
    Object? comment = null,
    Object? skillsReviewed = null,
    Object? sessionId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromUser = freezed,
    Object? toUser = freezed,
  }) {
    return _then(
      _$ReviewModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUserId: null == fromUserId
            ? _value.fromUserId
            : fromUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        toUserId: null == toUserId
            ? _value.toUserId
            : toUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        comment: null == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String,
        skillsReviewed: null == skillsReviewed
            ? _value._skillsReviewed
            : skillsReviewed // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sessionId: freezed == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        fromUser: freezed == fromUser
            ? _value.fromUser
            : fromUser // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
        toUser: freezed == toUser
            ? _value.toUser
            : toUser // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewModelImpl implements _ReviewModel {
  const _$ReviewModelImpl({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    required this.comment,
    final List<String> skillsReviewed = const [],
    this.sessionId,
    required this.createdAt,
    required this.updatedAt,
    this.fromUser,
    this.toUser,
  }) : _skillsReviewed = skillsReviewed;

  factory _$ReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fromUserId;
  @override
  final String toUserId;
  @override
  final int rating;
  @override
  final String comment;
  final List<String> _skillsReviewed;
  @override
  @JsonKey()
  List<String> get skillsReviewed {
    if (_skillsReviewed is EqualUnmodifiableListView) return _skillsReviewed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsReviewed);
  }

  @override
  final String? sessionId;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final UserProfileModel? fromUser;
  @override
  final UserProfileModel? toUser;

  @override
  String toString() {
    return 'ReviewModel(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, rating: $rating, comment: $comment, skillsReviewed: $skillsReviewed, sessionId: $sessionId, createdAt: $createdAt, updatedAt: $updatedAt, fromUser: $fromUser, toUser: $toUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(
              other._skillsReviewed,
              _skillsReviewed,
            ) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.fromUser, fromUser) ||
                other.fromUser == fromUser) &&
            (identical(other.toUser, toUser) || other.toUser == toUser));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fromUserId,
    toUserId,
    rating,
    comment,
    const DeepCollectionEquality().hash(_skillsReviewed),
    sessionId,
    createdAt,
    updatedAt,
    fromUser,
    toUser,
  );

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      __$$ReviewModelImplCopyWithImpl<_$ReviewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewModelImplToJson(this);
  }
}

abstract class _ReviewModel implements ReviewModel {
  const factory _ReviewModel({
    required final String id,
    required final String fromUserId,
    required final String toUserId,
    required final int rating,
    required final String comment,
    final List<String> skillsReviewed,
    final String? sessionId,
    required final String createdAt,
    required final String updatedAt,
    final UserProfileModel? fromUser,
    final UserProfileModel? toUser,
  }) = _$ReviewModelImpl;

  factory _ReviewModel.fromJson(Map<String, dynamic> json) =
      _$ReviewModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  int get rating;
  @override
  String get comment;
  @override
  List<String> get skillsReviewed;
  @override
  String? get sessionId;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  UserProfileModel? get fromUser;
  @override
  UserProfileModel? get toUser;

  /// Create a copy of ReviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
