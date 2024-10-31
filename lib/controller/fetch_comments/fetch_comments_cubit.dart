import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/comments_model.dart';
import '../../utilits/secure_data.dart';

part 'fetch_comments_state.dart';

class FetchCommentsCubit extends Cubit<FetchCommentsState> {
  final String apiUrl = 'https://api.sport.com.ly/stadium/comment';

  FetchCommentsCubit() : super(FetchCommentsInitial());

  Future<void> fetchComments(int stadiumId, int pageKey, PagingController<int, Comment> pagingController, int pageSize) async {
    try {
      final token = await SecureStorageData.getToken();
      final response = await http.get(
        Uri.parse('$apiUrl?stadium_id=$stadiumId&page=$pageKey'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> commentList = data['results'];
        final List<Comment> newComments = commentList.map((json) => Comment.fromJson(json)).toList();
        final isLastPage = newComments.length < pageSize;

        if (isLastPage) {
          pagingController.appendLastPage(newComments);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newComments, nextPageKey);
        }
      } else if (response.statusCode == 404) {
        pagingController.appendLastPage([]);
      } else {
        pagingController.error = 'Failed to load comments (Status code: ${response.statusCode})';
      }
    } catch (error) {
      pagingController.error = error.toString();
    }
  }
}