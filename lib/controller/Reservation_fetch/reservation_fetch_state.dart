import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/reservation.dart';

// States
abstract class ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationLoaded extends ReservationState {
  final List<Reservation> reservations;

  ReservationLoaded(this.reservations);
}

class SuccessReservation extends ReservationState {
  final String message;

  SuccessReservation(this.message);
}

class ReservationError extends ReservationState {
  final String message;

  ReservationError(this.message);
}