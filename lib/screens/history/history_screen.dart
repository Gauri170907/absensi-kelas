import 'package:absensi/data/models/history_response.dart';
import 'package:absensi/provider/history_provider.dart';
import 'package:absensi/utils/constant_number.dart';
import 'package:absensi/utils/constant_text_theme.dart';
import 'package:absensi/utils/request_state.dart';
import 'package:absensi/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HistoryProvider>(context, listen: false);
      // context.read<HomeProvider>().getAbsenToday(context);
    });
    Future.microtask(() => Provider.of<HistoryProvider>(context, listen: false)
        .getNik()
        .then((_) => context.read<HistoryProvider>().getAbsen().then(
            (response) => context
                .read<HistoryProvider>()
                .getAbsenMonthly(context, response))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Riwayat Absen',
          style: myTextTheme.headlineMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: Consumer<HistoryProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Absen Bulan Ini',
                style: myTextTheme.titleLarge!.apply(color: Colors.blueAccent),
              ),
              sizedBoxH16,
              const Divider(
                height: 1,
                color: Colors.black,
              ),
              sizedBoxH16,
              provider.state == RequestState.loading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : provider.state == RequestState.loaded
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: provider.historyItem?.length,
                              itemBuilder: (context, index) {
                                return cardItem(provider.historyItem![index]);
                              }),
                        )
                      : const Expanded(
                          child: Center(
                            child: Text('Tidak ada data absen bulan ini'),
                          ),
                        ),

              // ListView.builder(itemBuilder: itemBuilder);
            ],
          ),
        );
      }),
    );
  }

  Container cardItem(Datum datum) {
    return Container(
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
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Text(
              // datum.attendanceDate.toString(),
              TimeUtils().formatTglIndo(
                  DateFormat('yyyy-MM-dd').format(datum.attendanceDate!)),
              style: myTextTheme.titleLarge!.apply(color: Colors.blueAccent),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Absen Masuk',
                      style: myTextTheme.titleMedium,
                    ),
                    sizedBoxH8,
                    Text(datum.datang?.time ?? '-',
                        style: myTextTheme.titleLarge!.apply(
                          color: Colors.blueAccent,
                        )),
                  ],
                ),
                const VerticalDivider(
                  thickness: 3.0,
                ),
                Column(
                  children: [
                    Text(
                      'Absen Pulang',
                      style: myTextTheme.titleMedium,
                    ),
                    sizedBoxH8,
                    Text((datum.pulang?.time) ?? '-',
                        style: myTextTheme.titleLarge!.apply(
                          color: Colors.blueAccent,
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
