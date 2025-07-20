import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart/presentation/pages/cart_page.dart';
import 'categories/presentation/pages/categories_page.dart';
import 'core/bridge/vcart_provider_bridge.dart';
import 'core/router/vcart_router.dart';
import 'home/presentation/pages/home_page.dart';
import 'navigation/presentation/pages/main_navigation_page.dart';
import 'profile/presentation/pages/profile_page.dart';

class VCartApp extends StatelessWidget {
  const VCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VCartProviderBridge(
      child: GetMaterialApp(
        title: 'VCart',
        debugShowCheckedModeBanner: false,
        home: const VCartMainNavigationPage(
          pages: [
            VCartHomePage(),
            VCartCategoriesPage(),
            VCartCartPage(),
            VCartProfilePage(),
          ],
        ),
        getPages: VCartRouterG.getPages(),
        navigatorObservers: [VCartRouterG.observer],
        onGenerateRoute: (settings) {
          debugPrint('🛣️ VCart: Generate route for ${settings.name}');
          return null;
        },
        unknownRoute: GetPage(
          name: '/unknown',
          page: () => const VCartMainNavigationPage(
            pages: [
              VCartHomePage(),
              VCartCategoriesPage(),
              VCartCartPage(),
              VCartProfilePage(),
            ],
          ),
        ),
        enableLog: true,
        logWriterCallback: (text, {bool isError = false}) {
          if (text.contains('ROUTE') ||
              text.contains('GOING') ||
              text.contains('CLOSE')) {
            debugPrint('🛣️ GetX Route: $text');
          }
        },
      ),
    );
  }
}
