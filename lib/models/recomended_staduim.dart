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
      image: json['image'],
      isAvailable: json['is_available'] ?? false,
    );
  }
}