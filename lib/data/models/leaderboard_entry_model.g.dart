// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryModelImpl _$$LeaderboardEntryModelImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryModelImpl(
  userId: json['userId'] as String,
  rank: (json['rank'] as num).toInt(),
  points: (json['points'] as num?)?.toInt() ?? 0,
  sessionsCompleted: (json['sessionsCompleted'] as num?)?.toInt() ?? 0,
  reviewsGiven: (json['reviewsGiven'] as num?)?.toInt() ?? 0,
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
  user: json['user'] == null
      ? null
      : UserProfileModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$LeaderboardEntryModelImplToJson(
  _$LeaderboardEntryModelImpl instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'rank': instance.rank,
  'points': instance.points,
  'sessionsCompleted': instance.sessionsCompleted,
  'reviewsGiven': instance.reviewsGiven,
  'averageRating': instance.averageRating,
  'user': instance.user,
};
