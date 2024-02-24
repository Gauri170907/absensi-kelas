import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Repository {
  final secureStorage = const FlutterSecureStorage();

  static const String tokenKey = "TOKEN";
  static const String userKey = "USER";

  IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> saveToken(String? value) async {
    await secureStorage.write(
        key: tokenKey,
        value: value ?? '',
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }

  Future<String?> getToken() async {
    var token = await secureStorage.read(
        key: tokenKey,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
    return token;
  }

  Future<void> removeToken() async {
    await secureStorage.delete(
        key: tokenKey,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }

  Future<void> saveUser(String value) async {
    await secureStorage.write(
        key: userKey,
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }

  Future<String?> getUser() async {
    var user = await secureStorage.read(
        key: userKey,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
    return user;
  }

  Future<void> removeUser() async {
    await secureStorage.delete(
        key: userKey,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
  }
}
