// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActivityLogModel _$ActivityLogModelFromJson(Map<String, dynamic> json) {
  return _ActivityLogModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityLogModel {
  String get id => throw _privateConstructorUsedError;
  String get adminName => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get targetType => throw _privateConstructorUsedError;
  String get targetId => throw _privateConstructorUsedError;
  String get details => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ActivityLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityLogModelCopyWith<ActivityLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityLogModelCopyWith<$Res> {
  factory $ActivityLogModelCopyWith(
    ActivityLogModel value,
    $Res Function(ActivityLogModel) then,
  ) = _$ActivityLogModelCopyWithImpl<$Res, ActivityLogModel>;
  @useResult
  $Res call({
    String id,
    String adminName,
    String action,
    String targetType,
    String targetId,
    String details,
    String timestamp,
  });
}

/// @nodoc
class _$ActivityLogModelCopyWithImpl<$Res, $Val extends ActivityLogModel>
    implements $ActivityLogModelCopyWith<$Res> {
  _$ActivityLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? adminName = null,
    Object? action = null,
    Object? targetType = null,
    Object? targetId = null,
    Object? details = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            adminName: null == adminName
                ? _value.adminName
                : adminName // ignore: cast_nullable_to_non_nullable
                      as String,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            targetType: null == targetType
                ? _value.targetType
                : targetType // ignore: cast_nullable_to_non_nullable
                      as String,
            targetId: null == targetId
                ? _value.targetId
                : targetId // ignore: cast_nullable_to_non_nullable
                      as String,
            details: null == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityLogModelImplCopyWith<$Res>
    implements $ActivityLogModelCopyWith<$Res> {
  factory _$$ActivityLogModelImplCopyWith(
    _$ActivityLogModelImpl value,
    $Res Function(_$ActivityLogModelImpl) then,
  ) = __$$ActivityLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String adminName,
    String action,
    String targetType,
    String targetId,
    String details,
    String timestamp,
  });
}

/// @nodoc
class __$$ActivityLogModelImplCopyWithImpl<$Res>
    extends _$ActivityLogModelCopyWithImpl<$Res, _$ActivityLogModelImpl>
    implements _$$ActivityLogModelImplCopyWith<$Res> {
  __$$ActivityLogModelImplCopyWithImpl(
    _$ActivityLogModelImpl _value,
    $Res Function(_$ActivityLogModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? adminName = null,
    Object? action = null,
    Object? targetType = null,
    Object? targetId = null,
    Object? details = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$ActivityLogModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        adminName: null == adminName
            ? _value.adminName
            : adminName // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        targetType: null == targetType
            ? _value.targetType
            : targetType // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: null == targetId
            ? _value.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String,
        details: null == details
            ? _value.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityLogModelImpl implements _ActivityLogModel {
  const _$ActivityLogModelImpl({
    required this.id,
    required this.adminName,
    required this.action,
    required this.targetType,
    this.targetId = '',
    this.details = '',
    required this.timestamp,
  });

  factory _$ActivityLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityLogModelImplFromJson(json);

  @override
  final String id;
  @override
  final String adminName;
  @override
  final String action;
  @override
  final String targetType;
  @override
  @JsonKey()
  final String targetId;
  @override
  @JsonKey()
  final String details;
  @override
  final String timestamp;

  @override
  String toString() {
    return 'ActivityLogModel(id: $id, adminName: $adminName, action: $action, targetType: $targetType, targetId: $targetId, details: $details, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.adminName, adminName) ||
                other.adminName == adminName) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.targetType, targetType) ||
                other.targetType == targetType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    adminName,
    action,
    targetType,
    targetId,
    details,
    timestamp,
  );

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityLogModelImplCopyWith<_$ActivityLogModelImpl> get copyWith =>
      __$$ActivityLogModelImplCopyWithImpl<_$ActivityLogModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityLogModelImplToJson(this);
  }
}

abstract class _ActivityLogModel implements ActivityLogModel {
  const factory _ActivityLogModel({
    required final String id,
    required final String adminName,
    required final String action,
    required final String targetType,
    final String targetId,
    final String details,
    required final String timestamp,
  }) = _$ActivityLogModelImpl;

  factory _ActivityLogModel.fromJson(Map<String, dynamic> json) =
      _$ActivityLogModelImpl.fromJson;

  @override
  String get id;
  @override
  String get adminName;
  @override
  String get action;
  @override
  String get targetType;
  @override
  String get targetId;
  @override
  String get details;
  @override
  String get timestamp;

  /// Create a copy of ActivityLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityLogModelImplCopyWith<_$ActivityLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
