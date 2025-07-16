import 'dart:math';

import 'package:flutter/material.dart';

class VCartHelpers {
  static double calculateAspectRatio(double screenWidth, double screenHeight) {
    return (screenHeight / screenWidth) * 0.31;
  }

  static int calculateCrossAxisCount(double screenWidth, int itemsPerRow) {
    return itemsPerRow;
  }

  static double calculateChildAspectRatio(
    double screenWidth,
    double screenHeight, {
    double multiplier = 0.31,
  }) {
    return (screenHeight / screenWidth) * multiplier;
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  static String formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) return '${(number / 1000).toStringAsFixed(1)}K';
    return '${(number / 1000000).toStringAsFixed(1)}M';
  }

  static double calculateProductPrice(double price, double commission) {
    return price + commission;
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static Color getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final words = name.trim().split(' ');
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}
