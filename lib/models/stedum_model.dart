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
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      totalRating: json['total_rating'] ?? 0,
      avgRating: json['avg_rating'] != null
          ? double.parse(json['avg_rating'].toString())
          : 0.0,
      isAvailable: json['is_available'] ?? false,
      image: json['image'] ?? "",
      isFavorite: json['is_favorite'] ?? false,
    );
  }
}