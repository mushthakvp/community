import 'package:flutter/material.dart';

class PreviewLoadingView extends StatelessWidget {
  const PreviewLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(height: 60, color: Colors.black12),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 40, width: 200, color: Colors.black12),
                  const SizedBox(height: 20),
                  Container(height: 200, color: Colors.black12),
                  const SizedBox(height: 20),
                  Container(height: 100, color: Colors.black12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
