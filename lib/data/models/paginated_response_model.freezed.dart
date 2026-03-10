// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) {
  return _PaginationModel.fromJson(json);
}

/// @nodoc
mixin _$PaginationModel {
  int get page => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get hasNextPage => throw _privateConstructorUsedError;
  bool get hasPreviousPage => throw _privateConstructorUsedError;

  /// Serializes this PaginationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationModelCopyWith<PaginationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationModelCopyWith<$Res> {
  factory $PaginationModelCopyWith(
    PaginationModel value,
    $Res Function(PaginationModel) then,
  ) = _$PaginationModelCopyWithImpl<$Res, PaginationModel>;
  @useResult
  $Res call({
    int page,
    int pageSize,
    int totalItems,
    int totalPages,
    bool hasNextPage,
    bool hasPreviousPage,
  });
}

/// @nodoc
class _$PaginationModelCopyWithImpl<$Res, $Val extends PaginationModel>
    implements $PaginationModelCopyWith<$Res> {
  _$PaginationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? pageSize = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? hasNextPage = null,
    Object? hasPreviousPage = null,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            pageSize: null == pageSize
                ? _value.pageSize
                : pageSize // ignore: cast_nullable_to_non_nullable
                      as int,
            totalItems: null == totalItems
                ? _value.totalItems
                : totalItems // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            hasNextPage: null == hasNextPage
                ? _value.hasNextPage
                : hasNextPage // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasPreviousPage: null == hasPreviousPage
                ? _value.hasPreviousPage
                : hasPreviousPage // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginationModelImplCopyWith<$Res>
    implements $PaginationModelCopyWith<$Res> {
  factory _$$PaginationModelImplCopyWith(
    _$PaginationModelImpl value,
    $Res Function(_$PaginationModelImpl) then,
  ) = __$$PaginationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int page,
    int pageSize,
    int totalItems,
    int totalPages,
    bool hasNextPage,
    bool hasPreviousPage,
  });
}

/// @nodoc
class __$$PaginationModelImplCopyWithImpl<$Res>
    extends _$PaginationModelCopyWithImpl<$Res, _$PaginationModelImpl>
    implements _$$PaginationModelImplCopyWith<$Res> {
  __$$PaginationModelImplCopyWithImpl(
    _$PaginationModelImpl _value,
    $Res Function(_$PaginationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? pageSize = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? hasNextPage = null,
    Object? hasPreviousPage = null,
  }) {
    return _then(
      _$PaginationModelImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        pageSize: null == pageSize
            ? _value.pageSize
            : pageSize // ignore: cast_nullable_to_non_nullable
                  as int,
        totalItems: null == totalItems
            ? _value.totalItems
            : totalItems // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        hasNextPage: null == hasNextPage
            ? _value.hasNextPage
            : hasNextPage // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasPreviousPage: null == hasPreviousPage
            ? _value.hasPreviousPage
            : hasPreviousPage // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationModelImpl implements _PaginationModel {
  const _$PaginationModelImpl({
    this.page = 1,
    this.pageSize = 20,
    this.totalItems = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  factory _$PaginationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationModelImplFromJson(json);

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final int totalItems;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final bool hasNextPage;
  @override
  @JsonKey()
  final bool hasPreviousPage;

  @override
  String toString() {
    return 'PaginationModel(page: $page, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationModelImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasNextPage, hasNextPage) ||
                other.hasNextPage == hasNextPage) &&
            (identical(other.hasPreviousPage, hasPreviousPage) ||
                other.hasPreviousPage == hasPreviousPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    page,
    pageSize,
    totalItems,
    totalPages,
    hasNextPage,
    hasPreviousPage,
  );

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationModelImplCopyWith<_$PaginationModelImpl> get copyWith =>
      __$$PaginationModelImplCopyWithImpl<_$PaginationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationModelImplToJson(this);
  }
}

abstract class _PaginationModel implements PaginationModel {
  const factory _PaginationModel({
    final int page,
    final int pageSize,
    final int totalItems,
    final int totalPages,
    final bool hasNextPage,
    final bool hasPreviousPage,
  }) = _$PaginationModelImpl;

  factory _PaginationModel.fromJson(Map<String, dynamic> json) =
      _$PaginationModelImpl.fromJson;

  @override
  int get page;
  @override
  int get pageSize;
  @override
  int get totalItems;
  @override
  int get totalPages;
  @override
  bool get hasNextPage;
  @override
  bool get hasPreviousPage;

  /// Create a copy of PaginationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationModelImplCopyWith<_$PaginationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
