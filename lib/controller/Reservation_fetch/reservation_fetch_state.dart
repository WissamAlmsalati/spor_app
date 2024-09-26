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
  final bool isLastPage;

  ReservationLoaded(this.reservations, {required this.isLastPage});
}

class ReservationDeleted extends ReservationState {
  final int reservationId;

  ReservationDeleted(this.reservationId);
}

class ReservationError extends ReservationState {
  final String message;

  ReservationError(this.message);
}

class OldReservSocketError extends ReservationState{}