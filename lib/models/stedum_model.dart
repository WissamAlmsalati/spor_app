class Stadium {
  final int id;
  final String name;
  final String address;
  final int totalRating;
  final double avgRating;
  final bool isAvailable;
  final String image;
  final bool isFavorite;

  const Stadium({
    required this.id,
    required this.name,
    required this.address,
    required this.totalRating,
    required this.avgRating,
    required this.isAvailable,
    required this.image,
    required this.isFavorite,
  });

  factory Stadium.fromJson(Map<String, dynamic> json) {
    return Stadium(
      id: json['stadium_id'] ?? json['id'] ?? 0,
      name: json['name'] ?? "https://ralfvanveen.com/wp-content/uploads/2021/06/Placeholder-_-Glossary-800x450.webp",
      address: json['address'] ?? "",
      totalRating: json['total_rating'] ?? 0,
      avgRating: json['avg_rating'] != null
          ? double.parse(json['avg_rating'].toString())
          : 0.0,
      isAvailable: json['is_available'] ?? false,
      image: json['image'] ?? "https://interactive.guim.co.uk/atoms/thrashers/2022/11/football-daily-thrasher/assets/v/1721122748492/football-daily-5-3.jpg",
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}


