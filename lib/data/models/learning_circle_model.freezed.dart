// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_circle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LearningCircleModel _$LearningCircleModelFromJson(Map<String, dynamic> json) {
  return _LearningCircleModel.fromJson(json);
}

/// @nodoc
mixin _$LearningCircleModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  List<String> get skillFocus => throw _privateConstructorUsedError;
  int get membersCount => throw _privateConstructorUsedError;
  int get maxMembers => throw _privateConstructorUsedError;
  bool get isJoinedByMe => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  UserProfileModel? get creator => throw _privateConstructorUsedError;

  /// Serializes this LearningCircleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningCircleModelCopyWith<LearningCircleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningCircleModelCopyWith<$Res> {
  factory $LearningCircleModelCopyWith(
    LearningCircleModel value,
    $Res Function(LearningCircleModel) then,
  ) = _$LearningCircleModelCopyWithImpl<$Res, LearningCircleModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String creatorId,
    List<String> skillFocus,
    int membersCount,
    int maxMembers,
    bool isJoinedByMe,
    String createdAt,
    String updatedAt,
    UserProfileModel? creator,
  });

  $UserProfileModelCopyWith<$Res>? get creator;
}

/// @nodoc
class _$LearningCircleModelCopyWithImpl<$Res, $Val extends LearningCircleModel>
    implements $LearningCircleModelCopyWith<$Res> {
  _$LearningCircleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? creatorId = null,
    Object? skillFocus = null,
    Object? membersCount = null,
    Object? maxMembers = null,
    Object? isJoinedByMe = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? creator = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            creatorId: null == creatorId
                ? _value.creatorId
                : creatorId // ignore: cast_nullable_to_non_nullable
                      as String,
            skillFocus: null == skillFocus
                ? _value.skillFocus
                : skillFocus // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            membersCount: null == membersCount
                ? _value.membersCount
                : membersCount // ignore: cast_nullable_to_non_nullable
                      as int,
            maxMembers: null == maxMembers
                ? _value.maxMembers
                : maxMembers // ignore: cast_nullable_to_non_nullable
                      as int,
            isJoinedByMe: null == isJoinedByMe
                ? _value.isJoinedByMe
                : isJoinedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            creator: freezed == creator
                ? _value.creator
                : creator // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of LearningCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get creator {
    if (_value.creator == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.creator!, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LearningCircleModelImplCopyWith<$Res>
    implements $LearningCircleModelCopyWith<$Res> {
  factory _$$LearningCircleModelImplCopyWith(
    _$LearningCircleModelImpl value,
    $Res Function(_$LearningCircleModelImpl) then,
  ) = __$$LearningCircleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String creatorId,
    List<String> skillFocus,
    int membersCount,
    int maxMembers,
    bool isJoinedByMe,
    String createdAt,
    String updatedAt,
    UserProfileModel? creator,
  });

  @override
  $UserProfileModelCopyWith<$Res>? get creator;
}

/// @nodoc
class __$$LearningCircleModelImplCopyWithImpl<$Res>
    extends _$LearningCircleModelCopyWithImpl<$Res, _$LearningCircleModelImpl>
    implements _$$LearningCircleModelImplCopyWith<$Res> {
  __$$LearningCircleModelImplCopyWithImpl(
    _$LearningCircleModelImpl _value,
    $Res Function(_$LearningCircleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LearningCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? creatorId = null,
    Object? skillFocus = null,
    Object? membersCount = null,
    Object? maxMembers = null,
    Object? isJoinedByMe = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? creator = freezed,
  }) {
    return _then(
      _$LearningCircleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        creatorId: null == creatorId
            ? _value.creatorId
            : creatorId // ignore: cast_nullable_to_non_nullable
                  as String,
        skillFocus: null == skillFocus
            ? _value._skillFocus
            : skillFocus // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        membersCount: null == membersCount
            ? _value.membersCount
            : membersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        maxMembers: null == maxMembers
            ? _value.maxMembers
            : maxMembers // ignore: cast_nullable_to_non_nullable
                  as int,
        isJoinedByMe: null == isJoinedByMe
            ? _value.isJoinedByMe
            : isJoinedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        creator: freezed == creator
            ? _value.creator
            : creator // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningCircleModelImpl implements _LearningCircleModel {
  const _$LearningCircleModelImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    final List<String> skillFocus = const [],
    this.membersCount = 0,
    this.maxMembers = 20,
    this.isJoinedByMe = false,
    required this.createdAt,
    required this.updatedAt,
    this.creator,
  }) : _skillFocus = skillFocus;

  factory _$LearningCircleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningCircleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String creatorId;
  final List<String> _skillFocus;
  @override
  @JsonKey()
  List<String> get skillFocus {
    if (_skillFocus is EqualUnmodifiableListView) return _skillFocus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillFocus);
  }

  @override
  @JsonKey()
  final int membersCount;
  @override
  @JsonKey()
  final int maxMembers;
  @override
  @JsonKey()
  final bool isJoinedByMe;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final UserProfileModel? creator;

  @override
  String toString() {
    return 'LearningCircleModel(id: $id, name: $name, description: $description, creatorId: $creatorId, skillFocus: $skillFocus, membersCount: $membersCount, maxMembers: $maxMembers, isJoinedByMe: $isJoinedByMe, createdAt: $createdAt, updatedAt: $updatedAt, creator: $creator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningCircleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            const DeepCollectionEquality().equals(
              other._skillFocus,
              _skillFocus,
            ) &&
            (identical(other.membersCount, membersCount) ||
                other.membersCount == membersCount) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers) &&
            (identical(other.isJoinedByMe, isJoinedByMe) ||
                other.isJoinedByMe == isJoinedByMe) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.creator, creator) || other.creator == creator));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    creatorId,
    const DeepCollectionEquality().hash(_skillFocus),
    membersCount,
    maxMembers,
    isJoinedByMe,
    createdAt,
    updatedAt,
    creator,
  );

  /// Create a copy of LearningCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningCircleModelImplCopyWith<_$LearningCircleModelImpl> get copyWith =>
      __$$LearningCircleModelImplCopyWithImpl<_$LearningCircleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningCircleModelImplToJson(this);
  }
}

