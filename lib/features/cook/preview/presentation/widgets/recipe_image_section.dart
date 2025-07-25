import 'package:flutter/material.dart';

class RecipeImageSection extends StatelessWidget {
  final String imageUrl;

  const RecipeImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 218,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[800],
        image: imageUrl.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl.isEmpty
          ? const Center(child: Icon(Icons.image, color: Colors.grey, size: 60))
          : null,
    );
  }
}
