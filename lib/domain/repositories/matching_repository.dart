import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/matching_filters_model.dart';
import 'package:skill_exchange/data/models/paginated_response_model.dart';

abstract class MatchingRepository {
  Future<Either<Failure, PaginatedResponseModel<MatchScoreModel>>> getMatches({
    MatchingFiltersModel? filters,
    String? sortBy,
    int page = 1,
    int pageSize = 20,
  });

  Future<Either<Failure, List<MatchScoreModel>>> getTopMatches(int limit);
}
