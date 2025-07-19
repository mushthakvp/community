import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/search_data.dart';
import '../repositories/search_repository.dart';

class GetSearchData implements UseCase<SearchData, NoParams> {
  final SearchRepository repository;

  GetSearchData(this.repository);

  @override
  Future<Either<Failure, SearchData>> call(NoParams params) async {
    return await repository.getSearchData();
  }
}
