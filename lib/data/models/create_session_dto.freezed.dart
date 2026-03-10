// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateSessionDto _$CreateSessionDtoFromJson(Map<String, dynamic> json) {
  return _CreateSessionDto.fromJson(json);
}

/// @nodoc
mixin _$CreateSessionDto {
  String get participantId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get skillsToCover => throw _privateConstructorUsedError;
  String get scheduledAt => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String get sessionMode => throw _privateConstructorUsedError;
  String? get meetingPlatform => throw _privateConstructorUsedError;
  String? get meetingLink => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  /// Serializes this CreateSessionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateSessionDtoCopyWith<CreateSessionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateSessionDtoCopyWith<$Res> {
  factory $CreateSessionDtoCopyWith(
    CreateSessionDto value,
    $Res Function(CreateSessionDto) then,
  ) = _$CreateSessionDtoCopyWithImpl<$Res, CreateSessionDto>;
  @useResult
  $Res call({
    String participantId,
    String title,
    String? description,
    List<String> skillsToCover,
    String scheduledAt,
    int duration,
    String sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
  });
}

/// @nodoc
class _$CreateSessionDtoCopyWithImpl<$Res, $Val extends CreateSessionDto>
    implements $CreateSessionDtoCopyWith<$Res> {
  _$CreateSessionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? participantId = null,
    Object? title = null,
    Object? description = freezed,
    Object? skillsToCover = null,
    Object? scheduledAt = null,
    Object? duration = null,
    Object? sessionMode = null,
    Object? meetingPlatform = freezed,
    Object? meetingLink = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _value.copyWith(
            participantId: null == participantId
                ? _value.participantId
                : participantId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            skillsToCover: null == skillsToCover
                ? _value.skillsToCover
                : skillsToCover // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            scheduledAt: null == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionMode: null == sessionMode
                ? _value.sessionMode
                : sessionMode // ignore: cast_nullable_to_non_nullable
                      as String,
            meetingPlatform: freezed == meetingPlatform
                ? _value.meetingPlatform
                : meetingPlatform // ignore: cast_nullable_to_non_nullable
                      as String?,
            meetingLink: freezed == meetingLink
                ? _value.meetingLink
                : meetingLink // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateSessionDtoImplCopyWith<$Res>
    implements $CreateSessionDtoCopyWith<$Res> {
  factory _$$CreateSessionDtoImplCopyWith(
    _$CreateSessionDtoImpl value,
    $Res Function(_$CreateSessionDtoImpl) then,
  ) = __$$CreateSessionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String participantId,
    String title,
    String? description,
    List<String> skillsToCover,
    String scheduledAt,
    int duration,
    String sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
  });
}

/// @nodoc
class __$$CreateSessionDtoImplCopyWithImpl<$Res>
    extends _$CreateSessionDtoCopyWithImpl<$Res, _$CreateSessionDtoImpl>
    implements _$$CreateSessionDtoImplCopyWith<$Res> {
  __$$CreateSessionDtoImplCopyWithImpl(
    _$CreateSessionDtoImpl _value,
    $Res Function(_$CreateSessionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? participantId = null,
    Object? title = null,
    Object? description = freezed,
    Object? skillsToCover = null,
    Object? scheduledAt = null,
    Object? duration = null,
    Object? sessionMode = null,
    Object? meetingPlatform = freezed,
    Object? meetingLink = freezed,
    Object? location = freezed,
  }) {
    return _then(
      _$CreateSessionDtoImpl(
        participantId: null == participantId
            ? _value.participantId
            : participantId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        skillsToCover: null == skillsToCover
            ? _value._skillsToCover
            : skillsToCover // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        scheduledAt: null == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionMode: null == sessionMode
            ? _value.sessionMode
            : sessionMode // ignore: cast_nullable_to_non_nullable
                  as String,
        meetingPlatform: freezed == meetingPlatform
            ? _value.meetingPlatform
            : meetingPlatform // ignore: cast_nullable_to_non_nullable
                  as String?,
        meetingLink: freezed == meetingLink
            ? _value.meetingLink
            : meetingLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateSessionDtoImpl implements _CreateSessionDto {
  const _$CreateSessionDtoImpl({
    required this.participantId,
    required this.title,
    this.description,
    final List<String> skillsToCover = const [],
    required this.scheduledAt,
    required this.duration,
    this.sessionMode = 'online',
    this.meetingPlatform,
    this.meetingLink,
    this.location,
  }) : _skillsToCover = skillsToCover;

  factory _$CreateSessionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateSessionDtoImplFromJson(json);

  @override
  final String participantId;
  @override
  final String title;
  @override
  final String? description;
  final List<String> _skillsToCover;
  @override
  @JsonKey()
  List<String> get skillsToCover {
    if (_skillsToCover is EqualUnmodifiableListView) return _skillsToCover;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsToCover);
  }

  @override
  final String scheduledAt;
  @override
  final int duration;
  @override
  @JsonKey()
  final String sessionMode;
  @override
  final String? meetingPlatform;
  @override
  final String? meetingLink;
  @override
  final String? location;

  @override
  String toString() {
    return 'CreateSessionDto(participantId: $participantId, title: $title, description: $description, skillsToCover: $skillsToCover, scheduledAt: $scheduledAt, duration: $duration, sessionMode: $sessionMode, meetingPlatform: $meetingPlatform, meetingLink: $meetingLink, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateSessionDtoImpl &&
            (identical(other.participantId, participantId) ||
                other.participantId == participantId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._skillsToCover,
              _skillsToCover,
            ) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.sessionMode, sessionMode) ||
                other.sessionMode == sessionMode) &&
            (identical(other.meetingPlatform, meetingPlatform) ||
                other.meetingPlatform == meetingPlatform) &&
            (identical(other.meetingLink, meetingLink) ||
                other.meetingLink == meetingLink) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    participantId,
    title,
    description,
    const DeepCollectionEquality().hash(_skillsToCover),
    scheduledAt,
    duration,
    sessionMode,
    meetingPlatform,
    meetingLink,
    location,
  );

  /// Create a copy of CreateSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateSessionDtoImplCopyWith<_$CreateSessionDtoImpl> get copyWith =>
      __$$CreateSessionDtoImplCopyWithImpl<_$CreateSessionDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateSessionDtoImplToJson(this);
  }
}

abstract class _CreateSessionDto implements CreateSessionDto {
  const factory _CreateSessionDto({
    required final String participantId,
    required final String title,
    final String? description,
    final List<String> skillsToCover,
    required final String scheduledAt,
    required final int duration,
    final String sessionMode,
    final String? meetingPlatform,
    final String? meetingLink,
    final String? location,
  }) = _$CreateSessionDtoImpl;

  factory _CreateSessionDto.fromJson(Map<String, dynamic> json) =
      _$CreateSessionDtoImpl.fromJson;

  @override
  String get participantId;
  @override
  String get title;
  @override
  String? get description;
  @override
  List<String> get skillsToCover;
  @override
  String get scheduledAt;
  @override
  int get duration;
  @override
  String get sessionMode;
  @override
  String? get meetingPlatform;
  @override
  String? get meetingLink;
  @override
  String? get location;

  /// Create a copy of CreateSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateSessionDtoImplCopyWith<_$CreateSessionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
