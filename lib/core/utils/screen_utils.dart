import 'package:flutter/widgets.dart';

class ScreenUtils {
  // Private constructor to prevent instance creation
  ScreenUtils._();

  static double? _screenWidth;
  static double? _screenHeight;

  // Initializes the screen properties, should be called once
  static void init(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  // Returns screen width as a percentage of the device width
  static double width(double percentage) {
    return _screenWidth! * (percentage / 100);
  }

  // Returns screen height as a percentage of the device height
  static double height(double percentage) {
    return _screenHeight! * (percentage / 100);
  }

  // Returns the screen width
  static double get screenWidth => _screenWidth!;

  // Returns the screen height
  static double get screenHeight => _screenHeight!;
}
