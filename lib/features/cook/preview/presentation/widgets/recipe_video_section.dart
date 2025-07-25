import 'package:flutter/material.dart';

class RecipeVideoSection extends StatelessWidget {
  final String videoUrl;

  const RecipeVideoSection({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[800],
      ),
      child: videoUrl.isNotEmpty
          ? Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Video Player Placeholder',
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_off, color: Colors.grey, size: 60),
                  SizedBox(height: 8),
                  Text(
                    'No video available',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
