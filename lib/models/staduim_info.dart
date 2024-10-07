class StadiumInfo {
  final int id;
  final String name;
  final String address;
  final String regionName;
  final String mapUrl;
  final String sessionPrice;
  final bool allowMonthlyReservation;
  final int totalReservations;
  final int totalReviews;
  final String avgReviews;
  final List<String>? images;
  final bool isFavourite;

  StadiumInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.regionName,
    required this.mapUrl,
    required this.sessionPrice,
    required this.allowMonthlyReservation,
    required this.totalReservations,
    required this.totalReviews,
    required this.avgReviews,
    this.images, // Made images nullable
    required this.isFavourite,
  });

  factory StadiumInfo.fromJson(Map<String, dynamic> json) {
    return StadiumInfo(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      regionName: json['region_name'],
      mapUrl: json['map_url'],
      sessionPrice: json['session_price'],
      allowMonthlyReservation: json['allow_monthly_reservation'],
      totalReservations: json['total_reservations'],
      totalReviews: json['total_reviews'],
      avgReviews: json['avg_reviews'],
      images: json['images'] != null ? List<String>.from(json['images']) : null, // Handle null case
      isFavourite: json['is_favorite'],
    );
  }
}