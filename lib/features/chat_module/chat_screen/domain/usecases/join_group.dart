import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class JoinGroup implements UseCase<void, JoinGroupParams> {
  final ChatRepository repository;

  JoinGroup(this.repository);

  @override
  Future<Either<Failure, void>> call(JoinGroupParams params) async {
    return await repository.joinGroup(params.chatId);
  }
}

class JoinGroupParams {
  final String chatId;

  JoinGroupParams({required this.chatId});
}
