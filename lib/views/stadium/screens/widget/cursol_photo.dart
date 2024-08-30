import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sport/utilits/constants.dart';
import '../../../../utilits/responsive.dart';

class CarouselPhoto extends StatelessWidget {
  final CarouselSliderController _controller = CarouselSliderController();
  final ValueNotifier<int> _current = ValueNotifier<int>(0);

  CarouselPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      "assets/photos/Frame 4.png",
      "assets/photos/Frame 4.png"
    ];

    return Column(
      children: [
        CarouselSlider(
          items: images.map((imagePath) {
            return Container(
              margin: EdgeInsets.only(
                top: Responsive.screenHeight(context) * 0.02,
              ),
              height: Responsive.screenHeight(context) * 0.17,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            height: Responsive.screenHeight(context) * 0.18,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              _current.value = index;
            },
          ),
        ),
        SizedBox(
          height: Responsive.screenHeight(context) * 0.01,
        ),

        ValueListenableBuilder<int>(
          valueListenable: _current,
          builder: (context, currentIndex, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.jumpToPage(entry.key),
                  child: Container(
                    width: Responsive.screenWidth(context) * 0.045,
                    height: Responsive.screenWidth(context) * 0.027,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.01),
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Constants.txtColor
                              : Constants.mainColor)
                          .withOpacity(currentIndex == entry.key ? 1 : 0.3),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}