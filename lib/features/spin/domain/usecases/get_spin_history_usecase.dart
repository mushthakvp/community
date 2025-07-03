import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/spin_history_entity.dart';
import '../repositories/spin_repository.dart';

class GetSpinHistoryUseCase
    implements UseCase<List<SpinHistoryEntity>, SpinHistoryParams> {
  final SpinRepository repository;

  GetSpinHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<SpinHistoryEntity>>> call(
    SpinHistoryParams params,
  ) async {
    return await repository.getSpinHistory(
      page: params.page,
      limit: params.limit,
      spinType: params.spinType,
    );
  }
}

class SpinHistoryParams extends Equatable {
  final int page;
  final int limit;
  final String? spinType;

  const SpinHistoryParams({this.page = 1, this.limit = 10, this.spinType});

  @override
  List<Object?> get props => [page, limit, spinType];
}
