import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utilits/secure_data.dart';

class StadiumRepository {
  final String baseUrl;

  StadiumRepository({this.baseUrl = 'https://api.sport.com.ly'});

  Future<void> sendReverseRequest(Map<String, dynamic> requestData) async {
    final token = await SecureStorageData.getToken();

    final url = Uri.parse('$baseUrl/player/reserve');
    print('Request data: ${jsonEncode(requestData)}'); // Print request data for debugging

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode != 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.headers['content-type']?.contains('application/json') == true) {
        final errorData = json.decode(response.body);
        throw Exception('Failed to send reverse request: ${errorData['detail']}');
      } else {
        throw Exception('Failed to send reverse request: ${response.body}');
      }
    }
  }

  Future<void> getReserve() async {
    final url = Uri.parse('$baseUrl/player/reserve');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await SecureStorageData.getToken()}',
        'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      print('Response body: ${response.body}');
      throw Exception('Failed to get reserve');
    }

    final data = json.decode(response.body);
  }
}
