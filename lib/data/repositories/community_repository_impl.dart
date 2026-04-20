import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/discussion_post_model.dart';
import 'package:skill_exchange/data/models/leaderboard_entry_model.dart';
import 'package:skill_exchange/data/models/learning_circle_model.dart';
import 'package:skill_exchange/data/sources/remote/community_remote_source.dart';
import 'package:skill_exchange/domain/repositories/community_repository.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteSource _remoteSource;

  CommunityRepositoryImpl(this._remoteSource);

  // ── Discussion Posts ──────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<DiscussionPostModel>>> getPosts({
    int? page,
  }) async {
    try {
      final result = await _remoteSource.getPosts(
        params: page != null ? {'page': page} : null,
      );
      final items = result['posts'] as List? ?? [];
      return Right(
        items
            .map((e) => DiscussionPostModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DiscussionPostModel>> createPost(
    CreatePostDto dto,
  ) async {
    try {
      final result = await _remoteSource.createPost(dto.toJson());
      return Right(DiscussionPostModel.fromJson(result));
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> likePost(String id) async {
    try {
      await _remoteSource.likePost(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost(String id) async {
    try {
      await _remoteSource.unlikePost(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Learning Circles ──────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<LearningCircleModel>>> getCircles({
    int? page,
  }) async {
    try {
      final result = await _remoteSource.getCircles();
      return Right(
        result
            .map((e) => LearningCircleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LearningCircleModel>> createCircle(
    CreateCircleDto dto,
  ) async {
    try {
      final result = await _remoteSource.createCircle(dto.toJson());
      return Right(LearningCircleModel.fromJson(result));
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinCircle(String id) async {
    try {
      await _remoteSource.joinCircle(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveCircle(String id) async {
    try {
      await _remoteSource.leaveCircle(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ── Leaderboard ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<LeaderboardEntryModel>>> getLeaderboard({
    int? limit,
  }) async {
    try {
      final result = await _remoteSource.getLeaderboard(limit: limit ?? 10);
      return Right(
        result
            .map((e) =>
                LeaderboardEntryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
