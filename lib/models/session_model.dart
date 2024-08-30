class Session {
  final int sessionId;
  final String startTime;
  final String endTime;
  final bool isReserved;
  final bool isLocked;

  Session({
    required this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.isReserved,
    required this.isLocked,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isReserved: json['is_reserved'],
      isLocked: json['is_locked'],
    );
  }
}
