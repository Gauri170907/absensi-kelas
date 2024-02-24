import 'package:absensi/screens/absen/absen_screen.dart';
import 'package:absensi/screens/history/history_screen.dart';
import 'package:absensi/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/splash_screen.dart';

class Pages {
  static const initialRoute = '/';

  static Map<String, WidgetBuilder> routes = {
    RoutesName.splashRoute: (context) => const SplashScreen(),
    RoutesName.loginRoute: (context) => const LoginScreen(),
    RoutesName.homeRoute: (context) => const HomeScreen(),
    RoutesName.absenRoute: (context) => const AbsenScreen(jenis: ''),
    RoutesName.historyRoute: (context) => const HistoryScreen(),
  };
}

abstract class RoutesName {
  static const splashRoute = Paths.splashPath;
  static const loginRoute = Paths.loginPath;
  static const homeRoute = Paths.homePath;
  static const absenRoute = Paths.absenPath;
  static const historyRoute = Paths.historyPath;
}

abstract class Paths {
  static const splashPath = '/';
  static const loginPath = '/login';
  static const homePath = '/home';
  static const absenPath = '/absen';
  static const historyPath = '/history';
}
