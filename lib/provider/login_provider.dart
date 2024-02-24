import 'dart:convert';
import 'dart:io';

import 'package:absensi/data/Local/preferences.dart';
import 'package:absensi/data/Local/repository.dart';
import 'package:absensi/data/models/user.dart';
import 'package:absensi/provider/utils/disposable_provider.dart';
import 'package:absensi/utils/request_state.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/API/api_service.dart';
import '../data/models/error_response.dart';
import '../data/models/login_response.dart';
import '../screens/home/home_screen.dart';
import '../screens/widgets/custom_dialog.dart';
import '../utils/custom_page_route.dart';

class LoginProvider extends DisposableProvider {
  final ApiService apiService;
  final Repository repository;
  final Preferences preferences;

  LoginProvider(
      {required this.apiService,
      required this.repository,
      required this.preferences});

  bool _isPasswordVisible = true;
  bool get isPasswordVisible => _isPasswordVisible;

  RequestState _state = RequestState.steady;
  RequestState get state => _state;

  String? _imei = '';
  String? get imei => _imei;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  void setPasswordVisible() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void getInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final result = await deviceInfoPlugin.androidInfo;
      _imei = result.id;
      notifyListeners();
      await preferences.setImei(_imei ?? '');
    } else {
      final result = await deviceInfoPlugin.iosInfo;
      _imei = result.identifierForVendor;
      notifyListeners();
      await preferences.setImei(_imei ?? '');
    }
  }

  Future<String> login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // getImei();
    _state = RequestState.loading;
    notifyListeners();
    try {
      // _state = RequestState.loaded;
      // notifyListeners();
      final response = await apiService.login(
          _emailController.text, _passwordController.text, _imei ?? '');
      return response;
    } catch (e) {
      _state = RequestState.error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> afterLogin(BuildContext context, String response) async {
    if (_state == RequestState.loading) {
      var result = json.decode(response);
      if (result['access_token'] != null) {
        var loginResponse = LoginResponse.fromJson(json.decode(response));
        // await repository.saveUser(value)
        var user = userToJson(loginResponse.user!);
        await repository.saveUser(user);
        await repository.saveToken(
            '${loginResponse.tokenType!} ${loginResponse.accessToken!}');
        final tokenJwt = JWT({
          'token_type': loginResponse.tokenType,
          'token': loginResponse.accessToken
        });
        await preferences
            .setToken(tokenJwt.sign(SecretKey(dotenv.env['JWT_KEY']!)));
        await preferences.login();
        await preferences.setNik(loginResponse.user!.employeeNik!);
        Future.delayed(const Duration(seconds: 3)).then((_) {
          _state = RequestState.loaded;
          notifyListeners();
          goToHomeScreen(context);
        });
      } else if (result['status_code'] != null) {
        if (context.mounted) {
          _state = RequestState.loaded;
          notifyListeners();
          showDialog(
              barrierDismissible: false,
              useRootNavigator: true,
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBoxWithButton(
                  title: 'Perhatian',
                  descriptions: 'Ada isian yang kosong!',
                  text: 'Kembali',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              });
        }
      } else {
        var errorResponse = ErrorResponse.fromJson(json.decode(response));
        if (context.mounted) {
          _state = RequestState.loaded;
          notifyListeners();
          showDialog(
              barrierDismissible: false,
              useRootNavigator: true,
              context: context,
              builder: (BuildContext context) {
                return CustomDialogBoxWithButton(
                  title: 'Perhatian',
                  descriptions: errorResponse.message!,
                  text: 'Kembali',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              });
        }
      }
    } else if (_state == RequestState.error) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(response),
      // ));
      showDialog(
          barrierDismissible: false,
          useRootNavigator: true,
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBoxWithButton(
              title: 'Perhatian',
              descriptions: response,
              text: 'Kembali',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          });
    }
  }

  // Future<void> login(BuildContext context) async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   getInfo();
  //   _state = RequestState.loading;
  //   notifyListeners();
  //   try {
  //     final response = await apiService.login(
  //         _emailController.text, _passwordController.text, _imei!);
  //     if (response.isNotEmpty) {}
  //   } catch (e) {
  //     _state = RequestState.error;
  //     notifyListeners();
  //   }
  // }

  void goToHomeScreen(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement(CustomPageRoute(
          direction: AxisDirection.down, child: const HomeScreen()));
    }
  }

  @override
  void disposeValues() {
    _emailController.dispose();
    _passwordController.dispose();
  }
}
