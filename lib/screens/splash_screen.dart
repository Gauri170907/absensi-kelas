import 'package:absensi/provider/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3)).then((_) =>
        Provider.of<SplashProvider>(context, listen: false)
            .nextScreen(context));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, provider, _) {
      return Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
          Color(0xFF6B8EEF),
          Color(0xFF0C2979),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.h)),
                      ),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    // Image.asset(
                    //   'assets/images/logo.png',
                    //   width: Get.width * 0.3,
                    // ),
                    SizedBox(
                      height: 4.h,
                    ),
                    const Text(
                      'SiAP',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SpinKitFadingCircle(
                      color: Colors.white,
                      size: 35.0,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(),
                        Text('SiAP HPS',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        SizedBox(width: 2.0),
                        Text('v1.0.0', style: TextStyle(color: Colors.white)),
                        Spacer()
                      ],
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
