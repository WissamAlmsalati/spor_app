import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'navigation_manager.dart'; // Import the file where the navigatorKey is defined

class HttpInterceptor extends http.BaseClient {
  final http.Client _inner;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  HttpInterceptor(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);
    if (response.statusCode == 401) {
      await _handleUnauthorized();
    }
    return response;
  }

  Future<void> _handleUnauthorized() async {
    if (!NavigationManager().hasNavigatedToOnboarding) {
      await _secureStorage.deleteAll();
      NavigationManager().setNavigatedToOnboarding();
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/onboarding', (route) => false);
    }
  }
}