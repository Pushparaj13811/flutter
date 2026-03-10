// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reschedule_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RescheduleSessionDto _$RescheduleSessionDtoFromJson(Map<String, dynamic> json) {
  return _RescheduleSessionDto.fromJson(json);
}

/// @nodoc
mixin _$RescheduleSessionDto {
  String get newScheduledAt => throw _privateConstructorUsedError;
  int get newDuration => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this RescheduleSessionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RescheduleSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RescheduleSessionDtoCopyWith<RescheduleSessionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RescheduleSessionDtoCopyWith<$Res> {
  factory $RescheduleSessionDtoCopyWith(
    RescheduleSessionDto value,
    $Res Function(RescheduleSessionDto) then,
  ) = _$RescheduleSessionDtoCopyWithImpl<$Res, RescheduleSessionDto>;
  @useResult
  $Res call({String newScheduledAt, int newDuration, String? reason});
}

/// @nodoc
class _$RescheduleSessionDtoCopyWithImpl<
  $Res,
  $Val extends RescheduleSessionDto
>
    implements $RescheduleSessionDtoCopyWith<$Res> {
  _$RescheduleSessionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RescheduleSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newScheduledAt = null,
    Object? newDuration = null,
    Object? reason = freezed,
  }) {
    return _then(
      _value.copyWith(
            newScheduledAt: null == newScheduledAt
                ? _value.newScheduledAt
                : newScheduledAt // ignore: cast_nullable_to_non_nullable
                      as String,
            newDuration: null == newDuration
                ? _value.newDuration
                : newDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RescheduleSessionDtoImplCopyWith<$Res>
    implements $RescheduleSessionDtoCopyWith<$Res> {
  factory _$$RescheduleSessionDtoImplCopyWith(
    _$RescheduleSessionDtoImpl value,
    $Res Function(_$RescheduleSessionDtoImpl) then,
  ) = __$$RescheduleSessionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newScheduledAt, int newDuration, String? reason});
}

/// @nodoc
class __$$RescheduleSessionDtoImplCopyWithImpl<$Res>
    extends _$RescheduleSessionDtoCopyWithImpl<$Res, _$RescheduleSessionDtoImpl>
    implements _$$RescheduleSessionDtoImplCopyWith<$Res> {
  __$$RescheduleSessionDtoImplCopyWithImpl(
    _$RescheduleSessionDtoImpl _value,
    $Res Function(_$RescheduleSessionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RescheduleSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newScheduledAt = null,
    Object? newDuration = null,
    Object? reason = freezed,
  }) {
    return _then(
      _$RescheduleSessionDtoImpl(
        newScheduledAt: null == newScheduledAt
            ? _value.newScheduledAt
            : newScheduledAt // ignore: cast_nullable_to_non_nullable
                  as String,
        newDuration: null == newDuration
            ? _value.newDuration
            : newDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RescheduleSessionDtoImpl implements _RescheduleSessionDto {
  const _$RescheduleSessionDtoImpl({
    required this.newScheduledAt,
    required this.newDuration,
    this.reason,
  });

  factory _$RescheduleSessionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RescheduleSessionDtoImplFromJson(json);

  @override
  final String newScheduledAt;
  @override
  final int newDuration;
  @override
  final String? reason;

  @override
  String toString() {
    return 'RescheduleSessionDto(newScheduledAt: $newScheduledAt, newDuration: $newDuration, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RescheduleSessionDtoImpl &&
            (identical(other.newScheduledAt, newScheduledAt) ||
                other.newScheduledAt == newScheduledAt) &&
            (identical(other.newDuration, newDuration) ||
                other.newDuration == newDuration) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, newScheduledAt, newDuration, reason);

  /// Create a copy of RescheduleSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RescheduleSessionDtoImplCopyWith<_$RescheduleSessionDtoImpl>
  get copyWith =>
      __$$RescheduleSessionDtoImplCopyWithImpl<_$RescheduleSessionDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RescheduleSessionDtoImplToJson(this);
  }
}

abstract class _RescheduleSessionDto implements RescheduleSessionDto {
  const factory _RescheduleSessionDto({
    required final String newScheduledAt,
    required final int newDuration,
    final String? reason,
  }) = _$RescheduleSessionDtoImpl;

  factory _RescheduleSessionDto.fromJson(Map<String, dynamic> json) =
      _$RescheduleSessionDtoImpl.fromJson;

  @override
  String get newScheduledAt;
  @override
  int get newDuration;
  @override
  String? get reason;

  /// Create a copy of RescheduleSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RescheduleSessionDtoImplCopyWith<_$RescheduleSessionDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
