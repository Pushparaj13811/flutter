import 'package:skill_exchange/data/models/user_profile_model.dart';

class ReviewModel {
  final String id;
  final String fromUserId;
  final String toUserId;
  final int rating;
  final String comment;
  final List<String> skillsReviewed;
  final String? sessionId;
  final String createdAt;
  final String updatedAt;
  final UserProfileModel? fromUser;
  final UserProfileModel? toUser;

  const ReviewModel({
    this.id = '',
    this.fromUserId = '',
    this.toUserId = '',
    this.rating = 0,
    this.comment = '',
    this.skillsReviewed = const [],
    this.sessionId,
    this.createdAt = '',
    this.updatedAt = '',
    this.fromUser,
    this.toUser,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as String? ?? '',
      fromUserId: map['fromUserId'] as String? ?? '',
      toUserId: map['toUserId'] as String? ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment'] as String? ?? '',
      skillsReviewed: (map['skillsReviewed'] as List?)?.cast<String>() ?? [],
      sessionId: map['sessionId'] as String?,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
      fromUser: map['fromUser'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['fromUser'] as Map))
          : null,
      toUser: map['toUser'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['toUser'] as Map))
          : null,
    );
  }

  /// Legacy compatibility alias
  factory ReviewModel.fromJson(Map<String, dynamic> json) =
      ReviewModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'rating': rating,
        'comment': comment,
        'skillsReviewed': skillsReviewed,
        'sessionId': sessionId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  ReviewModel copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    int? rating,
    String? comment,
    List<String>? skillsReviewed,
    String? sessionId,
    String? createdAt,
    String? updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      skillsReviewed: skillsReviewed ?? this.skillsReviewed,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
    );
  }
}
