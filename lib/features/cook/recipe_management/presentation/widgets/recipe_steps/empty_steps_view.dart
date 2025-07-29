import 'package:flutter/material.dart';

class EmptyStepsView extends StatelessWidget {
  final VoidCallback onAddStep;

  const EmptyStepsView({super.key, required this.onAddStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Spacer(),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'No steps added yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onAddStep,
                child: const Text(
                  'Add a step',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
