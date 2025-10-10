import 'package:get/get.dart';

import '../network/cook_api_client.dart';
import '../../challenge_details/data/datasources/challenge_details_remote_data_source.dart';
import '../../challenge_details/data/repositories/challenge_details_repository_impl.dart';
import '../../challenge_details/domain/repositories/challenge_details_repository.dart';
import '../../challenge_details/domain/usecases/get_challenge_details_usecase.dart';
import '../../challenge_details/domain/usecases/join_challenge_usecase.dart';

class ChallengeDetailsInjection {
  static void init() {
    // Data sources
    Get.lazyPut<ChallengeDetailsRemoteDataSource>(
      () => ChallengeDetailsRemoteDataSourceImpl(apiClient: Get.find<CookApiClient>()),
      tag: 'challenge_details',
    );
    Get.lazyPut<ChallengeDetailsRepository>(
      () => ChallengeDetailsRepositoryImpl(
        remoteDataSource: Get.find<ChallengeDetailsRemoteDataSource>(
          tag: 'challenge_details',
        ),
      ),
      tag: 'challenge_details',
    );
    Get.lazyPut<GetChallengeDetailsUseCase>(
      () => GetChallengeDetailsUseCase(
        Get.find<ChallengeDetailsRepository>(tag: 'challenge_details'),
      ),
      tag: 'challenge_details',
    );
    Get.lazyPut<JoinChallengeDetailsUseCase>(
      () => JoinChallengeDetailsUseCase(
        Get.find<ChallengeDetailsRepository>(tag: 'challenge_details'),
      ),
      tag: 'challenge_details_join',
    );
  }
}
