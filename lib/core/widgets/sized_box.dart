import 'package:flutter/material.dart';

class SizeBoxH extends StatelessWidget {
  final double height;
  const SizeBoxH(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class SizeBoxV extends StatelessWidget {
  final double width;
  const SizeBoxV(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
