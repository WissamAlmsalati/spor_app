part of 'old_reservation_fetch_cubit.dart';

abstract class OldReservationFetchState extends Equatable {
  const OldReservationFetchState();

  @override
  List<Object> get props => [];
}

class OldReservationInitial extends OldReservationFetchState {}

class OldReservationLoading extends OldReservationFetchState {}

class OldReservationLoaded extends OldReservationFetchState {
  final List<Reservation> reservations;
  final bool isLastPage;

  const OldReservationLoaded({required this.reservations, required this.isLastPage});

  @override
  List<Object> get props => [reservations, isLastPage];
}

class OldReservationEmpty extends OldReservationFetchState {
  final String message;

  const OldReservationEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class OldReservationError extends OldReservationFetchState {
  final String message;

  const OldReservationError(this.message);

  @override
  List<Object> get props => [message];
}

class OldReservationSocketExceptionError extends OldReservationFetchState {}

class UnAuthenticated extends OldReservationFetchState {}