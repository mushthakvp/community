import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/product_detail_repository.dart';

class AccessChatParams {
  final String friendId;
  final String postId;

  AccessChatParams({required this.friendId, required this.postId});
}

class AccessChatUseCase implements UseCase<String, AccessChatParams> {
  final ProductDetailRepository repository;

  AccessChatUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(AccessChatParams params) async {
    return await repository.accessChat(params.friendId, params.postId);
  }
}
