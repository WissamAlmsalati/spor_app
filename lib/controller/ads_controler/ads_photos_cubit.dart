import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sport/app/app_packges.dart';

import '../../models/ads_photo_model.dart';

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
      if (e is SocketExceptionError){
        emit(AdsSocketExaption());
      }
      emit(AdsImagesError(e.toString()));
    }
  }
}