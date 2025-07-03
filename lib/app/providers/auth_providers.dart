import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Authentication related providers
class AuthProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // AUTHENTICATION PROVIDERS
    // ========================================

    // Auth Repository & Provider
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(
        repository: AuthRepositoryImpl(apiClient: context.read<ApiClient>()),
      ),
    ),
  ];
}
