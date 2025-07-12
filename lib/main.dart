import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app/app.dart';
import 'app/app_providers.dart';
import 'core/services/cloudinary_service.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  CloudinaryService().initialize();
  final providers = await AppProviders.getInitializedProviders();
  runApp(CommunityApp(providers: providers));
}

class CommunityApp extends StatelessWidget with FittorAppMixin {
  final List<SingleChildWidget> providers;

  const CommunityApp({super.key, required this.providers});

  @override
  Widget responsive(BuildContext context) {
    return MultiProvider(providers: providers, child: const App());
  }
}
