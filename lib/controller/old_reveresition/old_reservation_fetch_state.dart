part of 'old_reservation_fetch_cubit.dart';


// States
abstract class OldReservationFetchState extends Equatable {
  @override
  List<Object> get props => [];
}

class OldReservationLoading extends OldReservationFetchState {}

class OldReservationLoaded extends OldReservationFetchState {
  final List<Reservation> reservations;
  final bool isLastPage;

  OldReservationLoaded({required this.reservations, required this.isLastPage});

  @override
  List<Object> get props => [reservations, isLastPage];
}

class OldReservationEmpty extends OldReservationFetchState {
  final String message;

  OldReservationEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class OldReservationError extends OldReservationFetchState {
  final String message;

  OldReservationError(this.message);

  @override
  List<Object> get props => [message];
}

class UnAuthenticated extends OldReservationFetchState {}

class OldReservationSocketExceptionError extends OldReservationFetchState {}