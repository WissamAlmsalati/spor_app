import 'package:sport/models/session_model.dart';

class AvailableSession {
  final String date;
  final List<Session> sessions;

  AvailableSession({required this.date, required this.sessions});

  factory AvailableSession.fromJson(Map<String, dynamic> json) {
    var sessionList = json['sessions'] as List;
    List<Session> sessions = sessionList.map((i) => Session.fromJson(i)).toList();

    return AvailableSession(
      date: json['date'],
      sessions: sessions,
    );
  }
}