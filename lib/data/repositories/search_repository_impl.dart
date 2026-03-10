import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/search_result_model.dart';
import 'package:skill_exchange/data/sources/remote/search_remote_source.dart';
import 'package:skill_exchange/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteSource _remoteSource;

  SearchRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, SearchResultModel>> searchUsers(
    SearchFiltersModel filters, {
    int page = 1,
  }) async {
    try {
      final result = await _remoteSource.searchUsers(filters, page: page);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
