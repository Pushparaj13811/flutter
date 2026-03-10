// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewStatsModel _$ReviewStatsModelFromJson(Map<String, dynamic> json) {
  return _ReviewStatsModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewStatsModel {
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  Map<String, int> get ratingDistribution => throw _privateConstructorUsedError;

  /// Serializes this ReviewStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewStatsModelCopyWith<ReviewStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewStatsModelCopyWith<$Res> {
  factory $ReviewStatsModelCopyWith(
    ReviewStatsModel value,
    $Res Function(ReviewStatsModel) then,
  ) = _$ReviewStatsModelCopyWithImpl<$Res, ReviewStatsModel>;
  @useResult
  $Res call({
    double averageRating,
    int totalReviews,
    Map<String, int> ratingDistribution,
  });
}

/// @nodoc
class _$ReviewStatsModelCopyWithImpl<$Res, $Val extends ReviewStatsModel>
    implements $ReviewStatsModelCopyWith<$Res> {
  _$ReviewStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? ratingDistribution = null,
  }) {
    return _then(
      _value.copyWith(
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalReviews: null == totalReviews
                ? _value.totalReviews
                : totalReviews // ignore: cast_nullable_to_non_nullable
                      as int,
            ratingDistribution: null == ratingDistribution
                ? _value.ratingDistribution
                : ratingDistribution // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewStatsModelImplCopyWith<$Res>
    implements $ReviewStatsModelCopyWith<$Res> {
  factory _$$ReviewStatsModelImplCopyWith(
    _$ReviewStatsModelImpl value,
    $Res Function(_$ReviewStatsModelImpl) then,
  ) = __$$ReviewStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double averageRating,
    int totalReviews,
    Map<String, int> ratingDistribution,
  });
}

/// @nodoc
class __$$ReviewStatsModelImplCopyWithImpl<$Res>
    extends _$ReviewStatsModelCopyWithImpl<$Res, _$ReviewStatsModelImpl>
    implements _$$ReviewStatsModelImplCopyWith<$Res> {
  __$$ReviewStatsModelImplCopyWithImpl(
    _$ReviewStatsModelImpl _value,
    $Res Function(_$ReviewStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? ratingDistribution = null,
  }) {
    return _then(
      _$ReviewStatsModelImpl(
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalReviews: null == totalReviews
            ? _value.totalReviews
            : totalReviews // ignore: cast_nullable_to_non_nullable
                  as int,
        ratingDistribution: null == ratingDistribution
            ? _value._ratingDistribution
            : ratingDistribution // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewStatsModelImpl implements _ReviewStatsModel {
  const _$ReviewStatsModelImpl({
    this.averageRating = 0.0,
    this.totalReviews = 0,
    final Map<String, int> ratingDistribution = const {},
  }) : _ratingDistribution = ratingDistribution;

  factory _$ReviewStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewStatsModelImplFromJson(json);

  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int totalReviews;
  final Map<String, int> _ratingDistribution;
  @override
  @JsonKey()
  Map<String, int> get ratingDistribution {
    if (_ratingDistribution is EqualUnmodifiableMapView)
      return _ratingDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ratingDistribution);
  }

  @override
  String toString() {
    return 'ReviewStatsModel(averageRating: $averageRating, totalReviews: $totalReviews, ratingDistribution: $ratingDistribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewStatsModelImpl &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            const DeepCollectionEquality().equals(
              other._ratingDistribution,
              _ratingDistribution,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageRating,
    totalReviews,
    const DeepCollectionEquality().hash(_ratingDistribution),
  );

  /// Create a copy of ReviewStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewStatsModelImplCopyWith<_$ReviewStatsModelImpl> get copyWith =>
      __$$ReviewStatsModelImplCopyWithImpl<_$ReviewStatsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewStatsModelImplToJson(this);
  }
}

abstract class _ReviewStatsModel implements ReviewStatsModel {
  const factory _ReviewStatsModel({
    final double averageRating,
    final int totalReviews,
    final Map<String, int> ratingDistribution,
  }) = _$ReviewStatsModelImpl;

  factory _ReviewStatsModel.fromJson(Map<String, dynamic> json) =
      _$ReviewStatsModelImpl.fromJson;

  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  Map<String, int> get ratingDistribution;

  /// Create a copy of ReviewStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewStatsModelImplCopyWith<_$ReviewStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
