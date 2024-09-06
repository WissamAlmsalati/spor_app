import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/app/app_packges.dart';
import '../../../controller/ads_controler/ads_photos_cubit.dart';
import '../../../utilits/responsive.dart';
import '../../../models/ads_photo_model.dart';

class AdsCarouselSlider extends StatefulWidget {
  @override
  _AdsCarouselSliderState createState() => _AdsCarouselSliderState();
}

class _AdsCarouselSliderState extends State<AdsCarouselSlider> {
  final ValueNotifier<int> _current = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    context.read<FetchAdsImagesCubit>().fetchAdsImages();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchAdsImagesCubit, AdsImagesState>(
      builder: (context, state) {
        if (state is AdsImagesLoading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.only(
                top: Responsive.screenHeight(context) * 0.02,
              ),
              height: Responsive.screenHeight(context) * 0.17,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        } else if (state is AdsImagesLoaded) {
          return Column(
            children: [
              CarouselSlider(
                items: state.adsImages.map((ad) {
                  return Container(
                    margin: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.02,
                    ),
                    height: Responsive.screenHeight(context) * 0.17,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: ad.image.isNotEmpty
                            ? NetworkImage(ad.image)
                            : AssetImage('assets/photos/Frame 4.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: Responsive.screenHeight(context) * 0.2,
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
              ValueListenableBuilder<int>(
                valueListenable: _current,
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(state.adsImages.length, (index) {
                      return Container(
                        width: Responsive.screenWidth(context) * 0.04,
                        height: Responsive.screenHeight(context) * 0.01,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.01),
                          shape: BoxShape.rectangle,
                          color: value == index
                              ? Constants.mainColor
                              : Constants.mainColor.withOpacity(0.3)
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          );
        } else if (state is AdsImagesError) {
          return Center(
            child: Container(
              height: Responsive.screenHeight(context) * 0.08,
              width: Responsive.screenWidth(context) * 0.04,
              decoration: BoxDecoration(color: Colors.grey),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}