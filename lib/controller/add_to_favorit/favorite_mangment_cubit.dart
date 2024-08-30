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
      }

      final response = await http.post(
        Uri.parse('${Apis.addToFavorite}?stadium=$stadiumId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'stadium': stadiumId}),
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Successfully added to favorite: $stadiumId');
        }
        emit(AdedToFavorite());
        RefreshCubit.refreshFavoriteStadiums(context);
      } else {
        if (kDebugMode) {
          print('Failed to add to favorite: ${response.reasonPhrase}');
          print('Response body: $decodedResponse');
        }
        emit(AddToFavoriteError('Failed to add to favorite'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred while adding to favorite: $e');
      }
      emit(AddToFavoriteError('An error occurred: $e'));
    }
  }

  Future<void> removeFromFavorite(int stadiumId, BuildContext context) async {
    final token = await SecureStorageData.getToken();

    emit(AddToFavoriteLoading());

    try {
      if (kDebugMode) {
        print('Removing from favorite: $stadiumId');
      }

      final response = await http.delete(
        Uri.parse('${Apis.removeFavorite}?stadium=$stadiumId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Successfully removed from favorite: $stadiumId');
        }
        emit(RemovedFromFavorite());
        RefreshCubit.refreshFavoriteStadiums(context);
      } else {
        if (kDebugMode) {
          print('Failed to remove from favorite: ${response.reasonPhrase}');
          print('Response body: $decodedResponse');
        }
        emit(AddToFavoriteError('Failed to remove from favorite'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred while removing from favorite: $e');
      }
      emit(AddToFavoriteError('An error occurred: $e'));
    }
  }
}