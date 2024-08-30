// fetch_comments_cubit.dart
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../models/comments_model.dart';
import '../../services/apis.dart';
import '../../utilits/secure_data.dart';
import 'package:http/http.dart' as http;

part 'fetch_comments_state.dart';

class FetchCommentsCubit extends Cubit<FetchCommentsState> {
  FetchCommentsCubit() : super(FetchCommentsInitial());

  Future<void> fetchComments(int stadiumId, Function(List<Comment>) onSuccess) async {
    final token = await SecureStorageData.getToken();
    emit(FetchCommentsLoading());

    try {
      final response = await http.get(
        Uri.parse('${Apis.comments}?stadium_id=$stadiumId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        final List<Comment> comments = responseData.map((json) => Comment.fromJson(json)).toList();
        onSuccess(comments);
        emit(FetchCommentsLoaded(comments));
      } else {
        emit(FetchCommentsError('Failed to fetch comments: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(FetchCommentsError('An error occurred: $e'));
    }
  }
}