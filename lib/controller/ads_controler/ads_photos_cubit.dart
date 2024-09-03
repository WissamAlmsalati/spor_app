import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../models/ads_photo_model.dart';
import '../../services/apis.dart';

part 'ads_photos_state.dart';


class FetchAdsImagesCubit extends Cubit<AdsImagesState> {
  FetchAdsImagesCubit() : super(AdsImagesInitial());

  Future<void> fetchAdsImages() async {
    emit(AdsImagesLoading());
    try {
      final response = await http.get(Uri.parse('https://api.sport.com.ly/management/ads-images'));
      if (response.statusCode == 200) {
        final List<AdsPhoto> adsImages = (json.decode(response.body) as List)
            .map((ad) => AdsPhoto.fromJson(ad))
            .toList();
        emit(AdsImagesLoaded(adsImages));
      } else {
        emit(AdsImagesError('Failed to load ads images'));
      }
    } catch (e) {
      emit(AdsImagesError(e.toString()));
    }
  }
}