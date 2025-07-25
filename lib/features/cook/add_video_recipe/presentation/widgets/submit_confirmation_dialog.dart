import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onPreview;

  const SubmitConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xff191919),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 47, vertical: 21),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIllustration(),
            const SizedBox(height: 16),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildDescription(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 8),
            _buildOrText(),
            const SizedBox(height: 8),
            _buildPreviewButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.2),
            Colors.orange.withOpacity(0.2),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.restaurant_menu, size: 80, color: Colors.amber),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Confirm',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Are you sure want to submit?',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.amber),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'No',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Yes',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrText() {
    return const Text(
      'Or',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPreviewButton() {
    return GestureDetector(
      onTap: onPreview,
      child: const Text(
        'Preview',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.amber,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
