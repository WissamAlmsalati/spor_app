class Reservation {
  final int id;
  final String date;
  final int weekDay;
  final String startTime;
  final String endTime;
  final String stadiumName;
  final String stadiumAddress;
  final String mapUrl;
  final int stadiumId;
  final DateTime timestamp;

  Reservation({
    required this.id,
    required this.date,
    required this.weekDay,
    required this.startTime,
    required this.endTime,
    required this.stadiumName,
    required this.stadiumAddress,
    required this.mapUrl,
    required this.stadiumId,
    required this.timestamp,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      weekDay: json['week_day'] ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      stadiumName: json['stadium_name'] ?? '',
      stadiumAddress: json['stadium_address'] ?? '',
      mapUrl: json['map_url'] ?? '',
      stadiumId: json['stadium_id'] ?? 0,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  static List<Reservation> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Reservation.fromJson(json)).toList();
  }
}