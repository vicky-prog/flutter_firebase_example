import 'package:flutter/widgets.dart';

class ScreenUtils {
  // Private constructor to prevent instance creation
  ScreenUtils._();

 

  // Returns screen width as a percentage of the device width
  static double width({required double percentage, required BuildContext context }) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  // Returns screen height as a percentage of the device height
  static double height({required double percentage, required BuildContext context}) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }


  // Check if the device is mobile
  static bool  isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;

  // Check if the device is tablet
  static bool  isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;

  // Check if the device is web
  static bool  isWeb(BuildContext context) =>  MediaQuery.of(context).size.width >= 1200;
}
