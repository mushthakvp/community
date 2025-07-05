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
  await _initializeServices();
  runApp(const CommunityApp());
}

Future<void> _initializeServices() async {
  await StorageService.init();
  CloudinaryService().initialize();
}

class CommunityApp extends StatelessWidget with FittorAppMixin {
  const CommunityApp({super.key});

  @override
  Widget responsive(BuildContext context) {
    return FutureBuilder<List<SingleChildWidget>>(
      future: AppProviders.getInitializedProviders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(providers: snapshot.data!, child: const App());
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing app: ${snapshot.error}'),
              ),
            ),
          );
        } else {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}
