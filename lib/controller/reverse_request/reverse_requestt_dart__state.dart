part of 'reverse_requestt_dart__cubit.dart';


@immutable
abstract class ReverseRequestState {}

class ReverseRequestInitial extends ReverseRequestState {}

class ReverseRequestLoading extends ReverseRequestState {}

class ReverseRequestSuccess extends ReverseRequestState {}

class NoBalance extends ReverseRequestState {
  final String message;

  NoBalance(this.message);
}


class ReservationConflict extends ReverseRequestState {
  final String message;

  ReservationConflict(this.message);
}
class ReverseRequestError extends ReverseRequestState {
  final String message;

  ReverseRequestError(this.message);
}