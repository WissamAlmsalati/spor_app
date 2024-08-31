class AdsPhoto {
  final int id;
  final String image;

  AdsPhoto({required this.id, required this.image});

  factory AdsPhoto.fromJson(Map<String, dynamic> json) {
    // Ensure the image URL is correctly formatted
    String imageUrl = json['image'];
    if (imageUrl.contains('//media/')) {
      imageUrl = imageUrl.replaceFirst('//media/', '/media/');
    }
    return AdsPhoto(
      id: json['id'],
      image: imageUrl,
    );
  }
}