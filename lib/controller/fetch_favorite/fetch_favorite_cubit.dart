import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../app/app_packges.dart';
import '../../models/stedum_model.dart';
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

part 'fetch_favorite_state.dart';

class FetchFavoriteCubit extends Cubit<FetchFavoriteState> {
  final PagingController<int, Stadium> _pagingController = PagingController(firstPageKey: 1);
  final int _pageSize = 10;
  final http.Client _client;

  FetchFavoriteCubit() : _client = HttpInterceptor(http.Client()), super(FetchFavoriteInitial()) {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchFavoriteStadiums(pageKey);
    });
  }

  PagingController<int, Stadium> get pagingController => _pagingController;

  Future<void> fetchFavoriteStadiums() async {
    _pagingController.refresh();
  }

  Future<void> _fetchFavoriteStadiums(int pageKey) async {
    try {
      final token = await SecureStorageData.getToken();
      final response = await _client.get(
        Uri.parse('https://api.sport.com.ly/player/favorite?page=$pageKey'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse) as Map<String, dynamic>;
        final stadiums = (data['results'] as List<dynamic>)
            .map((json) => Stadium.fromJson(json as Map<String, dynamic>))
            .toList();
        final isLastPage = stadiums.length < _pageSize;

        if (isLastPage) {
          _pagingController.appendLastPage(stadiums);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(stadiums, nextPageKey);
        }
      } else {
        _pagingController.error = 'Failed to fetch favorite stadiums';
      }
    } catch (e) {
      if (e is SocketException) {
        _pagingController.error = 'No Internet connection';
      } else {
        _pagingController.error = 'An error occurred: $e';
      }
    }
  }

  static void refreshFavoriteStadiums(BuildContext context) {
    context.read<FetchFavoriteCubit>().fetchFavoriteStadiums();
  }
}