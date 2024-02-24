import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String isLoggedInKey = "IS_LOGGED_IN";
  static const String isFirstLaunchKey = "IS_FIRST_LAUNCH";
  static const String imeiKey = "IMEI";
  static const String nikKey = "NIK";
  static const String tokenKey = "TOKEN";

  Future<void> setImei(String imei) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(imeiKey, imei);
  }

  Future<String?> getImei() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(imeiKey);
  }

  Future<void> setNik(String nik) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(nikKey, nik);
  }

  Future<String?> getNik() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(nikKey);
  }

  Future<void> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey);
  }

  Future<void> removeToken() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.remove(tokenKey);
  }

  Future<void> login() async {
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setBool(isLoggedInKey, true);
  }

  Future<void> logout() async {
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setBool(isLoggedInKey, false);
  }

  Future<bool?> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(isLoggedInKey) ?? false;
  }
}
