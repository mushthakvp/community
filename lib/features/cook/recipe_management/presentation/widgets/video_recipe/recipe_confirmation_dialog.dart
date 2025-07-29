import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecipeConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onPreview;

  const RecipeConfirmationDialog({
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
            _buildConfirmationIcon(),
            const SizedBox(height: 16),
            _buildTitle(),
            const SizedBox(height: 8),
            _buildSubtitle(),
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

  Widget _buildConfirmationIcon() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.amber.withOpacity(0.1),
      ),
      child: const Icon(Icons.restaurant_menu, size: 60, color: Colors.amber),
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

  Widget _buildSubtitle() {
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
          child: _buildButton(
            text: 'No',
            onPressed: () => Get.back(),
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            borderColor: Colors.amber,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildButton(
            text: 'Yes',
            onPressed: onConfirm,
            backgroundColor: Colors.amber,
            textColor: Colors.black,
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

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
