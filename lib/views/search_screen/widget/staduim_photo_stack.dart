import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import '../../../controller/add_to_favorit/favorite_mangment_cubit.dart';
import '../../../controller/fetch_favorite/fetch_favorite_cubit.dart';
import '../../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import '../../../utilits/images.dart';

class StaduimPhotoStack extends StatelessWidget {
  final List<String> stdPhotos;
  final int stdId;
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  StaduimPhotoStack({super.key, required this.stdPhotos, required this.stdId});

  Future<String> generateSecureLink(int stadiumId) async {
    final response = await http.post(
      Uri.parse('https://your-backend-api.com/generateLink'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'stadiumId': stadiumId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['link'];
    } else {
      throw Exception('Failed to generate link');
    }
  }

  Future<void> _shareStadium(BuildContext context) async {
    try {
      final String deepLink = 'https://api.sport.com.ly/player/stadium-info?stadium_id=$stdId';
      await Share.share('Check out this stadium: $deepLink');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error sharing stadium link.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddToFavoriteCubit, AddToFavoriteState>(
          listener: (context, state) {
            if (state is AddToFavoriteError) {
              Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
              );
            }
          },
        ),
      ],
      child: Stack(
        children: [
          SizedBox(
            height: Responsive.screenHeight(context) * 0.25,
            child: PageView.builder(
              itemCount: stdPhotos.length,
              onPageChanged: (index) {
                _currentPageNotifier.value = index;
              },
              itemBuilder: (context, index) {
                return Image.network(
                  stdPhotos[index],
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: Responsive.screenHeight(context) * 0.23,
                );
              },
            ),
          ),
          Positioned(
            top: Responsive.screenHeight(context) * 0.01,
            left: 0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SizedBox(
                height: Responsive.screenHeight(context) * 0.070,
                width: Responsive.screenHeight(context) * 0.070,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Responsive.screenHeight(context) * 0.01),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Responsive.screenHeight(context) * 0.01),
                    child: SvgPicture.asset(AppPhotot.arrowBack, height: Responsive.screenHeight(context) * 0.05),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: Responsive.screenHeight(context) * 0.01,
            right: Responsive.screenWidth(context) * 0.15,
            child: IconButton(
              onPressed: () {
                _shareStadium(context);
              },
              icon: SizedBox(
                height: Responsive.screenHeight(context) * 0.070,
                width: Responsive.screenHeight(context) * 0.070,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Responsive.screenHeight(context) * 0.01),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(Responsive.screenHeight(context) * 0.01),
                    child: SvgPicture.asset(AppPhotot.shareIco, height: Responsive.screenHeight(context) * 0.05),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: Responsive.screenHeight(context) * 0.01,
            right: 0,
            child: BlocBuilder<StadiumDetailCubit, StaduimDetailState>(
              builder: (BuildContext context, StaduimDetailState state) {
                final bool isFavorite = (state is StaduimDetailLoaded && state.isFavorite) || (state is StaduimDetailLoadedEmptySession && state.isFavorite);
                return IconButton(
                  onPressed: () {
                    if (state is StaduimDetailLoaded || state is StaduimDetailLoadedEmptySession) {
                      context.read<StadiumDetailCubit>().toggleFavoriteStatus();
                      if (isFavorite) {
                        context.read<AddToFavoriteCubit>().removeFromFavorite(stdId, context);
                      } else {
                        context.read<AddToFavoriteCubit>().addToFavorite(stdId, context);
                      }
                    }
                  },
                  icon: SizedBox(
                    height: Responsive.screenHeight(context) * 0.070,
                    width: Responsive.screenHeight(context) * 0.070,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Responsive.screenHeight(context) * 0.01),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          isFavorite ? AppPhotot.fillFav : AppPhotot.favoriteBg,
                          color: isFavorite ? Colors.red : Colors.black,
                          height: Responsive.screenHeight(context) * 0.05,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: Responsive.screenHeight(context) * 0.01,
            right: Responsive.screenWidth(context) * 0.05,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPageNotifier,
              builder: (context, currentPage, child) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '${currentPage + 1} / ${stdPhotos.length}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}