import 'package:absensi/data/Local/preferences.dart';
import 'package:absensi/data/Local/repository.dart';
import 'package:absensi/provider/absen_provider.dart';
import 'package:absensi/provider/history_provider.dart';
import 'package:absensi/provider/home_provider.dart';
import 'package:absensi/provider/login_provider.dart';
import 'package:absensi/provider/splash_provider.dart';
import 'package:absensi/utils/constant_text_theme.dart';
import 'package:absensi/utils/route.dart';
import 'package:absensi/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;

import 'data/API/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  tz.initializeTimeZones();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SplashProvider(preferences: Preferences())),
        ChangeNotifierProvider(
            create: (_) => LoginProvider(
                apiService: ApiService(client: http.Client()),
                repository: Repository(),
                preferences: Preferences())),
        ChangeNotifierProvider(
            create: (_) => HomeProvider(
                  preferences: Preferences(),
                  apiService: ApiService(client: http.Client()),
                  repository: Repository(),
                  // repository: Repository(),
                )),
        ChangeNotifierProvider(
            create: (_) => HistoryProvider(
                apiService: ApiService(client: http.Client()),
                preferences: Preferences(),
                repository: Repository())),
        ChangeNotifierProvider(
            create: (_) => AbsenProvider(
                  apiService: ApiService(client: http.Client()),
                  preferences: Preferences(),
                  repository: Repository(),
                )),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: myTextTheme,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: Pages.routes,
        initialRoute: Pages.initialRoute,
      ),
    );
  }
}
