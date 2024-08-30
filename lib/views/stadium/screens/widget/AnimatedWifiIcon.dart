import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utilits/images.dart';
import '../../../../utilits/responsive.dart';

class AnimatedWifiIcon extends StatelessWidget {
  const AnimatedWifiIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 2 * 3.14159),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      builder: (context, rotation, child) {
        return Transform.rotate(
          angle: rotation,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.8, end: 1.2),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: TweenAnimationBuilder<Offset>(
                  tween: Tween<Offset>(begin: const Offset(-0.1, 0.0), end: const Offset(0.1, 0.0)),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  builder: (context, offset, child) {
                    return Transform.translate(
                      offset: offset,
                      child: child,
                    );
                  },
                  child: SvgPicture.asset(
                    AppPhotot.wifiDisconnected,
                    height: Responsive.screenHeight(context) * 0.08,
                  ),
                ),
              );
            },
          ),
        );
      },
      onEnd: () {
        // Trigger a rebuild to loop the animation
        (context as Element).markNeedsBuild();
      },
    );
  }
}
