import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/discussion_post_model.dart';
import 'package:skill_exchange/data/models/leaderboard_entry_model.dart';
import 'package:skill_exchange/data/models/learning_circle_model.dart';

abstract class CommunityRepository {
  // Discussion Posts
  Future<Either<Failure, List<DiscussionPostModel>>> getPosts({int? page});
  Future<Either<Failure, DiscussionPostModel>> createPost(CreatePostDto dto);
  Future<Either<Failure, void>> likePost(String id);
  Future<Either<Failure, void>> unlikePost(String id);

  // Learning Circles
  Future<Either<Failure, List<LearningCircleModel>>> getCircles({int? page});
  Future<Either<Failure, LearningCircleModel>> createCircle(
    CreateCircleDto dto,
  );
  Future<Either<Failure, void>> joinCircle(String id);
  Future<Either<Failure, void>> leaveCircle(String id);

  // Leaderboard
  Future<Either<Failure, List<LeaderboardEntryModel>>> getLeaderboard({
    int? limit,
  });
}
