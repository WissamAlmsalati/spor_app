part of 'ads_photos_cubit.dart';

@immutable
sealed class AdsPhotosState {}

final class AdsPhotosInitial extends AdsPhotosState {}

final class AdsPhotosLoading extends AdsPhotosState {}

final class AdsPhotosLoaded extends AdsPhotosState {
  final List<AdsPhoto> adsPhotos;
  AdsPhotosLoaded(this.adsPhotos);
}

final class AdsPhotosError extends AdsPhotosState {
  final String message;
  AdsPhotosError(this.message);
}

final class AdsPhotosNoData extends AdsPhotosState {}