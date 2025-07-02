import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/product_detail_repository.dart';

class ReportProductParams {
  final String productId;
  final String reason;

  ReportProductParams({required this.productId, required this.reason});
}

class ReportProductUseCase implements UseCase<bool, ReportProductParams> {
  final ProductDetailRepository repository;

  ReportProductUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReportProductParams params) async {
    return await repository.reportProduct(params.productId, params.reason);
  }
}
