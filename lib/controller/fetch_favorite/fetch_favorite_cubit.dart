import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:sport/models/stedum_model.dart';
import '../../utilits/secure_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'fetch_favorite_state.dart';

class FetchFavoriteCubit extends Cubit<FetchFavoriteState> {
  FetchFavoriteCubit() : super(FetchFavoriteLoading());

  Future<void> fetchFavoriteStadiums() async {
    emit(FetchFavoriteLoading());
    try {
      final token = await SecureStorageData.getToken();
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/favorite'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (kDebugMode) {
        print('Favorite Response  status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: $decodedResponse');
      }

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse)['results'] as List;
        final stadiums = data.map((json) => Stadium.fromJson(json)).toList();
        emit(FetchFavoriteLoaded(stadiums));
      } else if (response.statusCode == 401) {
        emit(UnAuthorizedError());
      } else {
        emit(FetchFavoriteError('Failed to fetch favorite stadiums'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(FavoriteSocketExceptionError());
      } else {
        emit(FetchFavoriteError('An error occurred: $e'));
      }
    }
  }

  static void refreshFavoriteStadiums(BuildContext context) {
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
  }
}