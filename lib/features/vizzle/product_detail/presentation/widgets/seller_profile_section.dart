import 'package:flutter/material.dart';

import '../../../../../core/widgets/common/image_widget.dart';
import '../../domain/entities/product_detail.dart';

class SellerProfileSection extends StatelessWidget {
  final ProductUser user;
  final String sellerType;

  const SellerProfileSection({
    super.key,
    required this.user,
    required this.sellerType,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // context.go('/seller-details?sellerId=${user.id}');
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            CommonImageWidget(
              imageUrl: user.profileImage,
              width: 50,
              height: 50,
              borderRadius: BorderRadius.circular(25),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sellerType,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
