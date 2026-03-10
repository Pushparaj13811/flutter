// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) {
  return _SessionModel.fromJson(json);
}

/// @nodoc
mixin _$SessionModel {
  String get id => throw _privateConstructorUsedError;
  String get hostId => throw _privateConstructorUsedError;
  String get participantId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get skillsToCover => throw _privateConstructorUsedError;
  String get scheduledAt => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  SessionStatus get status => throw _privateConstructorUsedError;
  String get sessionMode => throw _privateConstructorUsedError;
  String? get meetingPlatform => throw _privateConstructorUsedError;
  String? get meetingLink => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  UserProfileModel? get host => throw _privateConstructorUsedError;
  UserProfileModel? get participant => throw _privateConstructorUsedError;

  /// Serializes this SessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionModelCopyWith<SessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionModelCopyWith<$Res> {
  factory $SessionModelCopyWith(
    SessionModel value,
    $Res Function(SessionModel) then,
  ) = _$SessionModelCopyWithImpl<$Res, SessionModel>;
  @useResult
  $Res call({
    String id,
    String hostId,
    String participantId,
    String title,
    String description,
    List<String> skillsToCover,
    String scheduledAt,
    int duration,
    SessionStatus status,
    String sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
    String? notes,
    String createdAt,
    String updatedAt,
    UserProfileModel? host,
    UserProfileModel? participant,
  });

  $UserProfileModelCopyWith<$Res>? get host;
  $UserProfileModelCopyWith<$Res>? get participant;
}

/// @nodoc
class _$SessionModelCopyWithImpl<$Res, $Val extends SessionModel>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostId = null,
    Object? participantId = null,
    Object? title = null,
    Object? description = null,
    Object? skillsToCover = null,
    Object? scheduledAt = null,
    Object? duration = null,
    Object? status = null,
    Object? sessionMode = null,
    Object? meetingPlatform = freezed,
    Object? meetingLink = freezed,
    Object? location = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? host = freezed,
    Object? participant = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            hostId: null == hostId
                ? _value.hostId
                : hostId // ignore: cast_nullable_to_non_nullable
                      as String,
            participantId: null == participantId
                ? _value.participantId
                : participantId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SessionStatus,
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
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            host: freezed == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
            participant: freezed == participant
                ? _value.participant
                : participant // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get host {
    if (_value.host == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.host!, (value) {
      return _then(_value.copyWith(host: value) as $Val);
    });
  }

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get participant {
    if (_value.participant == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.participant!, (value) {
      return _then(_value.copyWith(participant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionModelImplCopyWith<$Res>
    implements $SessionModelCopyWith<$Res> {
  factory _$$SessionModelImplCopyWith(
    _$SessionModelImpl value,
    $Res Function(_$SessionModelImpl) then,
  ) = __$$SessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String hostId,
    String participantId,
    String title,
    String description,
    List<String> skillsToCover,
    String scheduledAt,
    int duration,
    SessionStatus status,
    String sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
    String? notes,
    String createdAt,
    String updatedAt,
    UserProfileModel? host,
    UserProfileModel? participant,
  });

  @override
  $UserProfileModelCopyWith<$Res>? get host;
  @override
  $UserProfileModelCopyWith<$Res>? get participant;
}

/// @nodoc
class __$$SessionModelImplCopyWithImpl<$Res>
    extends _$SessionModelCopyWithImpl<$Res, _$SessionModelImpl>
    implements _$$SessionModelImplCopyWith<$Res> {
  __$$SessionModelImplCopyWithImpl(
    _$SessionModelImpl _value,
    $Res Function(_$SessionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hostId = null,
    Object? participantId = null,
    Object? title = null,
    Object? description = null,
    Object? skillsToCover = null,
    Object? scheduledAt = null,
    Object? duration = null,
    Object? status = null,
    Object? sessionMode = null,
    Object? meetingPlatform = freezed,
    Object? meetingLink = freezed,
    Object? location = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? host = freezed,
    Object? participant = freezed,
  }) {
    return _then(
      _$SessionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        hostId: null == hostId
            ? _value.hostId
            : hostId // ignore: cast_nullable_to_non_nullable
                  as String,
        participantId: null == participantId
            ? _value.participantId
            : participantId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SessionStatus,
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
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        host: freezed == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
        participant: freezed == participant
            ? _value.participant
            : participant // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionModelImpl implements _SessionModel {
  const _$SessionModelImpl({
    required this.id,
    required this.hostId,
    required this.participantId,
    required this.title,
    this.description = '',
    final List<String> skillsToCover = const [],
    required this.scheduledAt,
    required this.duration,
    required this.status,
    this.sessionMode = 'online',
    this.meetingPlatform,
    this.meetingLink,
    this.location,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.host,
    this.participant,
  }) : _skillsToCover = skillsToCover;

  factory _$SessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String hostId;
  @override
  final String participantId;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
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
  final SessionStatus status;
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
  final String? notes;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final UserProfileModel? host;
  @override
  final UserProfileModel? participant;

  @override
  String toString() {
    return 'SessionModel(id: $id, hostId: $hostId, participantId: $participantId, title: $title, description: $description, skillsToCover: $skillsToCover, scheduledAt: $scheduledAt, duration: $duration, status: $status, sessionMode: $sessionMode, meetingPlatform: $meetingPlatform, meetingLink: $meetingLink, location: $location, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, host: $host, participant: $participant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sessionMode, sessionMode) ||
                other.sessionMode == sessionMode) &&
            (identical(other.meetingPlatform, meetingPlatform) ||
                other.meetingPlatform == meetingPlatform) &&
            (identical(other.meetingLink, meetingLink) ||
                other.meetingLink == meetingLink) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.participant, participant) ||
                other.participant == participant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    hostId,
    participantId,
    title,
    description,
    const DeepCollectionEquality().hash(_skillsToCover),
    scheduledAt,
    duration,
    status,
    sessionMode,
    meetingPlatform,
    meetingLink,
    location,
    notes,
    createdAt,
    updatedAt,
    host,
    participant,
  );

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      __$$SessionModelImplCopyWithImpl<_$SessionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionModelImplToJson(this);
  }
}

abstract class _SessionModel implements SessionModel {
  const factory _SessionModel({
    required final String id,
    required final String hostId,
    required final String participantId,
    required final String title,
    final String description,
    final List<String> skillsToCover,
    required final String scheduledAt,
    required final int duration,
    required final SessionStatus status,
    final String sessionMode,
    final String? meetingPlatform,
    final String? meetingLink,
    final String? location,
    final String? notes,
    required final String createdAt,
    required final String updatedAt,
    final UserProfileModel? host,
    final UserProfileModel? participant,
  }) = _$SessionModelImpl;

  factory _SessionModel.fromJson(Map<String, dynamic> json) =
      _$SessionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get hostId;
  @override
  String get participantId;
  @override
  String get title;
  @override
  String get description;
  @override
  List<String> get skillsToCover;
  @override
  String get scheduledAt;
  @override
  int get duration;
  @override
  SessionStatus get status;
  @override
  String get sessionMode;
  @override
  String? get meetingPlatform;
  @override
  String? get meetingLink;
  @override
  String? get location;
  @override
  String? get notes;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  UserProfileModel? get host;
  @override
  UserProfileModel? get participant;

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
