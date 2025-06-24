// lib/core/utils/extensions.dart
import 'package:flutter/material.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;

  String capitalizeFirstLetter() {
    if (isNullOrEmpty) return '';
    return this![0].toUpperCase() + this!.substring(1).toLowerCase();
  }

  String capitalizeWords() {
    if (isNullOrEmpty) return '';
    return this!
        .split(' ')
        .map((word) => word.capitalizeFirstLetter())
        .join(' ');
  }

  bool isValidEmail() {
    if (isNullOrEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this!);
  }

  bool isValidPhone() {
    if (isNullOrEmpty) return false;
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(this!);
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return toFormattedString();
    }
  }
}

extension ContextExtensions on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
