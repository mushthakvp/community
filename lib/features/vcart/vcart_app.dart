import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        getPages: VCartRouter.getPages(),
      ),
    );
  }
}
