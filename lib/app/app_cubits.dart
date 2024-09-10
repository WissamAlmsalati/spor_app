import '../controller/ads_controler/ads_photos_cubit.dart';
import 'app_packges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RefreshCubit {
  static void refreshCubits(BuildContext context) {
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<ReservationCubit>().fetchReservations();
    context.read<FetchProfileCubit>().fetchProfileInfo();
    context.read<OldReservationFetchCubit>().fetchOldReservations();
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
    context.read<AuthenticationCubit>().checkUserStatus();
    context.read<OldReservationFetchCubit>().fetchOldReservations();
    context.read<FetchAdsImagesCubit>().fetchAdsImages();
  }

  static void refreshBalance(BuildContext context) {
    context.read<FetchProfileCubit>().fetchProfileInfo();
  }

  static void refreshFavoriteStadiums(BuildContext context) {
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
  }

  static void checkNetworkAndRefresh(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && result.first != ConnectivityResult.none) {
        refreshCubits(context);
      }
    });
  }

  static void checkNetworkAndRefreshOnDisconnect(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && result.first == ConnectivityResult.none) {
        refreshCubits(context);
      } else if (result.isNotEmpty && result.first != ConnectivityResult.none) {
        refreshCubits(context);
      }
    });
  }
}