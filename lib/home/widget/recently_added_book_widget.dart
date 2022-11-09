import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';

class RecentlyAddedBookSliderWidget extends StatelessWidget {
  const RecentlyAddedBookSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseCollection().addBookCollection.
      orderBy('timeStamp',descending: true).snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if(snapshot.hasError){
          return const CircularProgressIndicator();
        } else if(snapshot.hasData){
          return Visibility(
            visible: snapshot.data!.docChanges.length >=3 ? true : false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Recently ",
                            style: Theme.of(context).textTheme.headline2
                        ),
                        TextSpan(
                            text: "Added",
                          style: Theme.of(context).textTheme.headline4
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        autoPlay: true,
                        reverse: false,
                        viewportFraction: 1,
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                      itemCount:  3,
                      itemBuilder: (context, index, int realIndex) {
                        return Container(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                      snapshot.data?.docs[index]['bookImages'][0],
                                      height: MediaQuery.of(context).size.height/3,
                                      width: MediaQuery.of(context).size.width,fit: BoxFit.fill)),
                              Positioned(
                                  bottom : 30,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          color: AppColor.appColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )
                                      ),
                                      child: Text(snapshot.data?.docs[index]['bookName'], style: const TextStyle(color: AppColor.whiteColor),))
                              ),

                              Positioned(
                                  bottom : 10,right: 20,
                                  child: Row(
                                    children: List.generate(
                                      3, (index1) {
                                            return Container(
                                              margin: const EdgeInsets.all(4),
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: index == index1
                                                    ? AppColor.redColor
                                                    : AppColor.appColor,
                                                shape: BoxShape.rectangle,
                                              ),
                                            );
                                          }
                                    ),
                                  )
                              )
                            ],
                          ),
                        );
                      },
                    )
                ),
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }
}