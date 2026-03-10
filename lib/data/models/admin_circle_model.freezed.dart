// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_circle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdminCircleModel _$AdminCircleModelFromJson(Map<String, dynamic> json) {
  return _AdminCircleModel.fromJson(json);
}

/// @nodoc
mixin _$AdminCircleModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this AdminCircleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminCircleModelCopyWith<AdminCircleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminCircleModelCopyWith<$Res> {
  factory $AdminCircleModelCopyWith(
    AdminCircleModel value,
    $Res Function(AdminCircleModel) then,
  ) = _$AdminCircleModelCopyWithImpl<$Res, AdminCircleModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    int memberCount,
    bool isFeatured,
    bool isActive,
    String createdAt,
    String? imageUrl,
  });
}

/// @nodoc
class _$AdminCircleModelCopyWithImpl<$Res, $Val extends AdminCircleModel>
    implements $AdminCircleModelCopyWith<$Res> {
  _$AdminCircleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? memberCount = null,
    Object? isFeatured = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
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
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isFeatured: null == isFeatured
                ? _value.isFeatured
                : isFeatured // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminCircleModelImplCopyWith<$Res>
    implements $AdminCircleModelCopyWith<$Res> {
  factory _$$AdminCircleModelImplCopyWith(
    _$AdminCircleModelImpl value,
    $Res Function(_$AdminCircleModelImpl) then,
  ) = __$$AdminCircleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    int memberCount,
    bool isFeatured,
    bool isActive,
    String createdAt,
    String? imageUrl,
  });
}

/// @nodoc
class __$$AdminCircleModelImplCopyWithImpl<$Res>
    extends _$AdminCircleModelCopyWithImpl<$Res, _$AdminCircleModelImpl>
    implements _$$AdminCircleModelImplCopyWith<$Res> {
  __$$AdminCircleModelImplCopyWithImpl(
    _$AdminCircleModelImpl _value,
    $Res Function(_$AdminCircleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? memberCount = null,
    Object? isFeatured = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? imageUrl = freezed,
  }) {
    return _then(
      _$AdminCircleModelImpl(
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
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isFeatured: null == isFeatured
            ? _value.isFeatured
            : isFeatured // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminCircleModelImpl implements _AdminCircleModel {
  const _$AdminCircleModelImpl({
    required this.id,
    required this.name,
    this.description = '',
    this.memberCount = 0,
    this.isFeatured = false,
    this.isActive = true,
    required this.createdAt,
    this.imageUrl,
  });

  factory _$AdminCircleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminCircleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int memberCount;
  @override
  @JsonKey()
  final bool isFeatured;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdAt;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'AdminCircleModel(id: $id, name: $name, description: $description, memberCount: $memberCount, isFeatured: $isFeatured, isActive: $isActive, createdAt: $createdAt, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminCircleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    memberCount,
    isFeatured,
    isActive,
    createdAt,
    imageUrl,
  );

  /// Create a copy of AdminCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminCircleModelImplCopyWith<_$AdminCircleModelImpl> get copyWith =>
      __$$AdminCircleModelImplCopyWithImpl<_$AdminCircleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminCircleModelImplToJson(this);
  }
}

abstract class _AdminCircleModel implements AdminCircleModel {
  const factory _AdminCircleModel({
    required final String id,
    required final String name,
    final String description,
    final int memberCount,
    final bool isFeatured,
    final bool isActive,
    required final String createdAt,
    final String? imageUrl,
  }) = _$AdminCircleModelImpl;

  factory _AdminCircleModel.fromJson(Map<String, dynamic> json) =
      _$AdminCircleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int get memberCount;
  @override
  bool get isFeatured;
  @override
  bool get isActive;
  @override
  String get createdAt;
  @override
  String? get imageUrl;

  /// Create a copy of AdminCircleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminCircleModelImplCopyWith<_$AdminCircleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
