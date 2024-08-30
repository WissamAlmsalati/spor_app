class Reservation {
  final int id;
  final String date;
  final int weekDay;
  final String startTime;
  final String endTime;
  final String stadiumName;
  final String stadiumAddress;
  final String mapUrl;

  Reservation({
    required this.id,
    required this.date,
    required this.weekDay,
    required this.startTime,
    required this.endTime,
    required this.stadiumName,
    required this.stadiumAddress,
    required this.mapUrl,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      date: json['date'],
      weekDay: json['week_day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      stadiumName: json['stadium_name'],
      stadiumAddress: json['stadium_address'],
      mapUrl: json['map_url'],
    );
  }
}
