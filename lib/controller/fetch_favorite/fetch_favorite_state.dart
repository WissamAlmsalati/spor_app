part of 'fetch_favorite_cubit.dart';





@immutable
abstract class FetchFavoriteState {}

class FetchFavoriteLoading extends FetchFavoriteState {}

class FetchFavoriteLoaded extends FetchFavoriteState {
  final List<Stadium> stadiums;

  FetchFavoriteLoaded(this.stadiums);

  List<Stadium> get favoriteStadiums => stadiums;
}

class FetchFavoriteError extends FetchFavoriteState {
  final String message;

  FetchFavoriteError(this.message);
}

class FetchFavoriteEmpty extends FetchFavoriteState {}

class UnAuthorizedError extends FetchFavoriteState {}

class FavoriteSocketExceptionError extends FetchFavoriteState {}