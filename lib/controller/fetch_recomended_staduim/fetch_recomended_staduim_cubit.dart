import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../models/recomended_staduim.dart';

part 'fetch_recomended_staduim_state.dart';

class FetchRecomendedStaduimCubit extends Cubit<FetchRecomendedStaduimState> {
  final PagingController<int, RecomendedStadium> _pagingController = PagingController(firstPageKey: 1);
  final int _pageSize = 10;

  FetchRecomendedStaduimCubit() : super(FetchRecomendedStaduimInitial()) {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchRecomendedStaduims(pageKey);
    });
  }

  PagingController<int, RecomendedStadium> get pagingController => _pagingController;

  Future<void> fetchRecomendedStaduims() async {
    _pagingController.refresh();
  }

  Future<void> _fetchRecomendedStaduims(int pageKey) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/player/stadiums?page=$pageKey'),
      );
      final decodedResponse = utf8.decode(response.bodyBytes);
print("Recomended State: $decodedResponse");
      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse) as Map<String, dynamic>;
        final staduims = (data['results'] as List<dynamic>)
            .map((json) => RecomendedStadium.fromJson(json as Map<String, dynamic>))
            .toList();
        final isLastPage = staduims.length < _pageSize;

        if (isLastPage) {
          _pagingController.appendLastPage(staduims);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(staduims, nextPageKey);
        }
      } else {
        _pagingController.error = 'Failed to fetch recommended stadiums';
      }
    } catch (e) {
      if (e is SocketException) {
        _pagingController.error = 'No Internet connection';
      } else {
        _pagingController.error = 'An error occurred: $e';
      }
    }
  }
}