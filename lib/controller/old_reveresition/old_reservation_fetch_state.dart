import 'package:equatable/equatable.dart';
import '../../models/reservation.dart';

// States
abstract class OldReservationFetchState extends Equatable {
  const OldReservationFetchState();

  @override
  List<Object?> get props => [];
}

// Initial state
class OldReservationInitial extends OldReservationFetchState {}

// Loading state
class OldReservationLoading extends OldReservationFetchState {}

// Loaded state with reservations and isLastPage flag
class OldReservationLoaded extends OldReservationFetchState {
  final List<Reservation> reservations;
  final bool isLastPage;

  const OldReservationLoaded(this.reservations, this.isLastPage);

  @override
  List<Object?> get props => [reservations, isLastPage];
}

// Error state with error message
class OldReservationError extends OldReservationFetchState {
  final String message;

  const OldReservationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Empty state for when there are no reservations
class OldReservationEmpty extends OldReservationFetchState {}

class OldReservationSocketExceptionError extends OldReservationFetchState {}

class UnAuthenticatedUser extends OldReservationFetchState {}
