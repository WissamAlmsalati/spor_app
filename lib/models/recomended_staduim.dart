class RecomendedStadium {
  final int stadiumId;
  final String name;
  final String? image;
  final bool isAvailable;

  const RecomendedStadium({
    required this.stadiumId,
    required this.name,
    this.image,
    required this.isAvailable,
  });

  factory RecomendedStadium.fromJson(Map<String, dynamic> json) {
    return RecomendedStadium(
      stadiumId: json['stadium_id'] ?? 0,
      name: json['name'] ?? "",
      image: json['image'] ?? "https://interactive.guim.co.uk/atoms/thrashers/2022/11/football-daily-thrasher/assets/v/1721122748492/football-daily-5-3.jpg",
      isAvailable: json['is_available'] ?? false,
    );
  }
}