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
  int? selectedSessionId;
  String? selectedTimeFrom;

  void selectDate(DateTime date) {
    selectedDate = date;
    emit(StadiumSearchDateSelected(date));
  }

  void updateSearchText(String text) {
    searchText = text;
    emit(StadiumSearchTextUpdated(text));
  }

  void selectSessionId(int sessionId) {
    selectedSessionId = sessionId;
    emit(StadiumSearchSessionIdSelected(sessionId));
  }

  void selectTimeFrom(String timeFrom) {
    selectedTimeFrom = timeFrom;
    emit(StadiumSearchTimeFromSelected(timeFrom));
  }

  Future<void> searchStadiumsWithFilter({
    required String name,
    required int sessionId,
    required String startDate,
    required String endDate,
    required String timeFrom,
    required String timeTo,
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
        if (sessionId != null) 'id': '$sessionId',
      };

      // Print the query parameters
      print('Query Params filter: $queryParams');

      // Build the query string
      final queryString = Uri(queryParameters: queryParams).query;

      // Ensure the base URL does not end with a question mark
      final baseUrl = Apis.searchStadiumWithQuery.endsWith('?')
          ? Apis.searchStadiumWithQuery.substring(0, Apis.searchStadiumWithQuery.length - 1)
          : Apis.searchStadiumWithQuery;

      // Print the full request URL
      final requestUrl = '$baseUrl?$queryString';
      print('Request URL: $requestUrl');

      final response = await http.get(
        Uri.parse(requestUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (kDebugMode) {
        print('Request URL: ${response.request?.url}');
        print('Response status: ${response.statusCode}');
        print('Response body: ${utf8.decode(response.bodyBytes)}');
      }

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print('Response: ' + queryParams.toString() + queryString);
        final data = json.decode(decodedResponse)['results'] as List;
        final stadiums = data.map((json) => Stadium.fromJson(json)).toList();
        emit(StadiumSearchLoaded(stadiums: stadiums));
      } else {
        final errorData = json.decode(decodedResponse);
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

  Future<void> searchStadiums({
    required String name,
    String? city,
    DateTime? date,
    int? sessionId,
  }) async {
    emit(StadiumSearchLoading());
    try {
      // Construct the query parameters
      final queryParams = {
        'name': name,
        if (city != null) 'city': city,
        if (sessionId != null) 'session_id': sessionId.toString(),
      };

      // Print the query parameters
      print('Query Params: $queryParams');

      // Build the query string
      final queryString = Uri(queryParameters: queryParams).query;

      // Ensure the base URL does not end with a question mark
      final baseUrl = Apis.searchStadiumWithQuery.endsWith('?')
          ? Apis.searchStadiumWithQuery.substring(0, Apis.searchStadiumWithQuery.length - 1)
          : Apis.searchStadiumWithQuery;

      // Print the full request URL
      final requestUrl = '$baseUrl?$queryString';
      print('Request URL: $requestUrl');

      final response = await http.get(
        Uri.parse(requestUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (kDebugMode) {
        print('Request URL: ${response.request?.url}');
        print('Response status: ${response.statusCode}');
        print('Response body: ${utf8.decode(response.bodyBytes)}');
      }

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print('Response: ' + queryParams.toString() + queryString);
        final data = json.decode(decodedResponse)['results'] as List;
        final stadiums = data.map((json) => Stadium.fromJson(json)).toList();
        emit(StadiumSearchLoaded(stadiums: stadiums));
      } else {
        final errorData = json.decode(decodedResponse);
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
        print('Response status: ${response.statusCode}');
        print('Response body: ${utf8.decode(response.bodyBytes)}');
      }

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
    selectedSessionId = null;
    selectedTimeFrom = null;
    emit(StadiumSearchInitial());
  }
}