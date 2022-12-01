import 'package:flutter/material.dart';
import '../utils/app_color.dart';
class Background extends StatelessWidget {

  final Widget child;
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(child: child),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.center,
                colors: [
                  AppColor.greyColor.withOpacity(0.2),
                  AppColor.whiteColor.withOpacity(0),
                ],
                //stops: [0, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget noInternetDialog({Function? onTap}) {
Widget noInternetDialog() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: const [
      Icon(
        Icons.wifi_off,
        color: AppColor.whiteColor,
        size: 60,
      ),
      Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "There is no Internet connection Please check Your Internet connection",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.whiteColor, fontSize: 14),
        ),
      ),

    ],
  );
}

