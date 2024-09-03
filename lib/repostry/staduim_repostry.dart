import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilits/secure_data.dart';

class StadiumRepository {
  final String apiUrl = 'https://api.sport.com.ly/player/reserve/';

  Future<http.Response> sendReverseRequest(Map<String, dynamic> requestData) async {
    final url = Uri.parse(apiUrl);
    final token = await SecureStorageData.getToken();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    return response;
  }
}