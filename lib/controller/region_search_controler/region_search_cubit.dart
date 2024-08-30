import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utilits/secure_data.dart';

part 'region_search_state.dart';

class RegionSearchCubit extends Cubit<RegionSearchState> {

  RegionSearchCubit() : super(RegionSearchInitial());

  Future<void> searchRegions(String query) async {
    final token = await SecureStorageData.getToken();
    if (query.isEmpty) {
      emit(RegionSearchInitial());
      return;
    }

    emit(RegionSearchLoading());

    try {
      final response = await http.get(
        Uri.parse('https://api.sport.com.ly/management/regions?name=$query'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as List;
        final regions = data.map((region) => region['name'] as String).toList();
        emit(RegionSearchLoaded(regions));
      } else {
        print('Failed to fetch regions: ${response.statusCode}');
        emit(RegionSearchError('Failed to fetch regions'));
      }
    } catch (e) {
      print('Failed to fetch regions: $e');
      emit(RegionSearchError('Failed to fetch regions'));
    }
  }
}