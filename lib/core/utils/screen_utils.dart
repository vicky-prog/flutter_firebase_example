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

  // Returns the device type (mobile, tablet, or web)
  static String get deviceType {
    if (_screenWidth! < 600) {
      return 'Mobile';
    } else if (_screenWidth! >= 600 && _screenWidth! < 1200) {
      return 'Tablet';
    } else {
      return 'Web';
    }
  }

  // Check if the device is mobile
  static bool get isMobile => _screenWidth! < 600;

  // Check if the device is tablet
  static bool get isTablet => _screenWidth! >= 600 && _screenWidth! < 1200;

  // Check if the device is web
  static bool get isWeb => _screenWidth! >= 1200;
}
