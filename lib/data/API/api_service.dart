import 'dart:io';
import 'package:absensi/data/Local/preferences.dart';
import 'package:absensi/utils/exception.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://siiha-hr.dev-aplikasi.dev/api/';
  final http.Client client;

  static const timeOut = 10;

  ApiService({required this.client}) {
    _getToken();
  }

  var token = '';

  _setHeaders() => {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      };

  void _getToken() async {
    final preferences = Preferences();
    final tokenPreferences = await preferences.getToken() ?? "";
    final tokenJwt = JWT.decode(tokenPreferences);
    // token = tokenJwt.payload;
    token = tokenJwt.payload['token_type'] + ' ' + tokenJwt.payload['token'];
  }

  Future<String> login(String email, String password, String imei) async {
    const String endPoint = 'login';
    var url = Uri.parse(_baseUrl + endPoint);

    final data = {'email': email, 'password': password, 'imei': imei};

    try {
      final response = await client
          .post(url, body: data)
          .timeout(const Duration(seconds: timeOut));

      // print(response.body);
      // print(data);
      // print(response.statusCode);
      if (response.statusCode == 200 ||
          response.statusCode == 500 ||
          response.statusCode == 400) {
        return response.body;
      }
      throw ServerException().message;
    } on TimeOutException catch (_) {
      throw TimeOutException().message;
    } on SocketException catch (_) {
      throw NoInternetConnectionException().message;
    }
  }

  Future<String> absenToday(String employeeNik, String tanggal) async {
    const String endpoint = 'absensi/history';
    var url = Uri.parse(_baseUrl + endpoint);
    final data = {'employee_nik': employeeNik, 'tanggal': tanggal};
    try {
      final response = await client
          .post(url, body: data, headers: _setHeaders())
          .timeout(const Duration(seconds: timeOut));

      if (response.statusCode == 200 ||
          response.statusCode == 500 ||
          response.statusCode == 400 ||
          response.statusCode == 404) {
        return response.body;
      }
      throw ServerException().message;
    } on TimeOutException catch (_) {
      throw TimeOutException().message;
    } on SocketException catch (_) {
      throw NoInternetConnectionException().message;
    }
  }

  Future<String> absenMonthly(
      String employeeNik, String bulan, String tahun) async {
    const String endpoint = 'absensi/history-monthly';
    var url = Uri.parse(_baseUrl + endpoint);
    final data = {'employee_nik': employeeNik, 'bulan': bulan, 'tahun': tahun};
    try {
      final response = await client
          .post(url, body: data, headers: _setHeaders())
          .timeout(const Duration(seconds: timeOut));
      if (response.statusCode == 200 ||
          response.statusCode == 500 ||
          response.statusCode == 400 ||
          response.statusCode == 404) {
        return response.body;
      }
      throw ServerException().message;
    } on TimeOutException catch (_) {
      throw TimeOutException().message;
    } on SocketException catch (_) {
      throw NoInternetConnectionException().message;
    }
  }

  Future<String> absen(String employeeNik, String tanggal, String jenisAbsen,
      String imei, String waktu, String lat, String lng) async {
    const String endpoint = 'absensi/simpan-absen';
    var url = Uri.parse(_baseUrl + endpoint);

    final data = {
      'employee_nik': employeeNik,
      'tanggal': tanggal,
      'jenis_absen': jenisAbsen,
      'imei': imei,
      'lat': lat,
      'lng': lng,
      'waktu': waktu
    };

    try {
      final response = await client
          .post(url, body: data, headers: _setHeaders())
          .timeout(const Duration(seconds: 5));
      // print(response.statusCode);
      if (response.statusCode == 200 ||
          response.statusCode == 500 ||
          response.statusCode == 400) {
        return response.body;
      }
      throw ServerException().message;
    } on TimeOutException catch (_) {
      throw TimeOutException().message;
    } on SocketException catch (_) {
      throw NoInternetConnectionException().message;
    }
  }

  Future<String> logout() async {
    const String endpoint = 'logout';
    var url = Uri.parse(_baseUrl + endpoint);
    try {
      final response = await client
          .post(url, headers: _setHeaders())
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200 ||
          response.statusCode == 500 ||
          response.statusCode == 400) {
        return response.body;
      }
      throw ServerException().message;
    } on TimeOutException catch (_) {
      throw TimeOutException().message;
    } on SocketException catch (_) {
      throw NoInternetConnectionException().message;
    }
  }
}
