import 'package:equatable/equatable.dart';

import '../../models/reservation.dart';



// States

abstract class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ReservationInitial extends ReservationState {}

// Loading state
class ReservationLoading extends ReservationState {}

// Loaded state with reservations
class ReservationLoaded extends ReservationState {
  final List<Reservation> reservations;

  const ReservationLoaded(this.reservations);

  @override
  List<Object?> get props => [reservations];
}

// Error state
class ReservationError extends ReservationState {
  final String message;

  const ReservationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Empty state for when there are no reservations
class ReservationEmpty extends ReservationState {}
