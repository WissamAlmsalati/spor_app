import 'package:flutter/material.dart';
import 'package:sport/views/search_screen/widget/staduim_photo_stack.dart';

class StadiumDetailHeader extends StatelessWidget {
  final stadium;
  final int stadiumId;

  const StadiumDetailHeader({super.key, required this.stadium, required this.stadiumId});

  @override
  Widget build(BuildContext context) {

      //StaduimPhotoStack(stdPhotos: stadium.images, stdId: stadiumId);
    return stadium.images.isNotEmpty
        ? StaduimPhotoStack(stdPhotos: stadium.images, stdId: stadiumId)
        : StaduimPhotoStack(stdPhotos: ["https://interactive.guim.co.uk/atoms/thrashers/2022/03/moving-the-goalposts/assets/v/1718361372272/moving-the-goalposts-5-3.jpg"], stdId: stadiumId);
  }
}