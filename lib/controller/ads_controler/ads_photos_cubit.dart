import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../models/ads_photo_model.dart';
import '../../services/apis.dart';

part 'ads_photos_state.dart';

class AdsPhotosCubit extends Cubit<AdsPhotosState> {
  AdsPhotosCubit() : super(AdsPhotosInitial());

  Future<void> fetchAdsPhotos() async {
    emit(AdsPhotosLoading());

    try {
      final response = await http.get(
        Uri.parse(Apis.AdsPhotos),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<AdsPhoto> adsPhotos = responseData.map((data) => AdsPhoto.fromJson(data)).toList();
        emit(AdsPhotosLoaded(adsPhotos));
      } else {
        print('Failed to load ads photos: ${response.reasonPhrase}');
        emit(AdsPhotosError('Failed to load ads photos: ${response.reasonPhrase}'));
      }
    } catch (e) {
      print('An error occurred: $e');
      emit(AdsPhotosError('An error occurred: $e'));
    }
  }
}