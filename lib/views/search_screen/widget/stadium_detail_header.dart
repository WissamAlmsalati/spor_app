import 'package:flutter/material.dart';
import 'package:sport/views/search_screen/widget/staduim_photo_stack.dart';

class StadiumDetailHeader extends StatelessWidget {
  final stadium;
  final int stadiumId;

  const StadiumDetailHeader({super.key, required this.stadium, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    return stadium.images.isNotEmpty && stadium.images[0].isNotEmpty
        ? StaduimPhotoStack(StdPhoto: stadium.images[0], stdId: stadiumId)
        : StaduimPhotoStack(StdPhoto: "https://placehold.co/600x400", stdId: stadiumId);
  }
}