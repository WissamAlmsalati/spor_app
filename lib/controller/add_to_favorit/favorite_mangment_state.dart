part of 'favorite_mangment_cubit.dart';

@immutable
abstract class AddToFavoriteState {}

class AddToFavoriteInitial extends AddToFavoriteState {}

class AddToFavoriteLoading extends AddToFavoriteState {}

class AdedToFavorite extends AddToFavoriteState {}

class RemovedFromFavorite extends AddToFavoriteState {}

class AddToFavoriteError extends AddToFavoriteState {
  final String message;
  AddToFavoriteError(this.message);
}