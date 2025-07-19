import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/section.dart';
import '../repositories/categories_repository.dart';

class GetSections implements UseCase<List<Section>, GetSectionsParams> {
  final CategoriesRepository repository;

  GetSections(this.repository);

  @override
  Future<Either<Failure, List<Section>>> call(GetSectionsParams params) async {
    return await repository.getSections(page: params.page, limit: params.limit);
  }
}

class GetSectionsParams {
  final int page;
  final int limit;

  const GetSectionsParams({this.page = 1, this.limit = 1000});
}
