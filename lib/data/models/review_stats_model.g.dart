// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewStatsModelImpl _$$ReviewStatsModelImplFromJson(
  Map<String, dynamic> json,
) => _$ReviewStatsModelImpl(
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
  totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
  ratingDistribution:
      (json['ratingDistribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const {},
);

Map<String, dynamic> _$$ReviewStatsModelImplToJson(
  _$ReviewStatsModelImpl instance,
) => <String, dynamic>{
  'averageRating': instance.averageRating,
  'totalReviews': instance.totalReviews,
  'ratingDistribution': instance.ratingDistribution,
};
