import 'package:get/get.dart';

import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
import '../../order_history/data/datasources/order_history_remote_datasource.dart';
import '../../order_history/data/repositories/order_history_repository_impl.dart';
import '../../order_history/domain/repositories/order_history_repository.dart';
import '../../order_history/domain/usecases/get_order_history.dart';
import '../../order_history/presentation/controllers/order_history_controller.dart';
import '../../order_history_details/data/datasources/order_details_remote_datasource.dart';
import '../../order_history_details/data/repositories/order_details_repository_impl.dart';
import '../../order_history_details/domain/repositories/order_details_repository.dart';
import '../../order_history_details/domain/usecases/get_order_details.dart';
import '../../order_history_details/domain/usecases/submit_review.dart';
import '../../order_history_details/presentation/controllers/order_details_controller.dart';

class VCartOrderHistoryDI {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
  static Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _initDataSources();
      await _initRepositories();
      await _initUseCases();
      await _initControllers();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize VCart Order History DI: $e');
    }
  }

  static Future<void> _initDataSources() async {
    Get.lazyPut<OrderHistoryRemoteDataSource>(
      () => OrderHistoryRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<OrderDetailsRemoteDataSource>(
      () => OrderDetailsRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
  }

  static Future<void> _initRepositories() async {
    Get.lazyPut<OrderHistoryRepository>(
      () => OrderHistoryRepositoryImpl(
        remoteDataSource: Get.find<OrderHistoryRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );
    Get.lazyPut<OrderDetailsRepository>(
      () => OrderDetailsRepositoryImpl(
        remoteDataSource: Get.find<OrderDetailsRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );
  }

  static Future<void> _initUseCases() async {
    Get.lazyPut<GetOrderHistory>(
      () => GetOrderHistory(Get.find<OrderHistoryRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetOrderDetails>(
      () => GetOrderDetails(Get.find<OrderDetailsRepository>()),
      fenix: true,
    );
    Get.lazyPut<SubmitReview>(
      () => SubmitReview(Get.find<OrderDetailsRepository>()),
      fenix: true,
    );
  }

  static Future<void> _initControllers() async {
    Get.lazyPut<VCartOrderHistoryController>(
      () => VCartOrderHistoryController(
        getOrderHistoryUseCase: Get.find<GetOrderHistory>(),
      ),
      fenix: true,
    );
    Get.lazyPut<VCartOrderDetailsController>(
      () => VCartOrderDetailsController(
        getOrderDetailsUseCase: Get.find<GetOrderDetails>(),
        submitReviewUseCase: Get.find<SubmitReview>(),
      ),
      fenix: true,
    );
  }

  static void reset() {
    _isInitialized = false;
  }

  static bool areAllDependenciesRegistered() {
    final dependencies = [
      OrderHistoryRemoteDataSource,
      OrderDetailsRemoteDataSource,
      OrderHistoryRepository,
      OrderDetailsRepository,
      GetOrderHistory,
      GetOrderDetails,
      SubmitReview,
      VCartOrderHistoryController,
      VCartOrderDetailsController,
    ];

    return dependencies.every((type) => Get.isRegistered(tag: type.toString()));
  }

  static Map<String, bool> getDependencyStatus() {
    return {
      'OrderHistoryRemoteDataSource':
          Get.isRegistered<OrderHistoryRemoteDataSource>(),
      'OrderDetailsRemoteDataSource':
          Get.isRegistered<OrderDetailsRemoteDataSource>(),
      'OrderHistoryRepository': Get.isRegistered<OrderHistoryRepository>(),
      'OrderDetailsRepository': Get.isRegistered<OrderDetailsRepository>(),
      'GetOrderHistory': Get.isRegistered<GetOrderHistory>(),
      'GetOrderDetails': Get.isRegistered<GetOrderDetails>(),
      'SubmitReview': Get.isRegistered<SubmitReview>(),
      'VCartOrderHistoryController':
          Get.isRegistered<VCartOrderHistoryController>(),
      'VCartOrderDetailsController':
          Get.isRegistered<VCartOrderDetailsController>(),
    };
  }
}
