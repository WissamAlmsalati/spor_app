import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/apis.dart';
import '../../app/app_cubits.dart';
import '../../utilits/secure_data.dart';
import '../Reservation_fetch/reservation_fetch_cubit.dart';
import '../Reservation_fetch/reservation_fetch_state.dart';
import '../fetch_favorite/fetch_favorite_cubit.dart';
import '../old_reveresition/old_reservation_fetch_cubit.dart';
import '../profile/fetch_profile_cubit.dart';

part 'authintication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> checkUserStatus() async {
    emit(AuthenticationLoading());

    String? isSignedUpString = await SecureStorageData.getIsSign();
    final bool isSignedUp = isSignedUpString == 'true';

    if (isSignedUp) {
      emit(AuthenticationAuthenticated());
    } else {
      emit(AuthenticationUnauthenticated());
    }
  }
  Future<void> checkAuthentication() async {
    String? token = await _secureStorage.read(key: 'accessToken');
    if (token != null && token.isNotEmpty) {
      emit(AuthenticationAuthenticated());  // User is authenticated
    } else {
      emit(AuthenticationUnauthenticated()); // User is not authenticated
    }
  }

  Future<void> logIn({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      emit(AuthenticationFailure('Username or password cannot be empty'));
      return;
    }
    try {
      emit(AuthenticationLoading());
      final response = await http.post(
        Uri.parse(Apis.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        const storage = FlutterSecureStorage();

        await storage.write(key: 'refreshToken', value: responseBody['refresh']);
        await storage.write(key: 'accessToken', value: responseBody['access']);
        await storage.write(key: 'userId', value: responseBody['id'].toString());

        await SecureStorageData.setIsSignedUp(true);

        // Refresh other Cubits
        emit(AuthenticationAuthenticated());
        RefreshCubit.refreshCubits(context);
        Navigator.pushNamedAndRemoveUntil(
            context, '/homeNavigation', (route) => false);
      } else {
        emit(AuthenticationFailure('Invalid username or password'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(SocketExceptionError());
      } else {
        emit(AuthenticationFailure(e.toString()));
      }
    }
  }

  void logOut(BuildContext context) async {
    await SecureStorageData.clearData();
    emit(AuthenticationUnauthenticated());

    context.read<AuthenticationCubit>().emit(AuthenticationUnauthenticated());
    context.read<FetchProfileCubit>().emit(FetchProfileLoading());
    context.read<ReservationCubit>().emit(ReservationLoading());
    context.read<OldReservationFetchCubit>().emit(OldReservationLoading());
    context.read<FetchFavoriteCubit>().emit(FetchFavoriteLoading());

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/onboarding',
      (route) => false,
    );
  }
}
