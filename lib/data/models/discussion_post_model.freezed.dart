// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discussion_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscussionPostModel _$DiscussionPostModelFromJson(Map<String, dynamic> json) {
  return _DiscussionPostModel.fromJson(json);
}

/// @nodoc
mixin _$DiscussionPostModel {
  String get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentsCount => throw _privateConstructorUsedError;
  bool get isLikedByMe => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  UserProfileModel? get author => throw _privateConstructorUsedError;

  /// Serializes this DiscussionPostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscussionPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscussionPostModelCopyWith<DiscussionPostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscussionPostModelCopyWith<$Res> {
  factory $DiscussionPostModelCopyWith(
    DiscussionPostModel value,
    $Res Function(DiscussionPostModel) then,
  ) = _$DiscussionPostModelCopyWithImpl<$Res, DiscussionPostModel>;
  @useResult
  $Res call({
    String id,
    String authorId,
    String title,
    String content,
    List<String> tags,
    int likesCount,
    int commentsCount,
    bool isLikedByMe,
    String createdAt,
    String updatedAt,
    UserProfileModel? author,
  });

  $UserProfileModelCopyWith<$Res>? get author;
}

/// @nodoc
class _$DiscussionPostModelCopyWithImpl<$Res, $Val extends DiscussionPostModel>
    implements $DiscussionPostModelCopyWith<$Res> {
  _$DiscussionPostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscussionPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? isLikedByMe = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? author = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            authorId: null == authorId
                ? _value.authorId
                : authorId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            likesCount: null == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            commentsCount: null == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLikedByMe: null == isLikedByMe
                ? _value.isLikedByMe
                : isLikedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of DiscussionPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiscussionPostModelImplCopyWith<$Res>
    implements $DiscussionPostModelCopyWith<$Res> {
  factory _$$DiscussionPostModelImplCopyWith(
    _$DiscussionPostModelImpl value,
    $Res Function(_$DiscussionPostModelImpl) then,
  ) = __$$DiscussionPostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String authorId,
    String title,
    String content,
    List<String> tags,
    int likesCount,
    int commentsCount,
    bool isLikedByMe,
    String createdAt,
    String updatedAt,
    UserProfileModel? author,
  });

  @override
  $UserProfileModelCopyWith<$Res>? get author;
}

/// @nodoc
class __$$DiscussionPostModelImplCopyWithImpl<$Res>
    extends _$DiscussionPostModelCopyWithImpl<$Res, _$DiscussionPostModelImpl>
    implements _$$DiscussionPostModelImplCopyWith<$Res> {
  __$$DiscussionPostModelImplCopyWithImpl(
    _$DiscussionPostModelImpl _value,
    $Res Function(_$DiscussionPostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscussionPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
    Object? likesCount = null,
    Object? commentsCount = null,
    Object? isLikedByMe = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? author = freezed,
  }) {
    return _then(
      _$DiscussionPostModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        authorId: null == authorId
            ? _value.authorId
            : authorId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        likesCount: null == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        commentsCount: null == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLikedByMe: null == isLikedByMe
            ? _value.isLikedByMe
            : isLikedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscussionPostModelImpl implements _DiscussionPostModel {
  const _$DiscussionPostModelImpl({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    final List<String> tags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByMe = false,
    required this.createdAt,
    required this.updatedAt,
    this.author,
  }) : _tags = tags;

  factory _$DiscussionPostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscussionPostModelImplFromJson(json);

  @override
  final String id;
  @override
  final String authorId;
  @override
  final String title;
  @override
  final String content;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final int commentsCount;
  @override
  @JsonKey()
  final bool isLikedByMe;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final UserProfileModel? author;

  @override
  String toString() {
    return 'DiscussionPostModel(id: $id, authorId: $authorId, title: $title, content: $content, tags: $tags, likesCount: $likesCount, commentsCount: $commentsCount, isLikedByMe: $isLikedByMe, createdAt: $createdAt, updatedAt: $updatedAt, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscussionPostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.isLikedByMe, isLikedByMe) ||
                other.isLikedByMe == isLikedByMe) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.author, author) || other.author == author));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    authorId,
    title,
    content,
    const DeepCollectionEquality().hash(_tags),
    likesCount,
    commentsCount,
    isLikedByMe,
    createdAt,
    updatedAt,
    author,
  );

  /// Create a copy of DiscussionPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscussionPostModelImplCopyWith<_$DiscussionPostModelImpl> get copyWith =>
      __$$DiscussionPostModelImplCopyWithImpl<_$DiscussionPostModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscussionPostModelImplToJson(this);
  }
}

