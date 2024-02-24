import 'dart:convert';

import 'package:absensi/data/API/api_service.dart';
import 'package:absensi/data/Local/preferences.dart';
import 'package:absensi/data/Local/repository.dart';
import 'package:absensi/data/models/history_response.dart';
import 'package:absensi/provider/utils/disposable_provider.dart';
import 'package:absensi/screens/widgets/custom_dialog.dart';
import 'package:absensi/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;

class HistoryProvider extends DisposableProvider {
  final ApiService apiService;
  final Preferences preferences;
  final Repository repository;

  HistoryProvider(
      {required this.apiService,
      required this.preferences,
      required this.repository}) {
    getTime();
    getNik();
  }

  RequestState _state = RequestState.steady;
  RequestState get state => _state;

  String? nik = '';
  String bulan = '';
  String tahun = '';

  List<Datum>? _historyItem;
  List<Datum>? get historyItem => _historyItem;

  Future<void> getNik() async {
    nik = await preferences.getNik();
    notifyListeners();
  }

  void getTime() {
    // final DateTime now = DateTime.now();

    // await tz.initializeTimeZone();
    var jakarta = tz.getLocation('Asia/Jakarta');
    var now = tz.TZDateTime.now(jakarta);

    bulan = DateFormat("M").format(now);
    tahun = DateFormat("yyyy").format(now);
    notifyListeners();
  }

  Future<String> getAbsen() async {
    _state = RequestState.loading;
    notifyListeners();
    try {
      final response = await apiService.absenMonthly(nik!, bulan, tahun);
      return response;
    } catch (e) {
      _state = RequestState.error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> getAbsenMonthly(BuildContext context, String response) async {
    if (_state == RequestState.loading) {
      var result = json.decode(response);
      if (result['code'] == 200) {
        final responseData = HistoryResponse.fromJson(json.decode(response));
        _historyItem = responseData.data;
        _state = RequestState.loaded;
        notifyListeners();
      } else if (result['code'] == 404) {
        _state = RequestState.empty;
        notifyListeners();
      } else if (result['code'] == 500) {
        showDialog(
            barrierDismissible: false,
            useRootNavigator: true,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBoxWithButton(
                title: 'Perhatian',
                descriptions:
                    'Terjadi kesalahan, silahkan coba lagi beberapa saat lagi!',
                text: 'Kembali',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            });
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

  @override
  void disposeValues() {}
}
