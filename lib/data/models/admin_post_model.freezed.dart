// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdminPostModel _$AdminPostModelFromJson(Map<String, dynamic> json) {
  return _AdminPostModel.fromJson(json);
}

/// @nodoc
mixin _$AdminPostModel {
  String get id => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String? get authorAvatar => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get skillTag => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get repliesCount => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isHidden => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AdminPostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminPostModelCopyWith<AdminPostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminPostModelCopyWith<$Res> {
  factory $AdminPostModelCopyWith(
    AdminPostModel value,
    $Res Function(AdminPostModel) then,
  ) = _$AdminPostModelCopyWithImpl<$Res, AdminPostModel>;
  @useResult
  $Res call({
    String id,
    String authorName,
    String? authorAvatar,
    String content,
    String skillTag,
    int likesCount,
    int repliesCount,
    bool isPinned,
    bool isHidden,
    String createdAt,
  });
}

/// @nodoc
class _$AdminPostModelCopyWithImpl<$Res, $Val extends AdminPostModel>
    implements $AdminPostModelCopyWith<$Res> {
  _$AdminPostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorName = null,
    Object? authorAvatar = freezed,
    Object? content = null,
    Object? skillTag = null,
    Object? likesCount = null,
    Object? repliesCount = null,
    Object? isPinned = null,
    Object? isHidden = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            authorName: null == authorName
                ? _value.authorName
                : authorName // ignore: cast_nullable_to_non_nullable
                      as String,
            authorAvatar: freezed == authorAvatar
                ? _value.authorAvatar
                : authorAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            skillTag: null == skillTag
                ? _value.skillTag
                : skillTag // ignore: cast_nullable_to_non_nullable
                      as String,
            likesCount: null == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            repliesCount: null == repliesCount
                ? _value.repliesCount
                : repliesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isPinned: null == isPinned
                ? _value.isPinned
                : isPinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            isHidden: null == isHidden
                ? _value.isHidden
                : isHidden // ignore: cast_nullable_to_non_nullable
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
abstract class _$$AdminPostModelImplCopyWith<$Res>
    implements $AdminPostModelCopyWith<$Res> {
  factory _$$AdminPostModelImplCopyWith(
    _$AdminPostModelImpl value,
    $Res Function(_$AdminPostModelImpl) then,
  ) = __$$AdminPostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String authorName,
    String? authorAvatar,
    String content,
    String skillTag,
    int likesCount,
    int repliesCount,
    bool isPinned,
    bool isHidden,
    String createdAt,
  });
}

/// @nodoc
class __$$AdminPostModelImplCopyWithImpl<$Res>
    extends _$AdminPostModelCopyWithImpl<$Res, _$AdminPostModelImpl>
    implements _$$AdminPostModelImplCopyWith<$Res> {
  __$$AdminPostModelImplCopyWithImpl(
    _$AdminPostModelImpl _value,
    $Res Function(_$AdminPostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorName = null,
    Object? authorAvatar = freezed,
    Object? content = null,
    Object? skillTag = null,
    Object? likesCount = null,
    Object? repliesCount = null,
    Object? isPinned = null,
    Object? isHidden = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AdminPostModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        authorName: null == authorName
            ? _value.authorName
            : authorName // ignore: cast_nullable_to_non_nullable
                  as String,
        authorAvatar: freezed == authorAvatar
            ? _value.authorAvatar
            : authorAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        skillTag: null == skillTag
            ? _value.skillTag
            : skillTag // ignore: cast_nullable_to_non_nullable
                  as String,
        likesCount: null == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        repliesCount: null == repliesCount
            ? _value.repliesCount
            : repliesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isPinned: null == isPinned
            ? _value.isPinned
            : isPinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        isHidden: null == isHidden
            ? _value.isHidden
            : isHidden // ignore: cast_nullable_to_non_nullable
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
class _$AdminPostModelImpl implements _AdminPostModel {
  const _$AdminPostModelImpl({
    required this.id,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.skillTag = '',
    this.likesCount = 0,
    this.repliesCount = 0,
    this.isPinned = false,
    this.isHidden = false,
    required this.createdAt,
  });

  factory _$AdminPostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminPostModelImplFromJson(json);

  @override
  final String id;
  @override
  final String authorName;
  @override
  final String? authorAvatar;
  @override
  final String content;
  @override
  @JsonKey()
  final String skillTag;
  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int repliesCount;
  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final bool isHidden;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'AdminPostModel(id: $id, authorName: $authorName, authorAvatar: $authorAvatar, content: $content, skillTag: $skillTag, likesCount: $likesCount, repliesCount: $repliesCount, isPinned: $isPinned, isHidden: $isHidden, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminPostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatar, authorAvatar) ||
                other.authorAvatar == authorAvatar) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.skillTag, skillTag) ||
                other.skillTag == skillTag) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.repliesCount, repliesCount) ||
                other.repliesCount == repliesCount) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    authorName,
    authorAvatar,
    content,
    skillTag,
    likesCount,
    repliesCount,
    isPinned,
    isHidden,
    createdAt,
  );

  /// Create a copy of AdminPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminPostModelImplCopyWith<_$AdminPostModelImpl> get copyWith =>
      __$$AdminPostModelImplCopyWithImpl<_$AdminPostModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminPostModelImplToJson(this);
  }
}

abstract class _AdminPostModel implements AdminPostModel {
  const factory _AdminPostModel({
    required final String id,
    required final String authorName,
    final String? authorAvatar,
    required final String content,
    final String skillTag,
    final int likesCount,
    final int repliesCount,
    final bool isPinned,
    final bool isHidden,
    required final String createdAt,
  }) = _$AdminPostModelImpl;

  factory _AdminPostModel.fromJson(Map<String, dynamic> json) =
      _$AdminPostModelImpl.fromJson;

  @override
  String get id;
  @override
  String get authorName;
  @override
  String? get authorAvatar;
  @override
  String get content;
  @override
  String get skillTag;
  @override
  int get likesCount;
  @override
  int get repliesCount;
  @override
  bool get isPinned;
  @override
  bool get isHidden;
  @override
  String get createdAt;

  /// Create a copy of AdminPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminPostModelImplCopyWith<_$AdminPostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
