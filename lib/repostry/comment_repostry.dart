import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/comments_model.dart';

class CommentRepository {
  final String baseUrl;

  CommentRepository(this.baseUrl);

  Future<PaginatedComments> fetchComments(int stadiumId, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stadium/comment?stadium_id=$stadiumId&page=$page'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return PaginatedComments.fromJson(data);
    } else {
      throw Exception('Failed to load comments');
    }
  }
}