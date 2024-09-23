import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/recomended_staduim.dart';

part 'fetch_recomended_staduim_state.dart';

class FetchRecomendedStaduimCubit extends Cubit<FetchRecomendedStaduimState> {
  FetchRecomendedStaduimCubit() : super(FetchRecomendedStaduimInitial());

  Future<void> fetchRecomendedStaduims() async {
    emit(FetchRecomendedStaduimLoading());

    try {
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/stadiums'),
      );
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: $decodedResponse');

        final data = json.decode(decodedResponse) as List<dynamic>;
        final staduims = data.map((json) {
          try {
            return RecomendedStadium.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('Error parsing stadium: $json');
            throw e;
          }
        }).toList();
        emit(FetchRecomendedStaduimLoaded(staduims: staduims, isLastPage: false));
      } else {
        print('Failed to fetch recommended stadiums: ${response.statusCode}');
        emit(FetchRecomendedStaduimError('Failed to fetch recommended stadiums'));
      }
    } catch (e) {
      print('An error occurred: $e');
      if (e is SocketException) {
        emit(FetchRecomendedStaduimSocketExceptionError());
      } else if (e is FormatException) {
        emit(FetchRecomendedStaduimError('Data format error: $e'));
      } else {
        emit(FetchRecomendedStaduimError('An error occurred: $e'));
      }
    }
  }
}