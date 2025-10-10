import 'package:flutter/material.dart';

class Responsive {
  static MediaQueryData? _mediaQueryData;
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double _safeAreaHorizontal = 0;
  static double _safeAreaVertical = 0;
  static double _safeBlockHorizontal = 0;
  static double _safeBlockVertical = 0;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData!.size.width;
    _screenHeight = _mediaQueryData!.size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical = _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;
  }

  static double get width => _screenWidth;
  static double get height => _screenHeight;
  static double get blockSizeHorizontal => _blockSizeHorizontal;
  static double get blockSizeVertical => _blockSizeVertical;
  static double get safeBlockHorizontal => _safeBlockHorizontal;
  static double get safeBlockVertical => _safeBlockVertical;
}
