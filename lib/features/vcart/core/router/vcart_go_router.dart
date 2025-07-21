import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../address/presentation/pages/address_form_page.dart';
import '../../address/presentation/pages/address_list_page.dart';
import '../../cart/domain/entities/cart_data.dart';
import '../../checkout/presentation/pages/checkout_page.dart';
import '../../checkout/presentation/pages/order_success_page.dart';

class VCartGoRouter {
  static GoRouter createRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/checkout',
          name: 'checkout',
          builder: (context, state) {
            final cartData = state.extra as CartData?;
            if (cartData == null) {
              return const Scaffold(
                body: Center(child: Text('Invalid cart data')),
              );
            }
            return VCartCheckoutPage(cartData: cartData);
          },
        ),
        GoRoute(
          path: '/address',
          name: 'address-list',
          builder: (context, state) => const VCartAddressListPage(),
          routes: [
            GoRoute(
              path: '/add',
              name: 'address-add',
              builder: (context, state) => const VCartAddressFormPage(),
            ),
            GoRoute(
              path: '/edit/:addressId',
              name: 'address-edit',
              builder: (context, state) {
                final addressId = state.pathParameters['addressId'];
                return VCartAddressFormPage(addressId: addressId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/order-success/:orderId',
          name: 'order-success',
          builder: (context, state) {
            final orderId = state.pathParameters['orderId'];
            return OrderSuccessPage(orderId: orderId ?? '');
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.uri.toString()}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
