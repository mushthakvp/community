import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class DeleteAdUseCase implements UseCase<void, DeleteAdParams> {
  final ProfileRepository repository;

  DeleteAdUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAdParams params) async {
    return await repository.deleteAd(params.adId);
  }
}

class DeleteAdParams extends Equatable {
  final String adId;

  const DeleteAdParams({required this.adId});

  @override
  List<Object> get props => [adId];
}
