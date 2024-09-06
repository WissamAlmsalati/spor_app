import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../utilits/secure_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

part 'comment_review_state.dart';

class CommentReviewCubit extends Cubit<CommentReviewState> {
  CommentReviewCubit() : super(CommentReviewInitial());

  Future<void> sendCommentReview({
    required BuildContext context,
    required int stadiumId,
    required int playerId,
    required String comment,
    double? rating,
  }) async {
    emit(CommentReviewLoading());
    try {
      final token = await SecureStorageData.getToken();
      if (token == null) {
        throw Exception('Token is null');
      }

      if (comment.isNotEmpty) {
        await _sendComment(context, token, stadiumId, playerId, comment);
      }

      if (rating != null && rating > 0) {
        await _sendReview(context, token, stadiumId, playerId, rating);
      } else {
        _showSuccessDialog(context);
      }

      emit(CommentReviewSuccess());
    } catch (e) {
      if (e is SocketException) {
        emit(CommentReviewError('No internet connection'));
      } else {
        emit(CommentReviewError('An error occurred: $e'));
      }
    }
  }

  Future<void> _sendComment(BuildContext context, String token, int stadiumId, int playerId, String comment) async {
    final body = {
      'stadium': stadiumId,
      'player': playerId,
      'content': comment,
    };

    final response = await http.post(
      Uri.parse('https://api.sport.com.ly/stadium/comment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: utf8.encode(json.encode(body)),
    );

    if (response.statusCode != 201) {
      throw Exception('comment aded: ${response.body}');
    }
  }

  Future<void> _sendReview(BuildContext context, String token, int stadiumId, int playerId, double rating) async {
    final body = {
      'stadium': stadiumId,
      'player': playerId,
      'review': [
        {
          'key': 'rating',
          'value': rating.toString(),
          'description': '',
          'type': 'text',
          'enabled': true,
        }
      ],
    };

    final response = await http.post(
      Uri.parse('https://api.sport.com.ly/stadium/review'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: utf8.encode(json.encode(body)),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      Navigator.of(context).pop(); // Close the current dialog
      _showSuccessDialog(context); // Show the success dialog
    } else {
      throw Exception('review aded: ${response.body}');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottifies/Animation - 1725636111104.json'),
              const SizedBox(height: 16),
              const Text('Comment added successfully!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}