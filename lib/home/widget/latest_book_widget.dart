import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../Firebase/firebase_collection.dart';
import '../../book_details/screen/book_details_screen.dart';
import '../../shimmers/horizontal_shimmers.dart';
import '../../utils/app_color.dart';

class LatestBookWidget extends StatelessWidget {
  const LatestBookWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20,bottom: 10,right: 20,top: 10),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "Latest ",
                    style: Theme.of(context).textTheme.headline2
                ),
                TextSpan(
                    text: "Books",
                    style: Theme.of(context).textTheme.headline4
                )
              ],
            ),
          ),
        ),
        StreamBuilder(
            stream: FirebaseCollection().addBookCollection.snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if(snapshot.hasError){
                return Center(child: HorizontalShimmers(height: 175,width: 150,));
              } else if(snapshot.hasData){
                return SizedBox(
                  height: 175,
                  child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                BookDetailScreen(snapshotData: snapshot.data?.docs[index],
                                  bookImages: snapshot.data?.docs[index]['bookImages'],)));                          },
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.only(left:20,right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(3,15,3,0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: "${snapshot.data?.docs[index]['bookImages'][0]}",
                                        height: 120,width: double.infinity,fit: BoxFit.fill,
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          highlightColor: AppColor.appColor,
                                          baseColor: Colors.grey.shade100,
                                          period: const Duration(seconds: 2),
                                          child: const SizedBox(
                                              height: 120,width: double.infinity
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Image.network("https://lh6.googleusercontent.com/Bu-pRqU_tWZV7O3rJ5nV1P6NjqFnnAs8kVLC5VGz_Kf7ws0nDUXoGTc7pP87tyUCfu8VyXi0YviIm7CxAISDr2lJSwWwXQxxz98qxVfMcKTJfLPqbcfhn-QEeOowjrlwX1LYDFJN",
                                          height: 120,width: double.infinity,fit: BoxFit.fill,),
                                      )
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Text('₹ ${snapshot.data?.docs[index]['bookPrice']}',
                                    style: const TextStyle(color: AppColor.redColor,fontSize: 16),
                                    maxLines: 1,overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                );
              } else {
                return Center(child: HorizontalShimmers(height: 175,width: 150));
              }
            }
        )
      ],
    );
  }
}
