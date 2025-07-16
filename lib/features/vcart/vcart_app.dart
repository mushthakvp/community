import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/bindings/vcart_bindings.dart';
import 'home/presentation/pages/home_page.dart';
import 'navigation/presentation/pages/main_navigation_page.dart';

class VCartApp extends StatelessWidget {
  const VCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VCart',
      debugShowCheckedModeBanner: false,
      initialBinding: VCartBindings(),
      home: const VCartMainNavigationPage(
        pages: [
          VCartHomePage(),
          VCartCategoriesPage(),
          VCartCartPage(),
          VCartProfilePage(),
        ],
      ),
      getPages: _getPages(),
    );
  }

  List<GetPage> _getPages() {
    return [
      GetPage(
        name: '/home',
        page: () => const VCartHomePage(),
        binding: VCartBindings(),
      ),
      GetPage(
        name: '/categories',
        page: () => const VCartCategoriesPage(),
        binding: VCartBindings(),
      ),
      GetPage(
        name: '/cart',
        page: () => const VCartCartPage(),
        binding: VCartBindings(),
      ),
      GetPage(
        name: '/profile',
        page: () => const VCartProfilePage(),
        binding: VCartBindings(),
      ),
      GetPage(
        name: '/search',
        page: () => const VCartSearchPage(),
        binding: VCartBindings(),
      ),
      GetPage(
        name: '/product/:id',
        page: () => const VCartProductDetailPage(),
        binding: VCartBindings(),
      ),
      GetPage(
        name: '/category',
        page: () => const VCartCategoryPage(),
        binding: VCartBindings(),
      ),
      GetPage(
        name: '/marketplace',
        page: () => const VCartMarketplacePage(),
        binding: VCartBindings(),
      ),
    ];
  }
}

class VCartCategoriesPage extends StatelessWidget {
  const VCartCategoriesPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Text('Categories Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: Color(0xFF000000),
  );
}

class VCartCartPage extends StatelessWidget {
  const VCartCartPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Text('Cart Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: Color(0xFF000000),
  );
}

class VCartProfilePage extends StatelessWidget {
  const VCartProfilePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Text('Profile Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: Color(0xFF000000),
  );
}

class VCartSearchPage extends StatelessWidget {
  const VCartSearchPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Text('Search Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: Color(0xFF000000),
  );
}

class VCartProductDetailPage extends StatelessWidget {
  const VCartProductDetailPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Text('Product Detail Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: Color(0xFF000000),
  );
}

class VCartCategoryPage extends StatelessWidget {
  const VCartCategoryPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Text('Category Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: Color(0xFF000000),
  );
}

class VCartMarketplacePage extends StatelessWidget {
  const VCartMarketplacePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Text('Marketplace Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: Color(0xFF000000),
  );
}
