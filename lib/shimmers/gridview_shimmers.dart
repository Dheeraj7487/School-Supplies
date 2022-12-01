import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_color.dart';
import '../widgets/responsive_widget.dart';
class GridViewShimmers extends StatelessWidget {
  const GridViewShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: AppColor.appColor,
      baseColor: Colors.grey.shade100,
      period: const Duration(seconds: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 2 : 4,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
            mainAxisExtent: 150
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.only(left: 5.0,right: 5),
            child: Card(),
          );
        },
      ),
    );
  }
}
