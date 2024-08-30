import '../models/avilable_sesion_model.dart';
import '../models/staduim_info.dart';

class StadiumResponse {
  final StadiumInfo stadiumInfo;
  final List<AvailableSession> availableSessions;

  StadiumResponse({
    required this.stadiumInfo,
    required this.availableSessions,
  });

  factory StadiumResponse.fromJson(Map<String, dynamic> json) {
    return StadiumResponse(
      stadiumInfo: StadiumInfo.fromJson(json['stadium_info']),
      availableSessions: List<AvailableSession>.from(json['available_sessions'].map((x) => AvailableSession.fromJson(x))),
    );
  }
}