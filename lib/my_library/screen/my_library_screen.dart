import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:school_supplies_hub/book_details/screen/book_details_screen.dart';

import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.appColor,
        appBar: AppBar(
          title: const Text('My Library'),
        ),
        body:  StreamBuilder(
            stream: FirebaseCollection().addBookCollection.where('currentUser',isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No Book Available"));
              } else if (snapshot.requireData.docChanges.isEmpty){
                return  const Center(child: Text("No Book Available"));
              } else if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetailScreen(snapshotData: snapshot.data?.docs[index], bookImages: snapshot.data?.docs[index]['bookImages'])));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 10,right: 10,top: 15),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.network(snapshot.data?.docs[index]['bookImages'][0],
                                  height: 90,width: 80,fit: BoxFit.fill,),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20,top: 10,left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text(snapshot.data?.docs[index]['bookName'],
                                          style : const TextStyle(color: AppColor.whiteColor,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 5),
                                      Text(snapshot.data?.docs[index]['bookDescription'],
                                        style: const TextStyle(color: AppColor.whiteColor,fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                      const SizedBox(height: 5),
                                      RatingBar.builder(
                                        initialRating: double.parse("${snapshot.data?.docs[index]['bookRating']}"),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        unratedColor: AppColor.whiteColor.withOpacity(0.5),
                                        ignoreGestures : true,
                                        itemSize: 10,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          debugPrint('$rating');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }
        )
    );
  }
}
