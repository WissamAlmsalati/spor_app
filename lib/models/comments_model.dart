class Comment {
  final int id;
  final int stadiumId;
  final String content;
  final String playerName;
  final String? playerImage;
  final String timestamp;

  Comment({
    required this.id,
    required this.stadiumId,
    required this.content,
    required this.playerName,
    this.playerImage,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      stadiumId: json['stadium_id'],
      content: json['content'],
      playerName: json['player_name'],
      playerImage: json['player_image'],
      timestamp: json['timestamp'],
    );
  }
}