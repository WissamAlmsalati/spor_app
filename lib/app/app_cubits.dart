import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/ads_controler/ads_photos_cubit.dart';
import '../controller/fetch_recomended_staduim/fetch_recomended_staduim_cubit.dart';
import 'app_packges.dart';

class RefreshCubit {
  static void refreshCubits(BuildContext context) {
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<ReservationCubit>().fetchReservations();
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<OldReservationFetchCubit>().fetchOldReservations();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
    context.read<AuthenticationCubit>();
    context.read<OldReservationFetchCubit>().fetchOldReservations();
    context.read<FetchAdsImagesCubit>().fetchAdsImages();
    context.read<FetchRecomendedStaduimCubit>().fetchRecomendedStaduims();
  }

  static void refreshActiveReservations(BuildContext context) {
    context.read<ReservationCubit>().fetchReservations();
  }

  static void refreshBalance(BuildContext context) {
    context.read<FetchProfileCubit>().fetchProfileInfo();
  }

  static void refreshFavoriteStadiums(BuildContext context) {
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
  }

  static void checkNetworkAndRefresh(VoidCallback refreshCallback) {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && result.first != ConnectivityResult.none) {
        refreshCallback();
      }
    });
  }

  static void checkNetworkAndRefreshOnDisconnect(VoidCallback refreshCallback) {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && result.first == ConnectivityResult.none) {
        Timer.periodic(const Duration(seconds: 5), (timer) async {
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult.isNotEmpty && connectivityResult.first != ConnectivityResult.none) {
            timer.cancel();
            refreshCallback();
          }
        });
      } else {
        refreshCallback();
      }
    });
  }
}