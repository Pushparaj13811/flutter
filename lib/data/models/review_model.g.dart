// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      skillsReviewed:
          (json['skillsReviewed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sessionId: json['sessionId'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      fromUser: json['fromUser'] == null
          ? null
          : UserProfileModel.fromJson(json['fromUser'] as Map<String, dynamic>),
      toUser: json['toUser'] == null
          ? null
          : UserProfileModel.fromJson(json['toUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'rating': instance.rating,
      'comment': instance.comment,
      'skillsReviewed': instance.skillsReviewed,
      'sessionId': instance.sessionId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'fromUser': instance.fromUser,
      'toUser': instance.toUser,
    };
