import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/recomended_staduim.dart';

part 'fetch_recomended_staduim_state.dart';

class FetchRecomendedStaduimCubit extends Cubit<FetchRecomendedStaduimState> {
  FetchRecomendedStaduimCubit() : super(FetchRecomendedStaduimInitial());

  int _currentPage = 1;
  bool _isLastPage = false;
  List<RecomendedStadium> _staduims = [];

  Future<void> fetchRecomendedStaduims({int pageKey = 1}) async {
    if (pageKey == 1) {
      emit(FetchRecomendedStaduimLoading());
    }
    try {
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/stadiums?page=$pageKey'),
      );
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse) as List<dynamic>;
        final staduims = data.map((json) => RecomendedStadium.fromJson(json as Map<String, dynamic>)).toList();
        _isLastPage = staduims.isEmpty;
        if (pageKey == 1) {
          _staduims = staduims;
        } else {
          _staduims.addAll(staduims);
        }
        emit(FetchRecomendedStaduimLoaded(staduims: _staduims, isLastPage: _isLastPage));
      } else {
        emit(FetchRecomendedStaduimError('Failed to fetch recommended stadiums'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(FetchRecomendedStaduimSocketExceptionError());
      } else {
        emit(FetchRecomendedStaduimError('An error occurred: $e'));
      }
    }
  }

  void loadNextPage() {
    if (!_isLastPage) {
      _currentPage++;
      fetchRecomendedStaduims(pageKey: _currentPage);
    }
  }
}