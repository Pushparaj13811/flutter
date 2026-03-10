import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/search_result_model.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResultModel>> searchUsers(
    SearchFiltersModel filters, {
    int page,
  });
}
