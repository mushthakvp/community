import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../core/network/api_client.dart';
import 'data/datasources/add_edit_remote_datasource.dart';
import 'data/repositories/add_edit_repository_impl.dart';
import 'domain/repositories/add_edit_repository.dart';
import 'domain/usecases/create_ad_usecase.dart';
import 'domain/usecases/get_cities_usecase.dart';
import 'domain/usecases/upload_images_usecase.dart';
import 'presentation/providers/add_edit_provider.dart';

class AddEditModule {
  static List<SingleChildWidget> providers = [
    // Data Sources
    ProxyProvider<ApiClient, AddEditRemoteDataSource>(
      update: (_, apiClient, __) =>
          AddEditRemoteDataSourceImpl(client: apiClient),
    ),

    // Repositories
    ProxyProvider<AddEditRemoteDataSource, AddEditRepository>(
      update: (_, remoteDataSource, __) =>
          AddEditRepositoryImpl(remoteDataSource: remoteDataSource),
    ),

    // Use Cases
    ProxyProvider<AddEditRepository, GetCitiesUseCase>(
      update: (_, repository, __) => GetCitiesUseCase(repository),
    ),

    ProxyProvider<AddEditRepository, CreateAdUseCase>(
      update: (_, repository, __) => CreateAdUseCase(repository),
    ),

    ProxyProvider<AddEditRepository, UploadImagesUseCase>(
      update: (_, repository, __) => UploadImagesUseCase(repository),
    ),

    // Providers
    ChangeNotifierProxyProvider3<
      GetCitiesUseCase,
      CreateAdUseCase,
      UploadImagesUseCase,
      AddEditProvider
    >(
      create: (context) => AddEditProvider(
        getCitiesUseCase: context.read<GetCitiesUseCase>(),
        createAdUseCase: context.read<CreateAdUseCase>(),
        uploadImagesUseCase: context.read<UploadImagesUseCase>(),
      ),
      update:
          (
            _,
            getCitiesUseCase,
            createAdUseCase,
            uploadImagesUseCase,
            previous,
          ) =>
              previous ??
              AddEditProvider(
                getCitiesUseCase: getCitiesUseCase,
                createAdUseCase: createAdUseCase,
                uploadImagesUseCase: uploadImagesUseCase,
              ),
    ),
  ];
}
