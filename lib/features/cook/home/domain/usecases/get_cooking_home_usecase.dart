import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/cooking_home.dart';
import '../repositories/home_repository.dart';

class GetCookingHomeUseCase
    implements UseCase<CookingHome, GetCookingHomeParams> {
  final HomeRepository repository;

  GetCookingHomeUseCase(this.repository);

  @override
  Future<Either<Failure, CookingHome>> call(GetCookingHomeParams params) async {
    return await repository.getCookingHome(
      search: params.search,
      currentPage: params.currentPage,
      currentLimit: params.currentLimit,
      upcomingPage: params.upcomingPage,
      upcomingLimit: params.upcomingLimit,
    );
  }
}

class GetCookingHomeParams extends Equatable {
  final String? search;
  final int currentPage;
  final int currentLimit;
  final int upcomingPage;
  final int upcomingLimit;

  const GetCookingHomeParams({
    this.search,
    this.currentPage = 1,
    this.currentLimit = 3,
    this.upcomingPage = 1,
    this.upcomingLimit = 10,
  });

  @override
  List<Object?> get props => [
    search,
    currentPage,
    currentLimit,
    upcomingPage,
    upcomingLimit,
  ];
}
