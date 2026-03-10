// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateReviewDtoImpl _$$CreateReviewDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateReviewDtoImpl(
  toUserId: json['toUserId'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  skillsReviewed:
      (json['skillsReviewed'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  sessionId: json['sessionId'] as String?,
);

Map<String, dynamic> _$$CreateReviewDtoImplToJson(
  _$CreateReviewDtoImpl instance,
) => <String, dynamic>{
  'toUserId': instance.toUserId,
  'rating': instance.rating,
  'comment': instance.comment,
  'skillsReviewed': instance.skillsReviewed,
  'sessionId': instance.sessionId,
};
