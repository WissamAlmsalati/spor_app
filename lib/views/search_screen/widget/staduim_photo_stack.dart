import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../controller/add_to_favorit/favorite_mangment_cubit.dart';
import '../../../controller/fetch_favorite/fetch_favorite_cubit.dart';
import '../../../utilits/images.dart';

class StaduimPhotoStack extends StatelessWidget {
  final String StdPhoto;
  final int stdId;

  const StaduimPhotoStack(
      {super.key, required this.StdPhoto, required this.stdId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToFavoriteCubit, AddToFavoriteState>(
      listener: (context, state) {
        if (state is AdedToFavorite) {
          Fluttertoast.showToast(
            msg: 'Added to favorite successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
        } else if (state is AddToFavoriteError) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else if (state is RemovedFromFavorite) {
          Fluttertoast.showToast(
            msg: 'Removed from favorite successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
        }
      },
      child: Stack(
        children: [
          Container(
            height: Responsive.screenHeight(context) * 0.25,
            child: Image.network(
              StdPhoto,
              fit: BoxFit.fill,
              width: double.infinity,
              height: Responsive.screenHeight(context) * 0.23,
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
                    child: Padding(
                      padding: EdgeInsets.all(
                          Responsive.screenHeight(context) * 0.01),
                      child: SvgPicture.asset(AppPhotot.arrowBack,
                          height: Responsive.screenHeight(context) * 0.05),
                    )),
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
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AppPhotot.shareIco,
                          height: Responsive.screenHeight(context) * 0.05),
                    )),
              ),
            ),
          ),
          Positioned(
            top: Responsive.screenHeight(context) * 0.01,
            right: 0,
            child: BlocBuilder<AddToFavoriteCubit, AddToFavoriteState>(
              builder: (BuildContext context, state) {
                final isFavorite = state is AdedToFavorite;
                return IconButton(
                  onPressed: () {
                    if (isFavorite) {
                      context.read<AddToFavoriteCubit>().removeFromFavorite(stdId, context);
                    } else {
                      context.read<AddToFavoriteCubit>().addToFavorite(stdId, context);
                    }
                  },
                  icon: SizedBox(
                    height: Responsive.screenHeight(context) * 0.070,
                    width: Responsive.screenHeight(context) * 0.070,
                    child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            isFavorite ? AppPhotot.fillFav : AppPhotot.favoriteBg,
                            color: isFavorite ? Colors.red : Colors.black,
                            height: Responsive.screenHeight(context) * 0.05,
                          ),
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String generateCustomUrl(int stadiumId) {
    return 'https://66c1376bf0169fe9bd266060--sensational-paletas-ef1ee0.netlify.app//stadium/$stadiumId';
  }

  Future<void> _shareStadium(BuildContext context) async {
    const String stadiumName = 'Stadium Name'; // Replace with actual stadium name
    final String imageUrl = StdPhoto;
    final String customUrl = generateCustomUrl(stdId);

    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      final documentDirectory = (await getApplicationDocumentsDirectory()).path;
      final file = File('$documentDirectory/stadium_image.png');
      file.writeAsBytesSync(response.bodyBytes);

      // Share the image and custom URL
      final String shareText = 'Check out this stadium: $stadiumName\n$customUrl';
      Share.shareXFiles([XFile(file.path)], text: shareText);
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing stadium: $e');
      }
    }
  }
}