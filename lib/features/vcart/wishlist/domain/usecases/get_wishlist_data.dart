import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/wishlist_data.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistData implements UseCase<WishlistData, GetWishlistParams> {
  final WishlistRepository repository;

  GetWishlistData(this.repository);

  @override
  Future<Either<Failure, WishlistData>> call(GetWishlistParams params) async {
    return await repository.getWishlistData(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetWishlistParams {
  final int page;
  final int limit;
  final bool isLoadMore;

  const GetWishlistParams({
    this.page = 1,
    this.limit = 10,
    this.isLoadMore = false,
  });
}
