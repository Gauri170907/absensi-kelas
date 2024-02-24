import 'package:absensi/utils/constant_colors.dart';
import 'package:absensi/utils/constant_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialogBoxWithButton extends StatelessWidget {
  final String title, descriptions, text;
  // final Image img;
  final Function()? onPressed;

  const CustomDialogBoxWithButton({
    super.key,
    required this.title,
    required this.descriptions,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
      margin: EdgeInsets.only(top: 48.w),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                offset: const Offset(0, 10),
                blurRadius: 10.h),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/logo.png"),
          SizedBox(
            height: 24.h,
          ),
          Text(
            title,
            style: myTextTheme.titleLarge!
                .copyWith(fontSize: 24.sp)
                .copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            descriptions,
            style: myTextTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.h,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: blueApp,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)))),
              child: Text(
                text,
                style: myTextTheme.bodyLarge,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialogLoading extends StatelessWidget {
  final String text;

  const CustomDialogLoading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
      margin: EdgeInsets.only(top: 48.w),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                offset: const Offset(0, 10),
                blurRadius: 10.h),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/logo.png"),
          SizedBox(
            height: 24.h,
          ),
          Text(
            text,
            style: myTextTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.h,
          ),
          const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
