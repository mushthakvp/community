import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class MarkAsSoldUseCase implements UseCase<void, MarkAsSoldParams> {
  final ProfileRepository repository;

  MarkAsSoldUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsSoldParams params) async {
    return await repository.markAsSold(params.adId);
  }
}

class MarkAsSoldParams extends Equatable {
  final String adId;

  const MarkAsSoldParams({required this.adId});

  @override
  List<Object> get props => [adId];
}
