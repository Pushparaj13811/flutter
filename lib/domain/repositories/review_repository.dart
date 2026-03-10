import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/create_review_dto.dart';
import 'package:skill_exchange/data/models/review_model.dart';
import 'package:skill_exchange/data/models/review_stats_model.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ReviewModel>>> getReviews(String userId);
  Future<Either<Failure, ReviewStatsModel>> getReviewStats(String userId);
  Future<Either<Failure, ReviewModel>> createReview(CreateReviewDto dto);
}
