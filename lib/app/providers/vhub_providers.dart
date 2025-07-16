import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../features/vhub/data/repositories/vhub_repository_impl.dart';
import '../../features/vhub/domain/usecases/create_idea_usecase.dart';
import '../../features/vhub/domain/usecases/get_faqs_usecase.dart';
import '../../features/vhub/domain/usecases/get_ideas_usecase.dart';
import '../../features/vhub/presentation/providers/create_idea_provider.dart';
import '../../features/vhub/presentation/providers/vhub_provider.dart';

/// VHub business startup platform providers
class VHubProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // VHUB PROVIDERS
    // ========================================

    // VHub Repository
    ProxyProvider<ApiClient, VHubRepositoryImpl>(
      update: (_, apiClient, __) => VHubRepositoryImpl(apiClient: apiClient),
    ),

    // VHub Use Cases
    ProxyProvider<VHubRepositoryImpl, GetIdeasUseCase>(
      update: (_, repository, __) => GetIdeasUseCase(repository),
    ),
    ProxyProvider<VHubRepositoryImpl, CreateIdeaUseCase>(
      update: (_, repository, __) => CreateIdeaUseCase(repository),
    ),
    ProxyProvider<VHubRepositoryImpl, GetFaqsUseCase>(
      update: (_, repository, __) => GetFaqsUseCase(repository),
    ),

    // VHub Provider
    ChangeNotifierProxyProvider4<
      GetIdeasUseCase,
      CreateIdeaUseCase,
      GetFaqsUseCase,
      VHubRepositoryImpl,
      VHubProvider
    >(
      create: (context) => VHubProvider(
        getIdeasUseCase: context.read<GetIdeasUseCase>(),
        createIdeaUseCase: context.read<CreateIdeaUseCase>(),
        getFaqsUseCase: context.read<GetFaqsUseCase>(),
        repository: context.read<VHubRepositoryImpl>(),
      ),
      update:
          (
            _,
            getIdeasUseCase,
            createIdeaUseCase,
            getFaqsUseCase,
            repository,
            previous,
          ) =>
              previous ??
              VHubProvider(
                getIdeasUseCase: getIdeasUseCase,
                createIdeaUseCase: createIdeaUseCase,
                getFaqsUseCase: getFaqsUseCase,
                repository: repository,
              ),
    ),

    // Create Idea Provider
    ChangeNotifierProvider<CreateIdeaProvider>(
      create: (_) => CreateIdeaProvider(),
    ),
  ];
}
