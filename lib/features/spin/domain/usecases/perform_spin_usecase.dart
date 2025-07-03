import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/spin_result_entity.dart';
import '../repositories/spin_repository.dart';

class PerformSpinUseCase
    implements UseCase<SpinResultEntity, PerformSpinParams> {
  final SpinRepository repository;

  PerformSpinUseCase(this.repository);

  @override
  Future<Either<Failure, SpinResultEntity>> call(
    PerformSpinParams params,
  ) async {
    return await repository.performSpin(
      optionId: params.optionId,
      spinType: params.spinType,
      isUnlimited: params.isUnlimited,
    );
  }
}

class PerformSpinParams extends Equatable {
  final String optionId;
  final String spinType;
  final bool isUnlimited;

  const PerformSpinParams({
    required this.optionId,
    required this.spinType,
    this.isUnlimited = false,
  });

  @override
  List<Object?> get props => [optionId, spinType, isUnlimited];
}
