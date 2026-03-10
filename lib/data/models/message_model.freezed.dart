// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get receiverId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  bool get read => throw _privateConstructorUsedError;
  UserProfileModel? get sender => throw _privateConstructorUsedError;
  bool get isFromMe => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
    MessageModel value,
    $Res Function(MessageModel) then,
  ) = _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call({
    String id,
    String conversationId,
    String senderId,
    String receiverId,
    String content,
    String createdAt,
    bool read,
    UserProfileModel? sender,
    bool isFromMe,
  });

  $UserProfileModelCopyWith<$Res>? get sender;
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? read = null,
    Object? sender = freezed,
    Object? isFromMe = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationId: null == conversationId
                ? _value.conversationId
                : conversationId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            receiverId: null == receiverId
                ? _value.receiverId
                : receiverId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            read: null == read
                ? _value.read
                : read // ignore: cast_nullable_to_non_nullable
                      as bool,
            sender: freezed == sender
                ? _value.sender
                : sender // ignore: cast_nullable_to_non_nullable
                      as UserProfileModel?,
            isFromMe: null == isFromMe
                ? _value.isFromMe
                : isFromMe // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get sender {
    if (_value.sender == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.sender!, (value) {
      return _then(_value.copyWith(sender: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
    _$MessageModelImpl value,
    $Res Function(_$MessageModelImpl) then,
  ) = __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conversationId,
    String senderId,
    String receiverId,
    String content,
    String createdAt,
    bool read,
    UserProfileModel? sender,
    bool isFromMe,
  });

  @override
  $UserProfileModelCopyWith<$Res>? get sender;
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
    _$MessageModelImpl _value,
    $Res Function(_$MessageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? receiverId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? read = null,
    Object? sender = freezed,
    Object? isFromMe = null,
  }) {
    return _then(
      _$MessageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationId: null == conversationId
            ? _value.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        receiverId: null == receiverId
            ? _value.receiverId
            : receiverId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        read: null == read
            ? _value.read
            : read // ignore: cast_nullable_to_non_nullable
                  as bool,
        sender: freezed == sender
            ? _value.sender
            : sender // ignore: cast_nullable_to_non_nullable
                  as UserProfileModel?,
        isFromMe: null == isFromMe
            ? _value.isFromMe
            : isFromMe // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    this.read = false,
    this.sender,
    this.isFromMe = false,
  });

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String senderId;
  @override
  final String receiverId;
  @override
  final String content;
  @override
  final String createdAt;
  @override
  @JsonKey()
  final bool read;
  @override
  final UserProfileModel? sender;
  @override
  @JsonKey()
  final bool isFromMe;

  @override
  String toString() {
    return 'MessageModel(id: $id, conversationId: $conversationId, senderId: $senderId, receiverId: $receiverId, content: $content, createdAt: $createdAt, read: $read, sender: $sender, isFromMe: $isFromMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.read, read) || other.read == read) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.isFromMe, isFromMe) ||
                other.isFromMe == isFromMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conversationId,
    senderId,
    receiverId,
    content,
    createdAt,
    read,
    sender,
    isFromMe,
  );

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(this);
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel({
    required final String id,
    required final String conversationId,
    required final String senderId,
    required final String receiverId,
    required final String content,
    required final String createdAt,
    final bool read,
    final UserProfileModel? sender,
    final bool isFromMe,
  }) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get senderId;
  @override
  String get receiverId;
  @override
  String get content;
  @override
  String get createdAt;
  @override
  bool get read;
  @override
  UserProfileModel? get sender;
  @override
  bool get isFromMe;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
