part of 'fetch_recomended_staduim_cubit.dart';

@immutable
abstract class FetchRecomendedStaduimState {}

class FetchRecomendedStaduimInitial extends FetchRecomendedStaduimState {}

class FetchRecomendedStaduimLoading extends FetchRecomendedStaduimState {}

class FetchRecomendedStaduimLoaded extends FetchRecomendedStaduimState {
  final List<RecomendedStadium> staduims;
  final bool isLastPage;

  FetchRecomendedStaduimLoaded({required this.staduims, required this.isLastPage});
}

class FetchRecomendedStaduimError extends FetchRecomendedStaduimState {
  final String message;

  FetchRecomendedStaduimError(this.message);
}

class FetchRecomendedStaduimSocketExceptionError extends FetchRecomendedStaduimState {}


class RecomendedSocketExaption extends FetchRecomendedStaduimState{}