abstract class _LearningCircleModel implements LearningCircleModel {
  const factory _LearningCircleModel({
    required final String id,
    required final String name,
    required final String description,
    required final String creatorId,
    final List<String> skillFocus,
    final int membersCount,
    final int maxMembers,
    final bool isJoinedByMe,
    required final String createdAt,
    required final String updatedAt,
    final UserProfileModel? creator,
  }) = _$LearningCircleModelImpl;

  factory _LearningCircleModel.fromJson(Map<String, dynamic> json) =
      _$LearningCircleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get creatorId;
  @override
  List<String> get skillFocus;
  @override
  int get membersCount;
  @override
  int get maxMembers;
  @override
  bool get isJoinedByMe;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  UserProfileModel? get creator;

  /// Create a copy of LearningCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningCircleModelImplCopyWith<_$LearningCircleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCircleDto _$CreateCircleDtoFromJson(Map<String, dynamic> json) {
  return _CreateCircleDto.fromJson(json);
}

/// @nodoc
mixin _$CreateCircleDto {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get skillFocus => throw _privateConstructorUsedError;
  int get maxMembers => throw _privateConstructorUsedError;

  /// Serializes this CreateCircleDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCircleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCircleDtoCopyWith<CreateCircleDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCircleDtoCopyWith<$Res> {
  factory $CreateCircleDtoCopyWith(
    CreateCircleDto value,
    $Res Function(CreateCircleDto) then,
  ) = _$CreateCircleDtoCopyWithImpl<$Res, CreateCircleDto>;
  @useResult
  $Res call({
    String name,
    String description,
    List<String> skillFocus,
    int maxMembers,
  });
}

/// @nodoc
class _$CreateCircleDtoCopyWithImpl<$Res, $Val extends CreateCircleDto>
    implements $CreateCircleDtoCopyWith<$Res> {
  _$CreateCircleDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCircleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? skillFocus = null,
    Object? maxMembers = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            skillFocus: null == skillFocus
                ? _value.skillFocus
                : skillFocus // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            maxMembers: null == maxMembers
                ? _value.maxMembers
                : maxMembers // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateCircleDtoImplCopyWith<$Res>
    implements $CreateCircleDtoCopyWith<$Res> {
  factory _$$CreateCircleDtoImplCopyWith(
    _$CreateCircleDtoImpl value,
    $Res Function(_$CreateCircleDtoImpl) then,
  ) = __$$CreateCircleDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String description,
    List<String> skillFocus,
    int maxMembers,
  });
}

/// @nodoc
class __$$CreateCircleDtoImplCopyWithImpl<$Res>
    extends _$CreateCircleDtoCopyWithImpl<$Res, _$CreateCircleDtoImpl>
    implements _$$CreateCircleDtoImplCopyWith<$Res> {
  __$$CreateCircleDtoImplCopyWithImpl(
    _$CreateCircleDtoImpl _value,
    $Res Function(_$CreateCircleDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateCircleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? skillFocus = null,
    Object? maxMembers = null,
  }) {
    return _then(
      _$CreateCircleDtoImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        skillFocus: null == skillFocus
            ? _value._skillFocus
            : skillFocus // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        maxMembers: null == maxMembers
            ? _value.maxMembers
            : maxMembers // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCircleDtoImpl implements _CreateCircleDto {
  const _$CreateCircleDtoImpl({
    required this.name,
    required this.description,
    final List<String> skillFocus = const [],
    this.maxMembers = 20,
  }) : _skillFocus = skillFocus;

  factory _$CreateCircleDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCircleDtoImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  final List<String> _skillFocus;
  @override
  @JsonKey()
  List<String> get skillFocus {
    if (_skillFocus is EqualUnmodifiableListView) return _skillFocus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillFocus);
  }

  @override
  @JsonKey()
  final int maxMembers;

  @override
  String toString() {
    return 'CreateCircleDto(name: $name, description: $description, skillFocus: $skillFocus, maxMembers: $maxMembers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCircleDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._skillFocus,
              _skillFocus,
            ) &&
            (identical(other.maxMembers, maxMembers) ||
                other.maxMembers == maxMembers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    description,
    const DeepCollectionEquality().hash(_skillFocus),
    maxMembers,
  );

  /// Create a copy of CreateCircleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCircleDtoImplCopyWith<_$CreateCircleDtoImpl> get copyWith =>
      __$$CreateCircleDtoImplCopyWithImpl<_$CreateCircleDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCircleDtoImplToJson(this);
  }
}

abstract class _CreateCircleDto implements CreateCircleDto {
  const factory _CreateCircleDto({
    required final String name,
    required final String description,
    final List<String> skillFocus,
    final int maxMembers,
  }) = _$CreateCircleDtoImpl;

  factory _CreateCircleDto.fromJson(Map<String, dynamic> json) =
      _$CreateCircleDtoImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get skillFocus;
  @override
  int get maxMembers;

  /// Create a copy of CreateCircleDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCircleDtoImplCopyWith<_$CreateCircleDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
