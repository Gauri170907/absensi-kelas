import 'dart:async';
import 'dart:convert';

import 'package:absensi/data/API/api_service.dart';
import 'package:absensi/data/Local/repository.dart';
import 'package:absensi/data/models/error_response.dart';
import 'package:absensi/provider/utils/disposable_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/standalone.dart' as tz;

import '../data/Local/preferences.dart';
import '../data/models/user.dart';
import '../screens/widgets/custom_dialog.dart';
import '../utils/request_state.dart';

class AbsenProvider extends DisposableProvider {
  final ApiService apiService;
  final Repository repository;
  final Preferences preferences;

  AbsenProvider(
      {required this.apiService,
      required this.repository,
      required this.preferences}) {
    getImei();
    getUser();
    // getToken();
  }

  // final Completer<GoogleMapController> _mapController = Completer();
  // Completer<GoogleMapController> get mapController => _mapController;

  final CameraPosition _mapInitialPosition = const CameraPosition(
    target: LatLng(-6.626498942111265, 106.82889933862454),
    zoom: 15.0,
  );

  final List<Marker> _markers = <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(-6.626498942111265, 106.82889933862454),
        infoWindow: InfoWindow(
          title: 'Sekolah',
        )),
  ];
  List<Marker> get markers => _markers;

  RequestState _state = RequestState.steady;
  RequestState get state => _state;

  CameraPosition get mapInitialPosition => _mapInitialPosition;

  String? _imei = '';
  String? get imei => _imei;

  User user = User();

  String _time = " - - ";
  String get time => _time;

  String _date = " - - ";
  String get date => _date;

  late Position _position;
  Position get position => _position;

  bool _serviceEnabled = false;
  bool get serviceEnabled => _serviceEnabled;

  // String? token = '';

  // void getToken() async {
  //   token = await repository.getToken();
  //   notifyListeners();
  // }

  void getImei() async {
    _imei = await preferences.getImei();
    notifyListeners();
  }

  void getUser() async {
    var stringUser = await repository.getUser();
    if (stringUser != '') {
      user = User.fromJson(json.decode(stringUser!));
      notifyListeners();
    }
  }

  void getTime() {
    // final DateTime now = DateTime.now();

    // await tz.initializeTimeZone();
    var jakarta = tz.getLocation('Asia/Jakarta');
    var now = tz.TZDateTime.now(jakarta);

    _date = DateFormat("yyyy-MM-dd").format(now);
    _time = DateFormat("hh:mm:ss").format(now);
    notifyListeners();
  }

  Future<void> checkGps(BuildContext context) async {
    LocationPermission permission;
    _serviceEnabled = await location.Location().serviceEnabled();
    notifyListeners();
    if (!serviceEnabled) {
      if (context.mounted) {
        showDialog(
            barrierDismissible: false,
            useRootNavigator: true,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBoxWithButton(
                title: 'Perhatian',
                descriptions:
                    'Tidak dapat mendeteksi lokasi saat ini! Pastikan GPS sudah aktif dan coba lagi!',
                text: 'Coba lagi!',
                onPressed: () async {
                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    await Permission.locationWhenInUse.request();
                    permission = await Geolocator.requestPermission();
                  }
                  _serviceEnabled = await location.Location().requestService();
                  notifyListeners();
                  if (serviceEnabled) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    if (context.mounted) {
                      Navigator.pop(context);
                      checkGps(context);
                    }
                  }
                  // if (context.mounted) {
                  // }
                  // else {
                  // }
                },
              );
            });
      }
    } else {
      getUserCurrentLocation();
    }
  }

  // // created method for getting user current location
  Future<void> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    _position = await Geolocator.getCurrentPosition();
    notifyListeners();
  }

  Future<String> absen(BuildContext context, String jenisAbsen) async {
    getTime();
    _state = RequestState.loading;
    notifyListeners();
    try {
      final response = await apiService.absen(
        user.employeeNik!,
        _date,
        jenisAbsen,
        _imei!,
        _time,
        _position.latitude.toString(),
        _position.longitude.toString(),
      );
      return response;
    } catch (e) {
      _state = RequestState.error;
      notifyListeners();
      return e.toString();
    }
  }

  Future<void> afterAbsen(BuildContext context, String response) async {
    if (_state == RequestState.loading) {
      var result = json.decode(response);
      if (result['code'] == 200) {
        showDialog(
            barrierDismissible: false,
            useRootNavigator: true,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBoxWithButton(
                title: 'Berhasil',
                descriptions: result['message'],
                text: 'Kembali',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, 'back');
                  _state = RequestState.loaded;
                  notifyListeners();
                  // goToHomeScreen(context);
                },
              );
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response),
      ));
    }
  }

  void goToHomeScreen(BuildContext context) {
    Navigator.pop(context);
    // if (context.mounted) {
    //   Navigator.of(context).pushReplacement(CustomPageRoute(
    //       direction: AxisDirection.down, child: const HomeScreen()));
    // }
  }

  @override
  void disposeValues() {}
}
