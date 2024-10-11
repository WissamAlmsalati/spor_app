part of 'ads_photos_cubit.dart';

@immutable
abstract class AdsImagesState {}


class AdsImagesInitial extends AdsImagesState {}

class AdsImagesLoading extends AdsImagesState {}

class AdsImagesLoaded extends AdsImagesState {
  final List<AdsPhoto> adsImages;

  AdsImagesLoaded(this.adsImages);
}

class AdsImagesError extends AdsImagesState {
  final String error;

  AdsImagesError(this.error);
}

class AdsSocketExaption extends AdsImagesState{}

class SendAdsImagesLoading extends AdsImagesState {}

class SendAdsImagesSuccess extends AdsImagesState {}

class SendAdsImagesError extends AdsImagesState {
  final String error;

  SendAdsImagesError(this.error);
}

