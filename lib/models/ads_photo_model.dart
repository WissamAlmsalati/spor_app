class AdsPhoto {
  final int id;
  final String image;

  AdsPhoto({required this.id, required this.image});

  factory AdsPhoto.fromJson(Map<String, dynamic> json) {
    return AdsPhoto(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
    };
  }
}