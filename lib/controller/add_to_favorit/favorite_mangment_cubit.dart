import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../app/authintication_middleware.dart';
import '../../services/apis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utilits/secure_data.dart';
import '../fetch_favorite/fetch_favorite_cubit.dart';
part 'favorite_mangment_state.dart';

class AddToFavoriteCubit extends Cubit<AddToFavoriteState> {
  final BuildContext context;
  late final http.Client _client;

  AddToFavoriteCubit(this.context) : super(AddToFavoriteInitial()) {
    _client = HttpInterceptor(http.Client());
  }

  Timer? _debounce;

  Future<void> toggleFavoriteStatus(int stadiumId, BuildContext context) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (state is AdedToFavorite) {
        final response = await removeFromFavorite(stadiumId, context);
        if (response.statusCode == 200) {
          emit(RemovedFromFavorite());
          FetchFavoriteCubit.refreshFavoriteStadiums(context);
        }
      } else {
        final response = await addToFavorite(stadiumId, context);
        if (response.statusCode == 200) {
          emit(AdedToFavorite());
          FetchFavoriteCubit.refreshFavoriteStadiums(context);
        }
      }
    });
  }

Future<http.Response> addToFavorite(int stadiumId, BuildContext context) async {
  final token = await SecureStorageData.getToken();
  emit(AddToFavoriteLoading());

  try {
    final response = await _client.post(
      Uri.parse('${Apis.addToFavorite}?stadium=$stadiumId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'stadium': stadiumId}),
    );

    if (response.statusCode == 201) {
      emit(AdedToFavorite());
      FetchFavoriteCubit.refreshFavoriteStadiums(context);
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
      final response = await _client.delete(
        Uri.parse('${Apis.removeFavorite}?stadium=$stadiumId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        emit(RemovedFromFavorite());
        FetchFavoriteCubit.refreshFavoriteStadiums(context);
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