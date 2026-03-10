import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/create_review_dto.dart';
import 'package:skill_exchange/data/models/review_model.dart';
import 'package:skill_exchange/data/models/review_stats_model.dart';
import 'package:skill_exchange/data/sources/remote/review_remote_source.dart';
import 'package:skill_exchange/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteSource _remoteSource;

  ReviewRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, List<ReviewModel>>> getReviews(String userId) async {
    try {
      final result = await _remoteSource.getReviews(userId);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewStatsModel>> getReviewStats(
    String userId,
  ) async {
    try {
      final result = await _remoteSource.getReviewStats(userId);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> createReview(
    CreateReviewDto dto,
  ) async {
    try {
      final result = await _remoteSource.createReview(dto);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
