import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class ResponsiveHelper {
  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getResponsive(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.001;
  }

  static double getResponsiveText(BuildContext context) {
    // Avoid using Platform on web
    if (kIsWeb) {
      return 1.0;
    } else if (Platform.isAndroid) {
      return 0.8;
    } else {
      return 0.9;
    }
  }

  // Screen breakpoints
  static bool isMobile(BuildContext context) {
    return getWidth(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return getWidth(context) >= 600 && getWidth(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return getWidth(context) >= 1200;
  }

  // Responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  // Responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.2;
    }
  }
}
