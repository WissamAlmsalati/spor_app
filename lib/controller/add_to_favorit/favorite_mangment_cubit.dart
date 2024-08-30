import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/apis.dart';
import '../../app/app_cubits.dart';
import '../../utilits/secure_data.dart';


part 'favorite_mangment_state.dart';

class AddToFavoriteCubit extends Cubit<AddToFavoriteState> {
  AddToFavoriteCubit() : super(AddToFavoriteInitial());

  Future<void> addToFavorite(int stadiumId, BuildContext context) async {
    final token = await SecureStorageData.getToken();

    emit(AddToFavoriteLoading());

    try {
      if (kDebugMode) {
        print('Adding to favorite: $stadiumId');
      } // Debug print to verify method call

      final response = await http.post(
        Uri.parse(Apis.addToFavorite),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Ensure the Content-Type is set to application/json
        },
        body: jsonEncode({'stadium': stadiumId}),
      );

      // Debugging information
      if (kDebugMode) {
        print('Request body: ${jsonEncode({'stadium_id': stadiumId})}');
      }
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response headers: ${response.headers}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        emit(AdedToFavorite());
        RefreshCubit.refreshFavoriteStadiums(context); // Refresh favorite stadiums list
      } else {
        // Handle error responses
        String errorMessage = 'Failed to add to favorite: ${response.reasonPhrase}';
        try {
          var errorResponse = jsonDecode(response.body);
          if (errorResponse is Map && errorResponse.containsKey('detail')) {
            errorMessage = utf8.decode(response.bodyBytes); // Decode UTF-8 encoded response
          }
        } catch (e) {
          // Failed to parse error response
          if (kDebugMode) {
            print('Failed to decode error response: ${response.body}');
          }
        }

        emit(AddToFavoriteError(errorMessage));
      }
    } catch (e) {
      emit(AddToFavoriteError('An error occurred: $e'));
    }
  }
}