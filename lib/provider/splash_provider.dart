import 'package:absensi/provider/utils/disposable_provider.dart';
import 'package:absensi/screens/login_screen.dart';
import 'package:absensi/utils/custom_page_route.dart';
import 'package:flutter/material.dart';

import '../data/Local/preferences.dart';
import '../screens/home/home_screen.dart';

class SplashProvider extends DisposableProvider {
  Preferences preferences;
  SplashProvider({required this.preferences});

  // Future<void> askPermission() async {
  //   try {
  //     final PermissionStatus locationPerms =
  //         await Permission.locationWhenInUse.status;
  //     if (locationPerms != PermissionStatus.granted) {
  //       await Permission.locationWhenInUse.request();
  //     }

  //     final PermissionStatus cameraPerms = await Permission.camera.status;
  //     if (cameraPerms != PermissionStatus.granted) {
  //       await Permission.camera.request();
  //     }

  //     final PermissionStatus storagePerms = await Permission.storage.status;
  //     if (storagePerms != PermissionStatus.granted) {
  //       await Permission.storage.request();
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // Future<void> checkGps(BuildContext context) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await location.Location().serviceEnabled();
  //   if (!serviceEnabled) {
  //     if (context.mounted) {
  //       showDialog(
  //           barrierDismissible: false,
  //           useRootNavigator: true,
  //           context: context,
  //           builder: (BuildContext context) {
  //             return CustomDialogBoxWithButton(
  //               title: 'Perhatian',
  //               descriptions:
  //                   'Tidak dapat mendeteksi lokasi saat ini! Pastikan GPS sudah aktif dan coba lagi!',
  //               text: 'Coba lagi!',
  //               onPressed: () async {
  //                 permission = await Geolocator.checkPermission();
  //                 if (permission == LocationPermission.denied) {
  //                   await Permission.locationWhenInUse.request();
  //                   permission = await Geolocator.requestPermission();
  //                 }
  //                 serviceEnabled = await location.Location().requestService();
  //                 if (serviceEnabled) {
  //                   if (context.mounted) {
  //                     Navigator.pop(context);
  //                     nextScreen(context);
  //                   }
  //                 } else {
  //                   if (context.mounted) {
  //                     Navigator.pop(context);
  //                     checkGps(context);
  //                   }
  //                 }
  //                 // if (context.mounted) {
  //                 // }
  //                 // else {
  //                 // }
  //               },
  //             );
  //           });
  //     }
  //   } else {
  //     // print('test');
  //     if (context.mounted) nextScreen(context);
  //   }
  // }

  void nextScreen(context) async {
    var isLoggedIn = await preferences.isLoggedIn();
    if (isLoggedIn!) {
      Future.delayed(const Duration(seconds: 2))
          .then((_) => goToHomeScreen(context));
    } else {
      Future.delayed(const Duration(seconds: 2))
          .then((_) => goToLoginScreen(context));
    }
  }

  void goToLoginScreen(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement(CustomPageRoute(
          direction: AxisDirection.right, child: const LoginScreen()));
    }
  }

  void goToHomeScreen(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement(CustomPageRoute(
          direction: AxisDirection.down, child: const HomeScreen()));
    }
  }

  @override
  void disposeValues() {}
}
