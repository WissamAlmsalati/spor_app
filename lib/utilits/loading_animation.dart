import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sport/utilits/constants.dart';

class LoadingAnimation extends StatelessWidget {
  double size;
  Color? color;
  LoadingAnimation({super.key, required this.size,this.color});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color:color ?? Constants.mainColor,
      size:size,
    );
  }
}
