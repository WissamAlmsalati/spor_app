import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final Color color;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.color = Colors.amber,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(starCount, (index) {
            return Icon(Icons.star_border, color: color, size: size);
          }),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(starCount, (index) {
            if (index < rating.floor()) {
              return Icon(Icons.star, color: color, size: size);
            } else if (index < rating) {
              return Icon(Icons.star_half, color: color, size: size);
            } else {
              return Container(width: size); // Empty container to maintain spacing
            }
          }),
        ),
      ],
    );
  }
}