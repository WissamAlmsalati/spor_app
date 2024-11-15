import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utilits/responsive.dart';
import 'coustmo_switch_button.dart';
import 'package:shimmer/shimmer.dart';

class ProfileButton extends StatelessWidget {
  final String icon;
  final String? leadingIcon;
  final String text;
  final bool hasLeading;
  final VoidCallback? onSwitchToggle;
  final VoidCallback? onPressed;
  final double? fontsize;

  const ProfileButton({
    super.key,
    required this.icon,
    required this.text,
    this.hasLeading = false,
    this.leadingIcon,
    this.onSwitchToggle,
    required this.onPressed,
    this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: Responsive.screenWidth(context) * 0.03),
          Text(text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: fontsize,
                  )),
          if (hasLeading) ...[
            const Spacer(),
            IOSSwitchButton(onToggle: onSwitchToggle),
            SizedBox(width: Responsive.screenWidth(context) * 0.2),
          ],
        ],
      ),
    );
  }
}

class ShimmerProfileButton extends StatelessWidget {
  const ShimmerProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: Responsive.screenHeight(context) * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
