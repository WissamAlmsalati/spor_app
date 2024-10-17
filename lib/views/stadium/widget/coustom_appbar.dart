import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sport/app/app_packges.dart';
import '../../../utilits/responsive.dart';
import 'package:shimmer/shimmer.dart';

import '../screens/widget/profile_appbar.dart';

class CoustomAppBr extends StatelessWidget {
  final String? logo;
  final String title;
  final Color? color;
  final double? height;
  final double? width;
  final VoidCallback? onPressed;
  final VoidCallback? onPressedFav;
  final Widget? child;
  final bool isLoading;
  final Widget? loadingWidget;
  final String? userName;
  final bool isHomeScreen;

  const CoustomAppBr({
    super.key,
    this.logo,
    required this.title,
    this.color,
    this.height,
    this.width,
    this.onPressed,
    this.child,
    this.isLoading = false,
    this.loadingWidget,
    this.userName,
    required this.isHomeScreen,
    this.onPressedFav,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: Responsive.screenWidth(context) * 0.4,
                  height: Responsive.screenHeight(context) * 0.03,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color),
                  ),
                  Text(
                    userName ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Constants.mainColor),
                  ),
                ],
              ),
        Row(
          children: [
            if (isHomeScreen)
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                  );
                },
                icon: SizedBox(
                  height: height,
                  width: width,
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.025),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.02),
                      child: SvgPicture.asset(
                        AppPhotot.favoriteBg,
                      ),
                    ),
                  ),
                ),
              ),
            if (logo != null)
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: onPressed,
                icon: SizedBox(
                  height: height,
                  width: width,
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.025),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.02),
                      child: SvgPicture.asset(
                        logo!,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}