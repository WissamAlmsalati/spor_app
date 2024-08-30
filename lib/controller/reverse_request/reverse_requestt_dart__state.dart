part of 'reverse_requestt_dart__cubit.dart';


@immutable
abstract class ReverseRequestState {}

class ReverseRequestInitial extends ReverseRequestState {}

class ReverseRequestLoading extends ReverseRequestState {}

class ReverseRequestSuccess extends ReverseRequestState {}

class ReverseRequestError extends ReverseRequestState {
  final String message;

  ReverseRequestError(this.message);
}