abstract class _DiscussionPostModel implements DiscussionPostModel {
  const factory _DiscussionPostModel({
    required final String id,
    required final String authorId,
    required final String title,
    required final String content,
    final List<String> tags,
    final int likesCount,
    final int commentsCount,
    final bool isLikedByMe,
    required final String createdAt,
    required final String updatedAt,
    final UserProfileModel? author,
  }) = _$DiscussionPostModelImpl;

  factory _DiscussionPostModel.fromJson(Map<String, dynamic> json) =
      _$DiscussionPostModelImpl.fromJson;

  @override
  String get id;
  @override
  String get authorId;
  @override
  String get title;
  @override
  String get content;
  @override
  List<String> get tags;
  @override
  int get likesCount;
  @override
  int get commentsCount;
  @override
  bool get isLikedByMe;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  UserProfileModel? get author;

  /// Create a copy of DiscussionPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscussionPostModelImplCopyWith<_$DiscussionPostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePostDto _$CreatePostDtoFromJson(Map<String, dynamic> json) {
  return _CreatePostDto.fromJson(json);
}

/// @nodoc
mixin _$CreatePostDto {
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this CreatePostDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePostDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePostDtoCopyWith<CreatePostDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostDtoCopyWith<$Res> {
  factory $CreatePostDtoCopyWith(
    CreatePostDto value,
    $Res Function(CreatePostDto) then,
  ) = _$CreatePostDtoCopyWithImpl<$Res, CreatePostDto>;
  @useResult
  $Res call({String title, String content, List<String> tags});
}

/// @nodoc
class _$CreatePostDtoCopyWithImpl<$Res, $Val extends CreatePostDto>
    implements $CreatePostDtoCopyWith<$Res> {
  _$CreatePostDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePostDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? tags = null,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePostDtoImplCopyWith<$Res>
    implements $CreatePostDtoCopyWith<$Res> {
  factory _$$CreatePostDtoImplCopyWith(
    _$CreatePostDtoImpl value,
    $Res Function(_$CreatePostDtoImpl) then,
  ) = __$$CreatePostDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String content, List<String> tags});
}

/// @nodoc
class __$$CreatePostDtoImplCopyWithImpl<$Res>
    extends _$CreatePostDtoCopyWithImpl<$Res, _$CreatePostDtoImpl>
    implements _$$CreatePostDtoImplCopyWith<$Res> {
  __$$CreatePostDtoImplCopyWithImpl(
    _$CreatePostDtoImpl _value,
    $Res Function(_$CreatePostDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePostDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? tags = null,
  }) {
    return _then(
      _$CreatePostDtoImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostDtoImpl implements _CreatePostDto {
  const _$CreatePostDtoImpl({
    required this.title,
    required this.content,
    final List<String> tags = const [],
  }) : _tags = tags;

  factory _$CreatePostDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostDtoImplFromJson(json);

  @override
  final String title;
  @override
  final String content;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'CreatePostDto(title: $title, content: $content, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostDtoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    content,
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of CreatePostDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostDtoImplCopyWith<_$CreatePostDtoImpl> get copyWith =>
      __$$CreatePostDtoImplCopyWithImpl<_$CreatePostDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostDtoImplToJson(this);
  }
}

abstract class _CreatePostDto implements CreatePostDto {
  const factory _CreatePostDto({
    required final String title,
    required final String content,
    final List<String> tags,
  }) = _$CreatePostDtoImpl;

  factory _CreatePostDto.fromJson(Map<String, dynamic> json) =
      _$CreatePostDtoImpl.fromJson;

  @override
  String get title;
  @override
  String get content;
  @override
  List<String> get tags;

  /// Create a copy of CreatePostDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostDtoImplCopyWith<_$CreatePostDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
