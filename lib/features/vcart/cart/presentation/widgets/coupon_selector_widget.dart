import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/router/v_cart_router_g.dart';

class CouponSelectorWidget extends StatelessWidget {
  final Function(String) onCouponApplied;

  const CouponSelectorWidget({super.key, required this.onCouponApplied});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToCoupons(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VCartColors.surface.withOpacity(0.5),
          border: Border.all(
            color: VCartColors.border.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: VCartColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_offer_outlined,
                color: VCartColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Apply Coupon",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: VCartColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Save more on your order",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: VCartColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: VCartColors.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: VCartColors.textSecondary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCoupons(BuildContext context) {
    VCartRouterClassG.pushVCartCoupons<String>().then((result) {
      if (result != null) {
        onCouponApplied(result);
      }
    });
  }
}
