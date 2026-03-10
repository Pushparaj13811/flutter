// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_review_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateReviewDto _$CreateReviewDtoFromJson(Map<String, dynamic> json) {
  return _CreateReviewDto.fromJson(json);
}

/// @nodoc
mixin _$CreateReviewDto {
  String get toUserId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  List<String> get skillsReviewed => throw _privateConstructorUsedError;
  String? get sessionId => throw _privateConstructorUsedError;

  /// Serializes this CreateReviewDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReviewDtoCopyWith<CreateReviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReviewDtoCopyWith<$Res> {
  factory $CreateReviewDtoCopyWith(
    CreateReviewDto value,
    $Res Function(CreateReviewDto) then,
  ) = _$CreateReviewDtoCopyWithImpl<$Res, CreateReviewDto>;
  @useResult
  $Res call({
    String toUserId,
    int rating,
    String comment,
    List<String> skillsReviewed,
    String? sessionId,
  });
}

/// @nodoc
class _$CreateReviewDtoCopyWithImpl<$Res, $Val extends CreateReviewDto>
    implements $CreateReviewDtoCopyWith<$Res> {
  _$CreateReviewDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toUserId = null,
    Object? rating = null,
    Object? comment = null,
    Object? skillsReviewed = null,
    Object? sessionId = freezed,
  }) {
    return _then(
      _value.copyWith(
            toUserId: null == toUserId
                ? _value.toUserId
                : toUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            comment: null == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String,
            skillsReviewed: null == skillsReviewed
                ? _value.skillsReviewed
                : skillsReviewed // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            sessionId: freezed == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateReviewDtoImplCopyWith<$Res>
    implements $CreateReviewDtoCopyWith<$Res> {
  factory _$$CreateReviewDtoImplCopyWith(
    _$CreateReviewDtoImpl value,
    $Res Function(_$CreateReviewDtoImpl) then,
  ) = __$$CreateReviewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String toUserId,
    int rating,
    String comment,
    List<String> skillsReviewed,
    String? sessionId,
  });
}

/// @nodoc
class __$$CreateReviewDtoImplCopyWithImpl<$Res>
    extends _$CreateReviewDtoCopyWithImpl<$Res, _$CreateReviewDtoImpl>
    implements _$$CreateReviewDtoImplCopyWith<$Res> {
  __$$CreateReviewDtoImplCopyWithImpl(
    _$CreateReviewDtoImpl _value,
    $Res Function(_$CreateReviewDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? toUserId = null,
    Object? rating = null,
    Object? comment = null,
    Object? skillsReviewed = null,
    Object? sessionId = freezed,
  }) {
    return _then(
      _$CreateReviewDtoImpl(
        toUserId: null == toUserId
            ? _value.toUserId
            : toUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        comment: null == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String,
        skillsReviewed: null == skillsReviewed
            ? _value._skillsReviewed
            : skillsReviewed // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        sessionId: freezed == sessionId
            ? _value.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReviewDtoImpl implements _CreateReviewDto {
  const _$CreateReviewDtoImpl({
    required this.toUserId,
    required this.rating,
    required this.comment,
    final List<String> skillsReviewed = const [],
    this.sessionId,
  }) : _skillsReviewed = skillsReviewed;

  factory _$CreateReviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReviewDtoImplFromJson(json);

  @override
  final String toUserId;
  @override
  final int rating;
  @override
  final String comment;
  final List<String> _skillsReviewed;
  @override
  @JsonKey()
  List<String> get skillsReviewed {
    if (_skillsReviewed is EqualUnmodifiableListView) return _skillsReviewed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsReviewed);
  }

  @override
  final String? sessionId;

  @override
  String toString() {
    return 'CreateReviewDto(toUserId: $toUserId, rating: $rating, comment: $comment, skillsReviewed: $skillsReviewed, sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReviewDtoImpl &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(
              other._skillsReviewed,
              _skillsReviewed,
            ) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    toUserId,
    rating,
    comment,
    const DeepCollectionEquality().hash(_skillsReviewed),
    sessionId,
  );

  /// Create a copy of CreateReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReviewDtoImplCopyWith<_$CreateReviewDtoImpl> get copyWith =>
      __$$CreateReviewDtoImplCopyWithImpl<_$CreateReviewDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReviewDtoImplToJson(this);
  }
}

abstract class _CreateReviewDto implements CreateReviewDto {
  const factory _CreateReviewDto({
    required final String toUserId,
    required final int rating,
    required final String comment,
    final List<String> skillsReviewed,
    final String? sessionId,
  }) = _$CreateReviewDtoImpl;

  factory _CreateReviewDto.fromJson(Map<String, dynamic> json) =
      _$CreateReviewDtoImpl.fromJson;

  @override
  String get toUserId;
  @override
  int get rating;
  @override
  String get comment;
  @override
  List<String> get skillsReviewed;
  @override
  String? get sessionId;

  /// Create a copy of CreateReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReviewDtoImplCopyWith<_$CreateReviewDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
