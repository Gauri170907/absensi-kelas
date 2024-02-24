import 'dart:async';

import 'package:absensi/provider/absen_provider.dart';
import 'package:absensi/utils/constant_text_theme.dart';
import 'package:absensi/utils/request_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AbsenScreen extends StatefulWidget {
  final String jenis;
  const AbsenScreen({required this.jenis, super.key});

  @override
  State<AbsenScreen> createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  @override
  Widget build(BuildContext context) {
    return Consumer<AbsenProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            'Absen ${widget.jenis}',
            style: myTextTheme.headlineMedium,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: Get.size.height / 2,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: Set<Marker>.of(provider.markers),
                myLocationEnabled: true,
                compassEnabled: true,
                initialCameraPosition: provider.mapInitialPosition,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue[700]!,
                              Colors.lightBlue[900]!
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            // provider.checkGps(context).then((_) {
                            //   provider.absen(context, widget.jenis);
                            // });
                            if (_mapController.isCompleted) {
                              provider.serviceEnabled
                                  ? provider.absen(context, widget.jenis).then(
                                      (response) => provider.afterAbsen(
                                          context, response))
                                  : provider.checkGps(context).then((value) =>
                                      provider.absen(context, widget.jenis));
                            }
                            // provider
                            //     .absen(context, widget.jenis)
                            //     .then((value) => print(value));
                          },
                          child: Center(
                            child: provider.state == RequestState.loading
                                ? const SizedBox(
                                    height: 30.0,
                                    width: 30.0,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'ABSEN ${widget.jenis} ',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.future;
  }
}
