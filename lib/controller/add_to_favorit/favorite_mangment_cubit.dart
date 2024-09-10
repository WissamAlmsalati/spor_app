import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/apis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/app_cubits.dart';
import '../../utilits/secure_data.dart';
import '../fetch_favorite/fetch_favorite_cubit.dart';
part 'favorite_mangment_state.dart';

class AddToFavoriteCubit extends Cubit<AddToFavoriteState> {
  AddToFavoriteCubit() : super(AddToFavoriteInitial());

  Timer? _debounce;

  Future<void> checkIfFavorite(int stadiumId, BuildContext context) async {
    final favoriteCubit = context.read<FetchFavoriteCubit>();
    final favoriteState = favoriteCubit.state;
    if (favoriteState is FetchFavoriteLoaded) {
      final isFavorite = favoriteState.favoriteStadiums.any((stadium) => stadium.id == stadiumId);
      if (isFavorite) {
        emit(AdedToFavorite());
      } else {
        emit(RemovedFromFavorite());
      }
    }
  }

  Future<void> toggleFavoriteStatus(int stadiumId, BuildContext context) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (state is AdedToFavorite) {
        final response = await removeFromFavorite(stadiumId, context);
        if (response.statusCode == 200) {
          emit(RemovedFromFavorite());
        }
      } else {
        final response = await addToFavorite(stadiumId, context);
        if (response.statusCode == 200) {
          emit(AdedToFavorite());
        }
      }
    });
  }

  Future<http.Response> addToFavorite(int stadiumId, BuildContext context) async {
    final token = await SecureStorageData.getToken();
    emit(AddToFavoriteLoading());

    try {
      final response = await http.post(
        Uri.parse('${Apis.addToFavorite}?stadium=$stadiumId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'stadium': stadiumId}),
      );

      if (response.statusCode == 201) {
        emit(AdedToFavorite());
        RefreshCubit.refreshFavoriteStadiums(context);
      } else {
        emit(AddToFavoriteError('Failed to add to favorite'));
      }
      return response;
    } catch (e) {
      emit(AddToFavoriteError('An error occurred: $e'));
      rethrow;
    }
  }

  Future<http.Response> removeFromFavorite(int stadiumId, BuildContext context) async {
    final token = await SecureStorageData.getToken();
    emit(AddToFavoriteLoading());

    try {
      final response = await http.delete(
        Uri.parse('${Apis.removeFavorite}?stadium=$stadiumId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        emit(RemovedFromFavorite());
        RefreshCubit.refreshFavoriteStadiums(context);
      } else {
        emit(AddToFavoriteError('Failed to remove from favorite'));
      }
      return response;
    } catch (e) {
      emit(AddToFavoriteError('An error occurred: $e'));
      rethrow;
    }
  }
}