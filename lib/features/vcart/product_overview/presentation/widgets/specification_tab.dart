import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../controllers/product_overview_controller.dart';

class SpecificationTab extends StatelessWidget {
  final VCartProductOverviewController controller;

  const SpecificationTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final specifications = controller.productDetail?.specifications ?? [];

    if (specifications.isEmpty) {
      return const Center(
        child: Text(
          'No specifications available',
          style: TextStyle(color: VCartColors.textSecondary, fontSize: 14),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: specifications.length,
      itemBuilder: (context, index) {
        final spec = specifications[index];
        return _SpecificationItem(
          title: spec.title,
          data: spec.solution,
          index: index,
        );
      },
    );
  }
}

class _SpecificationItem extends StatelessWidget {
  final String title;
  final String data;
  final int index;

  const _SpecificationItem({
    required this.title,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: index % 2 == 0
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: VCartColors.textSecondary,
            ),
          ),
          Text(
            data,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: VCartColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
