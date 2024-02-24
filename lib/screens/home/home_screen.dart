import 'dart:async';

import 'package:absensi/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../provider/home_provider.dart';
import '../../utils/constant_number.dart';
import '../../utils/constant_text_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 2)).then((value) {
    //   Future.microtask(() => Provider.of<HomeProvider>(context, listen: false)
    //     ..getTime()
    //     ..getTimer()
    //     ..getUser());
    // }).then((value) => Future.microtask(() =>
    //     Provider.of<HomeProvider>(context, listen: false)
    //         .getAbsenToday(context)));

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<HomeProvider>(context, listen: false);
    //   // context.read<HomeProvider>().getAbsenToday(context);
    // });
    Future.delayed(Duration.zero).then((_) => Future.microtask(() =>
        Provider.of<HomeProvider>(context, listen: false)
            .getUser()
            .then((_) => context.read<HomeProvider>().getAbsenToday(context))));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.history,
                  color: Colors.white,
                ),
                onPressed: () {
                  provider.goToHistoryScreen(context);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  provider.logout(context).then(
                      (response) => provider.afterLogout(context, response));
                  // provider.goToLoginScreen(context);
                },
              ),
            ],
            leadingWidth: Get.width * 0.25),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.size.width,
                height: Get.size.height * 0.3,
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 5),
                        blurRadius: 10.0,
                      )
                    ],
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0))),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: Get.height * 0.05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.h))),
                            child: Image.asset('assets/images/logo.png'),
                          ),
                          sizedBoxH20,
                          Text(
                            'Sistem Absensi Pegawai',
                            style: myTextTheme.titleLarge!
                                .apply(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: Get.height * 0.25,
                      left: 20.0,
                      right: 20.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 15.0,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: Get.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: Column(
                                  children: [
                                    Text(
                                      '${provider.time} WIB',
                                      style: myTextTheme.headlineLarge!
                                          .copyWith(
                                              color: Colors.blue,
                                              letterSpacing: 2.0),
                                    ),
                                    sizedBoxH10,
                                    Text(
                                      context.watch<HomeProvider>().date,
                                      style: myTextTheme.headlineSmall,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.h),
                margin: EdgeInsets.only(
                    left: 20.h, right: 20.h, top: Get.height * 0.1),
                // height: Get.height * 0.2,
                width: Get.size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 15.0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Data Diri',
                      style: myTextTheme.titleLarge!
                          .apply(color: Colors.blueAccent),
                    ),
                    sizedBoxH8,
                    userData('Nama', provider.user?.name ?? ''),
                    sizedBoxH8,
                    userData('NIK', provider.user?.employeeNik ?? ''),
                    sizedBoxH8,
                    userData('Email', provider.user?.email ?? ''),
                    sizedBoxH8,
                    userData('Status', provider.user?.statusKaryawan ?? ''),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(16.h),
                padding: EdgeInsets.all(16.h),
                // margin: EdgeInsets.only(top: Get.height * 0.1),
                // height: Get.height * 0.2,
                width: Get.size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 15.0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Absen Masuk',
                              style: myTextTheme.titleMedium,
                            ),
                            sizedBoxH8,
                            Text(
                                provider.state == RequestState.loaded
                                    ? provider.absenMasuk
                                    : '-',
                                style: myTextTheme.titleLarge!.apply(
                                  color: Colors.blueAccent,
                                )),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Absen Pulang',
                              style: myTextTheme.titleMedium,
                            ),
                            sizedBoxH8,
                            Text(
                                provider.state == RequestState.loaded
                                    ? provider.absenKeluar
                                    : '-',
                                style: myTextTheme.titleLarge!.apply(
                                  color: Colors.blueAccent,
                                )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: Get.size.width,
                margin: EdgeInsets.only(left: 20.h, right: 20.h, top: 20.h),
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                child: Column(
                  children: [
                    // Container(
                    //   height: 50.h,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    //   ),
                    //   child: InkWell(
                    //     onTap: () =>
                    //         provider.goToAbsenScreen(context, 'DATANG'),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         sizedBoxW10,
                    //         Text(
                    //           'Absen Masuk',
                    //           style: myTextTheme.bodyLarge!.apply(
                    //               color: const Color.fromRGBO(68, 138, 255, 1)),
                    //         ),
                    //         SvgPicture.asset(
                    //           'assets/images/masuk.svg',
                    //           height: 40.h,
                    //         ),
                    //         sizedBoxW10
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Card(
                      child: InkWell(
                        onTap: () =>
                            provider.goToAbsenScreen(context, 'DATANG'),
                        child: Padding(
                          padding: EdgeInsets.all(16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sizedBoxW10,
                              Text(
                                'Absen Masuk',
                                style: myTextTheme.bodyLarge!.apply(
                                    color:
                                        const Color.fromRGBO(68, 138, 255, 1)),
                              ),
                              SvgPicture.asset(
                                'assets/images/masuk.svg',
                                height: 40.h,
                              ),
                              sizedBoxW10
                            ],
                          ),
                        ),
                      ),
                    ),
                    sizedBoxH10,
                    Card(
                      child: InkWell(
                        onTap: () =>
                            provider.goToAbsenScreen(context, 'PULANG'),
                        child: Padding(
                          padding: EdgeInsets.all(16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              sizedBoxW10,
                              Text(
                                'Absen Pulang',
                                style: myTextTheme.bodyLarge!.apply(
                                    color:
                                        const Color.fromRGBO(68, 138, 255, 1)),
                              ),
                              SvgPicture.asset(
                                'assets/images/pulang.svg',
                                height: 40.h,
                              ),
                              sizedBoxW10,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sizedBoxH20
            ],
          ),
        ),
      );
    });
  }

  Row userData(
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.h,
          child: Text(
            label,
            style: myTextTheme.bodyLarge,
          ),
        ),
        SizedBox(width: 32.h, child: Text(':', style: myTextTheme.bodyLarge)),
        Text(
          value,
          style: myTextTheme.bodyLarge!.apply(color: Colors.blueAccent),
          maxLines: 3,
          softWrap: true,
        )
      ],
    );
  }
}
