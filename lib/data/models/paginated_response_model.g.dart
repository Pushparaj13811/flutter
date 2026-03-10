// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginationModelImpl _$$PaginationModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginationModelImpl(
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
  hasNextPage: json['hasNextPage'] as bool? ?? false,
  hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
);

Map<String, dynamic> _$$PaginationModelImplToJson(
  _$PaginationModelImpl instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'totalItems': instance.totalItems,
  'totalPages': instance.totalPages,
  'hasNextPage': instance.hasNextPage,
  'hasPreviousPage': instance.hasPreviousPage,
};
