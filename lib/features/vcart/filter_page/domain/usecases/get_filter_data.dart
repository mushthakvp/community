import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/filter_data.dart';
import '../repositories/filter_page_repository.dart';

class GetFilterData implements UseCase<FilterData, GetFilterDataParams> {
  final FilterPageRepository repository;

  GetFilterData(this.repository);

  @override
  Future<Either<Failure, FilterData>> call(GetFilterDataParams params) async {
    return await repository.getFilterData(
      sectionId: params.sectionId,
      brandId: params.brandId,
    );
  }
}

class GetFilterDataParams {
  final String? sectionId;
  final String? brandId;

  const GetFilterDataParams({this.sectionId, this.brandId});
}
