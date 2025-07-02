import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../providers/product_detail_provider.dart';

class ReportProductPage extends StatefulWidget {
  final String productId;
  final String productTitle;

  const ReportProductPage({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  @override
  State<ReportProductPage> createState() => _ReportProductPageState();
}

class _ReportProductPageState extends State<ReportProductPage> {
  final TextEditingController _reasonController = TextEditingController();
  final List<String> _reportOptions = [
    'Spam',
    'Fraud',
    'Inappropriate Content',
    'Misleading Information',
    'Copyright Violation',
    'Other',
  ];
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Report ${widget.productTitle}',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Why are you reporting this listing?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Report Options
            Expanded(
              child: ListView.builder(
                itemCount: _reportOptions.length,
                itemBuilder: (context, index) {
                  final option = _reportOptions[index];
                  return RadioListTile<String>(
                    title: Text(
                      option,
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: option,
                    groupValue: _selectedOption,
                    activeColor: AppConstants.appPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                      });
                    },
                  );
                },
              ),
            ),

            // Additional Details
            if (_selectedOption != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Additional details (optional)',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Please provide more details...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppConstants.appPrimaryColor,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Submit Button
            Consumer<ProductDetailProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _selectedOption != null && !provider.isReportLoading
                        ? () => _submitReport(provider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.appPrimaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: provider.isReportLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'Submit Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitReport(ProductDetailProvider provider) async {
    final reason = _selectedOption!;
    final additionalDetails = _reasonController.text.trim();
    final fullReason = additionalDetails.isNotEmpty
        ? '$reason: $additionalDetails'
        : reason;

    await provider.reportProduct(fullReason);

    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
