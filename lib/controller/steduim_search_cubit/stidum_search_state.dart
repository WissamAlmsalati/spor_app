part of 'stidum_search_cubit.dart';

@immutable
abstract class StadiumSearchState {}

class StadiumSearchInitial extends StadiumSearchState {}

class StadiumSearchLoading extends StadiumSearchState {}

class StadiumSearchLoaded extends StadiumSearchState {
  final List<Stadium> stadiums;

  StadiumSearchLoaded({required this.stadiums});
}

class StadiumSearchError extends StadiumSearchState {
  final String message;

  StadiumSearchError({required this.message});
}

class StadiumSearchErrorSocketException extends StadiumSearchState {}

class StadiumSearchDateSelected extends StadiumSearchState {
  final DateTime date;

  StadiumSearchDateSelected(this.date);
}

class StadiumSearchTextUpdated extends StadiumSearchState {
  final String text;

  StadiumSearchTextUpdated(this.text);
}

class StadiumSearchSessionIdSelected extends StadiumSearchState {
  final int sessionId;

  StadiumSearchSessionIdSelected(this.sessionId);
}