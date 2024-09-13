import 'base_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Apis {
  static const String url = BaseUrl.baseUrl;
  static const String login = "${BaseUrl.baseUrl}/auth/login";
  static const String signUp = "${BaseUrl.baseUrl}/player/signup";
  static const String searchStadium = "${BaseUrl.baseUrl}/stadium/search";
  static const String searchStadiumWithQuery = "${BaseUrl.baseUrl}/stadium/search?";
  static const String fetchProfile = "${BaseUrl.baseUrl}/player/profile";
  static const String fetchFavStadiums = "${BaseUrl.baseUrl}/player/favorite";
  static const String stadiumsSearch = "${BaseUrl.baseUrl}/stadium/search";
  static const String addToFavorite = "${BaseUrl.baseUrl}/player/favorite";
  static const String comments = "${BaseUrl.baseUrl}/stadium/comment";
  static const String removeFavorite = "${BaseUrl.baseUrl}/player/favorite";
  static const String oldReservations = "${BaseUrl.baseUrl}/player/reservation-history";
  static const String rechargeBalance = "${BaseUrl.baseUrl}/player/top-up";
  static const String startReservation = "${BaseUrl.baseUrl}/player/reserve";
  static const String staduimDetail = "${BaseUrl.baseUrl}/player/stadium-info";
  static const String AdsPhotos = "${BaseUrl.baseUrl}/management/ads-images";
  static const String phoneVerify = "${BaseUrl.baseUrl}/auth/phone-verify";

  // Add the new endpoint for fetching stadium info
  static String stadiumInfo(int stadiumId) {
    return "$staduimDetail?stadium_id=$stadiumId";
  }


  Future<Map<String, dynamic>> fetchStadiumInfo(int stadiumId) async {
    final response = await http.get(Uri.parse(stadiumInfo(stadiumId)));
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load stadium info');
    }
  }
}