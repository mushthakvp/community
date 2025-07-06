import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
import '../../features/vjob/home/data/datasources/vjob_home_local_datasource.dart';
import '../../features/vjob/home/data/datasources/vjob_home_remote_datasource.dart';
import '../../features/vjob/home/data/repositories/vjob_home_repository_impl.dart';
import '../../features/vjob/home/domain/repositories/vjob_home_repository.dart';
import '../../features/vjob/home/domain/usecases/get_jobs_usecase.dart';
import '../../features/vjob/home/domain/usecases/get_posts_usecase.dart';
import '../../features/vjob/home/domain/usecases/like_post_usecase.dart';
import '../../features/vjob/home/domain/usecases/save_job_usecase.dart';
import '../../features/vjob/home/presentation/providers/jobs_provider.dart';
import '../../features/vjob/home/presentation/providers/posts_provider.dart';

/// VJob feature providers for job portal functionality
class VJobProviders {
  static List<SingleChildWidget> get providers => [
    // Data Sources
    Provider<VJobHomeRemoteDataSource>(
      create: (context) =>
          VJobHomeRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),
    Provider<VJobHomeLocalDataSource>(
      create: (context) => VJobHomeLocalDataSourceImpl(),
    ),

    // Repository
    Provider<VJobHomeRepository>(
      create: (context) => VJobHomeRepositoryImpl(
        remoteDataSource: context.read<VJobHomeRemoteDataSource>(),
        localDataSource: context.read<VJobHomeLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),

    // Use Cases
    Provider<GetJobsUseCase>(
      create: (context) => GetJobsUseCase(context.read<VJobHomeRepository>()),
    ),
    Provider<GetPostsUseCase>(
      create: (context) => GetPostsUseCase(context.read<VJobHomeRepository>()),
    ),
    Provider<SaveJobUseCase>(
      create: (context) => SaveJobUseCase(context.read<VJobHomeRepository>()),
    ),
    Provider<LikePostUseCase>(
      create: (context) => LikePostUseCase(context.read<VJobHomeRepository>()),
    ),

    // Providers
    ChangeNotifierProvider<JobsProvider>(
      create: (context) => JobsProvider(
        getJobsUseCase: context.read<GetJobsUseCase>(),
        saveJobUseCase: context.read<SaveJobUseCase>(),
      ),
    ),
    ChangeNotifierProvider<PostsProvider>(
      create: (context) => PostsProvider(
        getPostsUseCase: context.read<GetPostsUseCase>(),
        likePostUseCase: context.read<LikePostUseCase>(),
      ),
    ),
  ];
}
