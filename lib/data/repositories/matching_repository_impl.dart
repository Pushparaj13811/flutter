import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/matching_filters_model.dart';
import 'package:skill_exchange/data/models/paginated_response_model.dart';
import 'package:skill_exchange/data/sources/remote/matching_remote_source.dart';
import 'package:skill_exchange/domain/repositories/matching_repository.dart';

class MatchingRepositoryImpl implements MatchingRepository {
  final MatchingRemoteSource _remoteSource;

  MatchingRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, PaginatedResponseModel<MatchScoreModel>>> getMatches({
    MatchingFiltersModel? filters,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await _remoteSource.getMatches(
        filters: filters,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MatchScoreModel>>> getTopMatches(
    int limit,
  ) async {
    try {
      final result = await _remoteSource.getTopMatches(limit);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
