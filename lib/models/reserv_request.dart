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


