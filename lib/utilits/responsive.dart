import 'dart:math';
import 'package:flutter/widgets.dart';

class Responsive {
  Responsive(BuildContext context);

  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }


  static double textSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 390) * size;
    return max(12, val);
  }
}


class ResponsiveInfo {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final double screenWidth;
  final double screenHeight;

  ResponsiveInfo({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.screenWidth,
    required this.screenHeight,
  });
}




class ResponsiveInfoProvider extends InheritedWidget {
  final ResponsiveInfo responsiveInfo;

  ResponsiveInfoProvider({
    required Widget child,
    required BuildContext context,
  })  : responsiveInfo = _getResponsiveInfo(context),
        super(child: child);

  static ResponsiveInfo _getResponsiveInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ResponsiveInfo(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      isMobile: screenWidth < 600,
      isTablet: screenWidth >= 600 && screenWidth < 900,
      isDesktop: screenWidth >= 900,
    );
  }

  static ResponsiveInfo of(BuildContext context) {
    final ResponsiveInfoProvider? provider =
    context.dependOnInheritedWidgetOfExactType<ResponsiveInfoProvider>();
    return provider!.responsiveInfo;
  }

  @override
  bool updateShouldNotify(covariant ResponsiveInfoProvider oldWidget) {
    return oldWidget.responsiveInfo != responsiveInfo;
  }
}
