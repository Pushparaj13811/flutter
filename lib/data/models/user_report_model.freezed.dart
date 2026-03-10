// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserReportModel _$UserReportModelFromJson(Map<String, dynamic> json) {
  return _UserReportModel.fromJson(json);
}

/// @nodoc
mixin _$UserReportModel {
  String get id => throw _privateConstructorUsedError;
  String get reportedUserId => throw _privateConstructorUsedError;
  String? get reporterName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get reviewedAt => throw _privateConstructorUsedError;
  String? get reviewedBy => throw _privateConstructorUsedError;

  /// Serializes this UserReportModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserReportModelCopyWith<UserReportModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReportModelCopyWith<$Res> {
  factory $UserReportModelCopyWith(
    UserReportModel value,
    $Res Function(UserReportModel) then,
  ) = _$UserReportModelCopyWithImpl<$Res, UserReportModel>;
  @useResult
  $Res call({
    String id,
    String reportedUserId,
    String? reporterName,
    String reason,
    String description,
    String status,
    String createdAt,
    String? reviewedAt,
    String? reviewedBy,
  });
}

/// @nodoc
class _$UserReportModelCopyWithImpl<$Res, $Val extends UserReportModel>
    implements $UserReportModelCopyWith<$Res> {
  _$UserReportModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportedUserId = null,
    Object? reporterName = freezed,
    Object? reason = null,
    Object? description = null,
    Object? status = null,
    Object? createdAt = null,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reportedUserId: null == reportedUserId
                ? _value.reportedUserId
                : reportedUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            reporterName: freezed == reporterName
                ? _value.reporterName
                : reporterName // ignore: cast_nullable_to_non_nullable
                      as String?,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewedAt: freezed == reviewedAt
                ? _value.reviewedAt
                : reviewedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            reviewedBy: freezed == reviewedBy
                ? _value.reviewedBy
                : reviewedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserReportModelImplCopyWith<$Res>
    implements $UserReportModelCopyWith<$Res> {
  factory _$$UserReportModelImplCopyWith(
    _$UserReportModelImpl value,
    $Res Function(_$UserReportModelImpl) then,
  ) = __$$UserReportModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reportedUserId,
    String? reporterName,
    String reason,
    String description,
    String status,
    String createdAt,
    String? reviewedAt,
    String? reviewedBy,
  });
}

/// @nodoc
class __$$UserReportModelImplCopyWithImpl<$Res>
    extends _$UserReportModelCopyWithImpl<$Res, _$UserReportModelImpl>
    implements _$$UserReportModelImplCopyWith<$Res> {
  __$$UserReportModelImplCopyWithImpl(
    _$UserReportModelImpl _value,
    $Res Function(_$UserReportModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserReportModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportedUserId = null,
    Object? reporterName = freezed,
    Object? reason = null,
    Object? description = null,
    Object? status = null,
    Object? createdAt = null,
    Object? reviewedAt = freezed,
    Object? reviewedBy = freezed,
  }) {
    return _then(
      _$UserReportModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reportedUserId: null == reportedUserId
            ? _value.reportedUserId
            : reportedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        reporterName: freezed == reporterName
            ? _value.reporterName
            : reporterName // ignore: cast_nullable_to_non_nullable
                  as String?,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewedAt: freezed == reviewedAt
            ? _value.reviewedAt
            : reviewedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewedBy: freezed == reviewedBy
            ? _value.reviewedBy
            : reviewedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReportModelImpl implements _UserReportModel {
  const _$UserReportModelImpl({
    required this.id,
    required this.reportedUserId,
    this.reporterName,
    required this.reason,
    required this.description,
    this.status = 'pending',
    required this.createdAt,
    this.reviewedAt,
    this.reviewedBy,
  });

  factory _$UserReportModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReportModelImplFromJson(json);

  @override
  final String id;
  @override
  final String reportedUserId;
  @override
  final String? reporterName;
  @override
  final String reason;
  @override
  final String description;
  @override
  @JsonKey()
  final String status;
  @override
  final String createdAt;
  @override
  final String? reviewedAt;
  @override
  final String? reviewedBy;

  @override
  String toString() {
    return 'UserReportModel(id: $id, reportedUserId: $reportedUserId, reporterName: $reporterName, reason: $reason, description: $description, status: $status, createdAt: $createdAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReportModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reportedUserId, reportedUserId) ||
                other.reportedUserId == reportedUserId) &&
            (identical(other.reporterName, reporterName) ||
                other.reporterName == reporterName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reportedUserId,
    reporterName,
    reason,
    description,
    status,
    createdAt,
    reviewedAt,
    reviewedBy,
  );

  /// Create a copy of UserReportModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReportModelImplCopyWith<_$UserReportModelImpl> get copyWith =>
      __$$UserReportModelImplCopyWithImpl<_$UserReportModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReportModelImplToJson(this);
  }
}

abstract class _UserReportModel implements UserReportModel {
  const factory _UserReportModel({
    required final String id,
    required final String reportedUserId,
    final String? reporterName,
    required final String reason,
    required final String description,
    final String status,
    required final String createdAt,
    final String? reviewedAt,
    final String? reviewedBy,
  }) = _$UserReportModelImpl;

  factory _UserReportModel.fromJson(Map<String, dynamic> json) =
      _$UserReportModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reportedUserId;
  @override
  String? get reporterName;
  @override
  String get reason;
  @override
  String get description;
  @override
  String get status;
  @override
  String get createdAt;
  @override
  String? get reviewedAt;
  @override
  String? get reviewedBy;

  /// Create a copy of UserReportModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserReportModelImplCopyWith<_$UserReportModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
