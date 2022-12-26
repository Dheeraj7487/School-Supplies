import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
           return const SizedBox();
        } else if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none){
           return Container(
             padding: const EdgeInsets.only(left: 20,right: 20),
             child: Shimmer.fromColors(
               highlightColor: Colors.grey,
               baseColor: Colors.white,
               child: Container(
                 padding: const EdgeInsets.only(left: 20,right: 20),
                 height: MediaQuery.of(context).size.height/3,
                 width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(10)
                 ),
                 child: const SizedBox(),
               ),
             ),
           );
         } else if(!snapshot.hasData){
           return const SizedBox();
         } else if(snapshot.hasData){
          return Visibility(
            visible: snapshot.data!.docs.length >=3 ? true : false,
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
                                  child: CachedNetworkImage(
                                    imageUrl: "${snapshot.data?.docs[index]['bookImages'][0]}",
                                    height: MediaQuery.of(context).size.height/3,
                                    width: MediaQuery.of(context).size.width,fit: BoxFit.fill,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Shimmer.fromColors(
                                          highlightColor: AppColor.appColor,
                                          baseColor: Colors.grey.shade100,
                                          period: const Duration(seconds: 2),
                                          child: SizedBox(
                                            height: MediaQuery.of(context).size.height/3,
                                            width: MediaQuery.of(context).size.width,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),


                                  /*Image.network(
                                      snapshot.data?.docs[index]['bookImages'][0],
                                      height: MediaQuery.of(context).size.height/3,
                                      width: MediaQuery.of(context).size.width,fit: BoxFit.fill)*/
                              ),
                              Positioned(
                                  bottom : MediaQuery.of(context).size.height/15,
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          color: AppColor.appColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )
                                      ),
                                      child: Text(snapshot.data?.docs[index]['name'],overflow: TextOverflow.ellipsis,)),
                              ),

                              Positioned(
                                  bottom : MediaQuery.of(context).size.height/40,
                                  left: MediaQuery.of(context).size.width/2.5,
                                  child: Row(
                                    children: List.generate(
                                      3, (index1) {
                                            return Container(
                                              margin: const EdgeInsets.all(4),
                                              width: index == index1 ? 10 : 7,
                                              height:  index == index1 ? 10 : 7,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: index == index1
                                                    ? AppColor.redColor
                                                    : Colors.white70,
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
          return const SizedBox();
        }
      }
    );
  }
}