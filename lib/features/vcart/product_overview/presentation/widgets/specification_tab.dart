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

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: specifications.length,
      separatorBuilder: (context, index) =>
          const Divider(color: VCartColors.border, height: 1),
      itemBuilder: (context, index) {
        final spec = specifications[index];
        return _SpecificationItem(title: spec.title, data: spec.solution);
      },
    );
  }
}

class _SpecificationItem extends StatelessWidget {
  final String title;
  final String data;

  const _SpecificationItem({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: VCartColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              data,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: VCartColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
