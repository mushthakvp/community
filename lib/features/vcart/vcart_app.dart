import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'categories/presentation/pages/categories_page.dart';
import 'core/bridge/vcart_provider_bridge.dart';
import 'home/presentation/pages/home_page.dart';
import 'navigation/presentation/pages/main_navigation_page.dart';
import 'product_overview/presentation/pages/product_overview_page.dart';

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
        getPages: _getPages(),
      ),
    );
  }

  List<GetPage> _getPages() {
    return [
      GetPage(name: '/home', page: () => const VCartHomePage()),
      GetPage(name: '/categories', page: () => const VCartCategoriesPage()),
      GetPage(name: '/cart', page: () => const VCartCartPage()),
      GetPage(name: '/profile', page: () => const VCartProfilePage()),
      GetPage(name: '/search', page: () => const VCartSearchPage()),
      GetPage(
        name: '/product/:id',
        page: () =>
            VCartProductOverviewPage(productId: Get.parameters['id'] ?? ''),
      ),
      GetPage(
        name: '/category',
        page: () => VCartCategoryPage(categoryId: Get.parameters['id'] ?? ''),
      ),
      GetPage(name: '/marketplace', page: () => const VCartMarketplacePage()),
    ];
  }
}

// Placeholder pages remain the same as in the original VCart app
class VCartCartPage extends StatelessWidget {
  const VCartCartPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('VCart Cart'),
      backgroundColor: const Color(0xFF000000),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: const Center(
      child: Text('VCart Cart Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: const Color(0xFF000000),
  );
}

class VCartProfilePage extends StatelessWidget {
  const VCartProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('VCart Profile'),
      backgroundColor: const Color(0xFF000000),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: const Center(
      child: Text('VCart Profile Page', style: TextStyle(color: Colors.white)),
    ),
    backgroundColor: const Color(0xFF000000),
  );
}

class VCartSearchPage extends StatelessWidget {
  const VCartSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final query = Get.parameters['q'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('VCart Search'),
        backgroundColor: const Color(0xFF000000),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'VCart Search Page',
              style: TextStyle(color: Colors.white),
            ),
            if (query.isNotEmpty)
              Text(
                'Searching for: $query',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF000000),
    );
  }
}

class VCartCategoryPage extends StatelessWidget {
  final String categoryId;
  const VCartCategoryPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('VCart Category'),
      backgroundColor: const Color(0xFF000000),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'VCart Category Page',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Category ID: $categoryId',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
    backgroundColor: const Color(0xFF000000),
  );
}

class VCartMarketplacePage extends StatelessWidget {
  const VCartMarketplacePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('VCart Marketplace'),
      backgroundColor: const Color(0xFF000000),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: const Center(
      child: Text(
        'VCart Marketplace Page',
        style: TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: const Color(0xFF000000),
  );
}
