// models/session.dart
class Session {
  final String date;
  final int sessionId;

  Session({
    required this.date,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'session_id': sessionId,
  };
}

// models/reservation_request.dart

class ReservationRequest {
  final Session session;
  final int paymentType;
  final bool isMonthlyReservation;

  ReservationRequest({
    required this.session,
    required this.paymentType,
    required this.isMonthlyReservation,
  });

  Map<String, dynamic> toJson() => {
    'session': session.toJson(),
    'payment_type': paymentType,
    'is_monthly_reservation': isMonthlyReservation,
  };
}
