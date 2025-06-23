import 'package:flutter/material.dart';

class Responsive {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double text = 0;
  static double radius = 0;
  static double height = 0;
  static double width = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    isPortrait = orientation == Orientation.portrait;
    _screenWidth = isPortrait ? constraints.maxWidth : constraints.maxHeight;
    _screenHeight = isPortrait ? constraints.maxHeight : constraints.maxWidth;

    isMobilePortrait = isPortrait && _screenWidth < 450;

    double blockSizeHorizontal = _screenWidth / 100;
    double blockSizeVertical = _screenHeight / 100;

    text = blockSizeVertical;
    radius = blockSizeHorizontal;
    height = blockSizeVertical;
    width = blockSizeHorizontal;
  }
}
/* RESPONSIVE SIZE */

extension ListExtension<T> on List<T>? {
  bool isListNullOrEmpty() => this == null || this!.isEmpty;
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension IntExtension on int? {
  int getOrZero() => this ?? 0;
}

extension StringExtensionCapitalize on String {
  String capitalizeFirstLetter() =>
      isNotEmpty ? this[0].toUpperCase() + substring(1) : this;
}
