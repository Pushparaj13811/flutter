// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConnectionModel _$ConnectionModelFromJson(Map<String, dynamic> json) {
  return _ConnectionModel.fromJson(json);
}

/// @nodoc
mixin _$ConnectionModel {
  String get id => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  ConnectionStatus get status => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  UserProfileModel? get fromUser => throw _privateConstructorUsedError;
  UserProfileModel? get toUser => throw _privateConstructorUsedError;

  /// Serializes this ConnectionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionModelCopyWith<ConnectionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionModelCopyWith<$Res> {
  factory $ConnectionModelCopyWith(
    ConnectionModel value,
    $Res Function(ConnectionModel) then,
  ) = _$ConnectionModelCopyWithImpl<$Res, ConnectionModel>;
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String toUserId,
    ConnectionStatus status,
    String? message,
    String createdAt,
    String updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  });

  $UserProfileModelCopyWith<$Res>? get fromUser;
  $UserProfileModelCopyWith<$Res>? get toUser;
}

/// @nodoc
class _$ConnectionModelCopyWithImpl<$Res, $Val extends ConnectionModel>
    implements $ConnectionModelCopyWith<$Res> {
  _$ConnectionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? status = null,
    Object? message = freezed,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ConnectionStatus,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of ConnectionModel
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

  /// Create a copy of ConnectionModel
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
abstract class _$$ConnectionModelImplCopyWith<$Res>
    implements $ConnectionModelCopyWith<$Res> {
  factory _$$ConnectionModelImplCopyWith(
    _$ConnectionModelImpl value,
    $Res Function(_$ConnectionModelImpl) then,
  ) = __$$ConnectionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fromUserId,
    String toUserId,
    ConnectionStatus status,
    String? message,
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
class __$$ConnectionModelImplCopyWithImpl<$Res>
    extends _$ConnectionModelCopyWithImpl<$Res, _$ConnectionModelImpl>
    implements _$$ConnectionModelImplCopyWith<$Res> {
  __$$ConnectionModelImplCopyWithImpl(
    _$ConnectionModelImpl _value,
    $Res Function(_$ConnectionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? status = null,
    Object? message = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? fromUser = freezed,
    Object? toUser = freezed,
  }) {
    return _then(
      _$ConnectionModelImpl(
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
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
class _$ConnectionModelImpl implements _ConnectionModel {
  const _$ConnectionModelImpl({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    this.message,
    required this.createdAt,
    required this.updatedAt,
    this.fromUser,
    this.toUser,
  });

  factory _$ConnectionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConnectionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String fromUserId;
  @override
  final String toUserId;
  @override
  final ConnectionStatus status;
  @override
  final String? message;
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
    return 'ConnectionModel(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, status: $status, message: $message, createdAt: $createdAt, updatedAt: $updatedAt, fromUser: $fromUser, toUser: $toUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.message, message) || other.message == message) &&
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
    status,
    message,
    createdAt,
    updatedAt,
    fromUser,
    toUser,
  );

  /// Create a copy of ConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionModelImplCopyWith<_$ConnectionModelImpl> get copyWith =>
      __$$ConnectionModelImplCopyWithImpl<_$ConnectionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionModelImplToJson(this);
  }
}

abstract class _ConnectionModel implements ConnectionModel {
  const factory _ConnectionModel({
    required final String id,
    required final String fromUserId,
    required final String toUserId,
    required final ConnectionStatus status,
    final String? message,
    required final String createdAt,
    required final String updatedAt,
    final UserProfileModel? fromUser,
    final UserProfileModel? toUser,
  }) = _$ConnectionModelImpl;

  factory _ConnectionModel.fromJson(Map<String, dynamic> json) =
      _$ConnectionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  ConnectionStatus get status;
  @override
  String? get message;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  UserProfileModel? get fromUser;
  @override
  UserProfileModel? get toUser;

  /// Create a copy of ConnectionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionModelImplCopyWith<_$ConnectionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
