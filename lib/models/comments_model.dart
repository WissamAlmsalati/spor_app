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
      id: json['id']??0,
      stadiumId: json['stadium_id']??0,
      content: json['content']??'',
      playerName: json['player_name']??'',
      playerImage: json['player_image']??'',
      timestamp: json['timestamp']??'',
    );
  }
}


class PaginatedComments {
  final int count;
  final String? next;
  final String? previous;
  final List<Comment> results;

  PaginatedComments({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedComments.fromJson(Map<String, dynamic> json) {
    return PaginatedComments(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
    );
  }
}