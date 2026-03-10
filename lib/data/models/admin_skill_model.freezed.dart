// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_skill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdminSkillModel _$AdminSkillModelFromJson(Map<String, dynamic> json) {
  return _AdminSkillModel.fromJson(json);
}

/// @nodoc
mixin _$AdminSkillModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get usageCount => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AdminSkillModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminSkillModelCopyWith<AdminSkillModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminSkillModelCopyWith<$Res> {
  factory $AdminSkillModelCopyWith(
    AdminSkillModel value,
    $Res Function(AdminSkillModel) then,
  ) = _$AdminSkillModelCopyWithImpl<$Res, AdminSkillModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String category,
    int usageCount,
    bool isActive,
    String createdAt,
  });
}

/// @nodoc
class _$AdminSkillModelCopyWithImpl<$Res, $Val extends AdminSkillModel>
    implements $AdminSkillModelCopyWith<$Res> {
  _$AdminSkillModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? usageCount = null,
    Object? isActive = null,
    Object? createdAt = null,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            usageCount: null == usageCount
                ? _value.usageCount
                : usageCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminSkillModelImplCopyWith<$Res>
    implements $AdminSkillModelCopyWith<$Res> {
  factory _$$AdminSkillModelImplCopyWith(
    _$AdminSkillModelImpl value,
    $Res Function(_$AdminSkillModelImpl) then,
  ) = __$$AdminSkillModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String category,
    int usageCount,
    bool isActive,
    String createdAt,
  });
}

/// @nodoc
class __$$AdminSkillModelImplCopyWithImpl<$Res>
    extends _$AdminSkillModelCopyWithImpl<$Res, _$AdminSkillModelImpl>
    implements _$$AdminSkillModelImplCopyWith<$Res> {
  __$$AdminSkillModelImplCopyWithImpl(
    _$AdminSkillModelImpl _value,
    $Res Function(_$AdminSkillModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? usageCount = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AdminSkillModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        usageCount: null == usageCount
            ? _value.usageCount
            : usageCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminSkillModelImpl implements _AdminSkillModel {
  const _$AdminSkillModelImpl({
    required this.id,
    required this.name,
    required this.category,
    this.usageCount = 0,
    this.isActive = true,
    required this.createdAt,
  });

  factory _$AdminSkillModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminSkillModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  @JsonKey()
  final int usageCount;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'AdminSkillModel(id: $id, name: $name, category: $category, usageCount: $usageCount, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminSkillModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    category,
    usageCount,
    isActive,
    createdAt,
  );

  /// Create a copy of AdminSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminSkillModelImplCopyWith<_$AdminSkillModelImpl> get copyWith =>
      __$$AdminSkillModelImplCopyWithImpl<_$AdminSkillModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminSkillModelImplToJson(this);
  }
}

abstract class _AdminSkillModel implements AdminSkillModel {
  const factory _AdminSkillModel({
    required final String id,
    required final String name,
    required final String category,
    final int usageCount,
    final bool isActive,
    required final String createdAt,
  }) = _$AdminSkillModelImpl;

  factory _AdminSkillModel.fromJson(Map<String, dynamic> json) =
      _$AdminSkillModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get category;
  @override
  int get usageCount;
  @override
  bool get isActive;
  @override
  String get createdAt;

  /// Create a copy of AdminSkillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminSkillModelImplCopyWith<_$AdminSkillModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
