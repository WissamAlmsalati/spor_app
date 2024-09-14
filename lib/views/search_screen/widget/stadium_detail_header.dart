import 'package:flutter/material.dart';
import 'package:sport/views/search_screen/widget/staduim_photo_stack.dart';

class StadiumDetailHeader extends StatelessWidget {
  final stadium;
  final int stadiumId;

  const StadiumDetailHeader({super.key, required this.stadium, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    return stadium.images.isNotEmpty
        ? StaduimPhotoStack(stdPhotos: stadium.images, stdId: stadiumId)
        : StaduimPhotoStack(stdPhotos: ["https://placehold.co/600x400"], stdId: stadiumId);
  }
}