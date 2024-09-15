part of 'staduim_detail_cubit.dart';

@immutable
abstract class StaduimDetailState {}

class StaduimDetailInitial extends StaduimDetailState {}

class StaduimDetailLoading extends StaduimDetailState {}

class StaduimDetailLoaded extends StaduimDetailState {
  final StadiumInfo stadiumInfo;
  final List<AvailableSession> availableSessions;
  final bool isFavorite;

  StaduimDetailLoaded({
    required this.stadiumInfo,
    required this.availableSessions,
    this.isFavorite = false, // Default to false
  });
}

class StaduimDetailLoadedEmptySession extends StaduimDetailState {
  final StadiumInfo stadiumInfo;

  StaduimDetailLoadedEmptySession({required this.stadiumInfo});
}

class StaduimDetailError extends StaduimDetailState {
  final String message;

  StaduimDetailError({required this.message});
}