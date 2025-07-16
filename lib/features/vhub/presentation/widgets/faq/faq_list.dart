import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/vhub_provider.dart';
import 'empty_faq_widget.dart';
import 'faq_item.dart';

class FaqList extends StatelessWidget {
  const FaqList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VHubProvider>(
      builder: (context, provider, child) {
        if (provider.faqs.isEmpty) {
          return const EmptyFaqWidget(
            message: 'No FAQs available at the moment',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.faqs.length,
          itemBuilder: (context, index) {
            final faq = provider.faqs[index];
            return FaqItem(faq: faq);
          },
        );
      },
    );
  }
}
