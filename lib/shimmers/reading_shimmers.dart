import 'package:flutter/material.dart';
import 'package:school_supplies_hub/utils/app_color.dart';
import 'package:shimmer/shimmer.dart';

class ReadingShimmers extends StatelessWidget {
  const ReadingShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: AppColor.appColor,
      baseColor: Colors.grey.shade100,
      period: const Duration(seconds: 2),
      child: SizedBox(
        height: 170,
        child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            primary: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 10),
                width: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(30)),
                ),
                child: const Card(),
              );
            }
        ),
      ),
    );
  }
}
