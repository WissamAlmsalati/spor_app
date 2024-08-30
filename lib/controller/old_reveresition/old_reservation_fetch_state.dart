part of 'old_reservation_fetch_cubit.dart';

@immutable
abstract class OldReservationFetchState {}

class OldReservationLoading extends OldReservationFetchState {}

class OldReservationLoaded extends OldReservationFetchState {
  final List<Reservation> reservations;

  OldReservationLoaded(this.reservations);
}

class OldReservationEmpty extends OldReservationFetchState {
  final String message;

  OldReservationEmpty(this.message);
}

class UnAuthenticated extends OldReservationFetchState {}

class OldReservationSocketExceptionError extends OldReservationFetchState {}

class OldReservationError extends OldReservationFetchState {
  final String message;

  OldReservationError(this.message);
}