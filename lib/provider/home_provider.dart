import 'dart:async';
import 'dart:convert';

import 'package:absensi/data/API/api_service.dart';
import 'package:absensi/data/Local/preferences.dart';
import 'package:absensi/data/Local/repository.dart';
import 'package:absensi/provider/utils/disposable_provider.dart';
import 'package:absensi/screens/absen/absen_screen.dart';
import 'package:absensi/screens/history/history_screen.dart';
import 'package:absensi/screens/login_screen.dart';
import 'package:absensi/screens/widgets/custom_dialog.dart';
import 'package:absensi/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;

import '../data/models/error_response.dart';
import '../data/models/user.dart';
import '../utils/custom_page_route.dart';
import '../utils/time_utils.dart';

class HomeProvider extends DisposableProvider {
  final ApiService apiService;
  final Repository repository;
  final Preferences preferences;

  HomeProvider(
      {required this.preferences,
      required this.apiService,
      required this.repository}) {
    getTime();
    getTimer();
    getUser();
  }

  String _date = " - - ";
  String get date => _date;
  String _time = " :: ";
  String get time => _time;

  String _absenMasuk = '';
  String get absenMasuk => _absenMasuk;
  String _absenKeluar = '';
  String get absenKeluar => _absenKeluar;

  String? nik;

  RequestState _state = RequestState.steady;
  RequestState get state => _state;

  User? _user;
  User? get user => _user;
  String tanggalHarian = "";

  late Timer _timer;
  Timer get timer => _timer;

  void getTime() {
    // final DateTime now = DateTime.now();

    // await tz.initializeTimeZone();
    var jakarta = tz.getLocation('Asia/Jakarta');
    var now = tz.TZDateTime.now(jakarta);

    String tanggal = DateFormat("yyyy-MM-dd").format(now);
    tanggalHarian = tanggal;
    String waktu = DateFormat('hh:mm:ss').format(now);
    _date = TimeUtils().formatTglIndo(tanggal);
    _time = waktu;
    notifyListeners();
  }

  void getTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getTime());
    notifyListeners();
  }

  Future<void> getUser() async {
    var stringUser = await repository.getUser();
    nik = await preferences.getNik();
    _user = User.fromJson(json.decode(stringUser!));
    notifyListeners();
  }

  Future<void> getAbsenToday(BuildContext context) async {
    _state = RequestState.loading;
    notifyListeners();
    // if (_user == null) {
    //   getUser();
    // } else {
    //   print(_user?.email);
    // }
    try {
      final response = await apiService.absenToday(nik!, tanggalHarian);
      var result = json.decode(response);
      if (result['data'] != null) {
        _absenMasuk = result['data'][0]['datang']['time'] ?? '-';
        _absenKeluar = result['data'][0]['pulang']['time'] ?? '-';
        _state = RequestState.loaded;
        notifyListeners();
      } else {
        _absenMasuk = "::";
        _absenKeluar = "::";
        notifyListeners();
      }
    } catch (e) {
      _state = RequestState.error;
      notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  Future<String> logout(context) async {
    _state = RequestState.loading;
    notifyListeners();
    showDialog(
        barrierDismissible: false,
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return const CustomDialogLoading(
            text: 'Loading...',
          );
        });
    try {
      final response = await apiService.logout();
      await repository.removeToken();
      await repository.removeUser();
      await preferences.logout();
      await preferences.removeToken();
      return response;
    } catch (e) {
      _state = RequestState.error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> afterLogout(BuildContext context, String response) async {
    if (_state == RequestState.loading) {
      var result = json.decode(response);
      if (result['code'] == 200) {
        _state = RequestState.loaded;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3)).then((_) {
          Navigator.pop(context);
          goToLoginScreen(context);
        });
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

  void goToHistoryScreen(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).push(CustomPageRoute(
          direction: AxisDirection.right, child: const HistoryScreen()));
    }
  }

  void goToAbsenScreen(BuildContext context, String jenis) async {
    if (context.mounted) {
      final response = await Navigator.of(context).push(CustomPageRoute(
          direction: AxisDirection.right,
          child: AbsenScreen(
            jenis: jenis,
          )));
      if (response != null) {
        if (context.mounted) {
          getAbsenToday(context);
        }
      }
    }
  }

  void goToLoginScreen(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement(CustomPageRoute(
          direction: AxisDirection.right, child: const LoginScreen()));
    }
  }

  @override
  void disposeValues() {
    _timer.cancel();
    notifyListeners();
  }
}
