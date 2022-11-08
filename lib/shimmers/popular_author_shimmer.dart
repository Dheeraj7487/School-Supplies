import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_image.dart';

class PopularAuthorShimmers extends StatelessWidget {
  const PopularAuthorShimmers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 10),
      child: ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.white,
              child: SizedBox(
                width: 80,
                height: 100,
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(AppImage.oldBook,
                        height: 60,width: 60,fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
