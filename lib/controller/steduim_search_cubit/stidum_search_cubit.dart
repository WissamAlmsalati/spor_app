import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/stedum_model.dart';
import '../../services/apis.dart';

part 'stidum_search_state.dart';

class StadiumSearchCubit extends Cubit<StadiumSearchState> {
  StadiumSearchCubit() : super(StadiumSearchInitial());

  DateTime? selectedDate;
  String searchText = '';

  void selectDate(DateTime date) {
    selectedDate = date;
    emit(StadiumSearchDateSelected(date));
  }

  void updateSearchText(String text) {
    searchText = text;
    emit(StadiumSearchTextUpdated(text));
  }

  Future<void> searchStadiums({
    required String name,
    String? startDate,
    String? endDate,
    String? timeFrom,
    String? timeTo,
  }) async {
    emit(StadiumSearchLoading());
    try {
      // Construct the query parameters
      final queryParams = {
        'name': name,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (timeFrom != null) 'time_from': timeFrom,
        if (timeTo != null) 'time_to': timeTo,
      };

      // Build the query string
      final queryString = Uri(queryParameters: queryParams).query;

      final response = await http.get(
        Uri.parse('${Apis.searchStadiumWithQuery}$queryString'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (kDebugMode) {
        print('Request URL: ${response.request?.url}');
      }
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print(
          'Response body: ${utf8.decode(response.bodyBytes)}');
      } // Ensure correct decoding of response body

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse)['results'] as List;
        final stadiums = data.map((json) => Stadium.fromJson(json)).toList();
        emit(StadiumSearchLoaded(stadiums: stadiums));
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = errorData['detail'] ?? 'Failed to load stadiums';
        if (kDebugMode) {
          print('Failed to load stadiums: $errorMessage');
        }
        emit(StadiumSearchError(message: errorMessage));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(StadiumSearchErrorSocketException());
      } else {
        if (kDebugMode) {
          print('Error: $e');
        }
        emit(StadiumSearchError(message: e.toString()));
      }
    }
  }

  Future<void> fetchStadiumById(String id) async {
    emit(StadiumSearchLoading());
    try {
      final response = await http.get(
        Uri.parse('${Apis.searchStadium}/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (kDebugMode) {
        print('Request URL: ${response.request?.url}');
      }
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print(
          'Response body: ${utf8.decode(response.bodyBytes)}');
      } // Ensure correct decoding of response body

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final stadium = Stadium.fromJson(data);
        emit(StadiumSearchLoaded(stadiums: [stadium]));
      } else {
        final errorData = json.decode(utf8.decode(response.bodyBytes));
        final errorMessage = errorData['detail'] ?? 'Failed to load stadium';
        if (kDebugMode) {
          print('Failed to load stadium: $errorMessage');
        }
        emit(StadiumSearchError(message: errorMessage));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      emit(StadiumSearchError(message: e.toString()));
    }
  }

  void resetSearch() {
    selectedDate = null;
    searchText = '';
    emit(StadiumSearchInitial());
  }
}
