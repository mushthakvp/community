import 'package:get/get.dart';

import '../../challenge_details/data/datasources/challenge_details_remote_data_source.dart';
import '../../challenge_details/data/repositories/challenge_details_repository_impl.dart';
import '../../challenge_details/domain/repositories/challenge_details_repository.dart';
import '../../challenge_details/domain/usecases/get_challenge_details_usecase.dart';
import '../../challenge_details/domain/usecases/join_challenge_usecase.dart';

class ChallengeDetailsInjection {
  static void init() {
    Get.lazyPut<ChallengeDetailsRemoteDataSource>(
      () => ChallengeDetailsRemoteDataSourceImpl(apiClient: Get.find()),
    );
    Get.lazyPut<ChallengeDetailsRepository>(
      () => ChallengeDetailsRepositoryImpl(
        remoteDataSource: Get.find<ChallengeDetailsRemoteDataSource>(),
      ),
    );
    Get.lazyPut<GetChallengeDetailsUseCase>(
      () => GetChallengeDetailsUseCase(Get.find<ChallengeDetailsRepository>()),
    );
    Get.lazyPut<JoinChallengeUseCase>(
      () => JoinChallengeUseCase(Get.find<ChallengeDetailsRepository>()),
    );
  }
}
