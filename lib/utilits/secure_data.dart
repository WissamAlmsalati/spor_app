import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageData {
  static const _storage = FlutterSecureStorage();

  static Future<String?> getIsSign() async {
    return await _storage.read(key: 'isSignedUp');
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'accessToken');
  }

  static Future<String?> getId() async {
    return await _storage.read(key: 'userId');
  }

  static Future<String?> getPhone() async {
    return await _storage.read(key: 'phone');
  }

  static Future<void> setPhone(String phone) async {
    await _storage.write(key: 'phone', value: phone);
  }

  static Future<void> setIsSignedUp(bool value) async {
    await _storage.write(key: 'isSignedUp', value: value.toString());
  }

  static Future<void> clearData() async {
    await _storage.deleteAll();
  }

  static const _themeKey = 'theme_preference';

  static Future<void> saveThemePreference(String theme) async {
    await _storage.write(key: _themeKey, value: theme);
  }

  static Future<String?> getThemePreference() async {
    return await _storage.read(key: _themeKey);
  }

  static Future<void> saveDeviceToken(String token) async {
    await _storage.write(key: 'deviceToken', value: token);
  }

  static Future<String?> getDeviceToken() async {
    return await _storage.read(key: 'deviceToken');
  }
}