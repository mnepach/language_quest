import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_io/io.dart';
import '../constants/dimensions.dart';

class PlatformHelper {
  static bool get isWeb => kIsWeb;

  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isIOS => !kIsWeb && Platform.isIOS;

  // Responsive padding
  static double getResponsivePadding() {
    if (isWeb) return AppDimensions.spacingXxl;
    if (isMobile) return AppDimensions.spacingM;
    return AppDimensions.spacingL;
  }

  // Responsive card width
  static double getResponsiveCardWidth(double screenWidth) {
    if (isWeb) {
      if (screenWidth > AppDimensions.desktopMaxWidth) {
        return AppDimensions.cardWidth * 2;
      } else if (screenWidth > AppDimensions.tabletMaxWidth) {
        return screenWidth * 0.4;
      }
      return screenWidth * 0.5;
    }
    return screenWidth * 0.9;
  }

  // Grid cross axis count for responsive grid
  static int getGridCrossAxisCount(double screenWidth) {
    if (isWeb) {
      if (screenWidth > AppDimensions.desktopMaxWidth) return 4;
      if (screenWidth > AppDimensions.tabletMaxWidth) return 3;
      return 2;
    }
    if (screenWidth > AppDimensions.mobileMaxWidth) return 3;
    return 2;
  }

  // Check if screen is wide (tablet or desktop)
  static bool isWideScreen(double screenWidth) {
    return screenWidth > AppDimensions.mobileMaxWidth;
  }

  // Get max content width for web
  static double getMaxContentWidth(double screenWidth) {
    if (isWeb) {
      return screenWidth > AppDimensions.contentMaxWidth
          ? AppDimensions.contentMaxWidth
          : screenWidth * 0.9;
    }
    return screenWidth;
  }

  // Get responsive font size multiplier
  static double getFontSizeMultiplier() {
    if (isWeb) return 1.1;
    if (isMobile) return 1.0;
    return 1.05;
  }

  // Get responsive icon size
  static double getResponsiveIconSize({
    required double mobileSize,
    required double webSize,
  }) {
    return isWeb ? webSize : mobileSize;
  }

  static String getPlatformName() {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}
