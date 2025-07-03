import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/edit_ad_request_entity.dart';
import '../entities/edit_ad_response_entity.dart';
import '../repositories/edit_ad_repository.dart';

class EditAdUseCase implements UseCase<EditAdResponseEntity, EditAdParams> {
  final EditAdRepository repository;

  EditAdUseCase(this.repository);

  @override
  Future<Either<Failure, EditAdResponseEntity>> call(
    EditAdParams params,
  ) async {
    return await repository.editAd(params.request);
  }
}

class EditAdParams extends Equatable {
  final EditAdRequestEntity request;

  const EditAdParams({required this.request});

  @override
  List<Object> get props => [request];
}
