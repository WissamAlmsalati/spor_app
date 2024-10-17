part of 'fetch_favorite_cubit.dart';

@immutable
abstract class FetchFavoriteState {}

class FetchFavoriteInitial extends FetchFavoriteState {}

class FetchFavoriteLoading extends FetchFavoriteState {}

class FetchFavoriteLoaded extends FetchFavoriteState {
  final List<Stadium> stadiums;

  FetchFavoriteLoaded(this.stadiums);
}

class FetchFavoriteError extends FetchFavoriteState {
  final String message;

  FetchFavoriteError(this.message);
}

class FavoriteSocketExceptionError extends FetchFavoriteState {}

class UnAuthorizedError extends FetchFavoriteState {}