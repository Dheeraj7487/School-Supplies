import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Firebase/firebase_collection.dart';
import '../../book_details/screen/book_details_screen.dart';
import '../../shimmers/reading_shimmers.dart';
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
                return const Center(child: ReadingShimmers());
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
                                Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network('https://png.pngtree.com/element_our/20190530/ourlarge/pngtree-e-commerce-fluid-gradient-border-image_1250921.jpg',
                                            height: 150)),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(3,15,3,0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(snapshot.data?.docs[index]['bookImages'][0],
                                            height: 120,width: double.infinity,fit: BoxFit.fill),
                                      ),
                                    ),
                                  ],
                                ),
                                Text('\$ ${snapshot.data?.docs[index]['bookPrice']}',
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
                return const Center(child: ReadingShimmers());
              }
            }
        )
      ],
    );
  }
}
