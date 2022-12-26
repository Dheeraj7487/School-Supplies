import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_supplies_hub/book_details/screen/book_details_screen.dart';
import 'package:school_supplies_hub/book_details/screen/geometry_box_details_screen.dart';
import 'package:school_supplies_hub/firebase/firebase_collection.dart';
import 'package:school_supplies_hub/utils/app_color.dart';

class FavoriteDetailsScreen extends StatelessWidget {
  const FavoriteDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: StreamBuilder(
        stream: FirebaseCollection().favoriteCollection.where('currentUser',
            isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (snapshot.requireData.docChanges.isEmpty || !snapshot.hasData) {
            return const Center(child: Text("No Favorite Item"));
          } else if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      snapshot.data?.docs[index]['toolImages'] == '' ?
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          BookDetailScreen(snapshotData: snapshot.data?.docs[index], bookImages: snapshot.data?.docs[index]['bookImages'],))) :
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          GeometryBoxDetailScreen(snapshotData: snapshot.data?.docs[index])));
                    }, child: Container(
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
                            child: Image.network(
                              snapshot.data?.docs[index]['toolImages'] != "" ?
                              snapshot.data?.docs[index]['toolImages'] :
                              snapshot.data?.docs[index]['bookImages'][0],
                              height: 90,width: 80,fit: BoxFit.fill,),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20,top: 10,left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  Text(snapshot.data?.docs[index]['name'],
                                      style : const TextStyle(color: AppColor.whiteColor,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 5),
                                  Text(snapshot.data?.docs[index]['description'],
                                    style: const TextStyle(color: AppColor.whiteColor,fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                  const SizedBox(height: 5),

                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: AppColor.redColor, fontSize: 24),
                                      children: [
                                        const TextSpan(text: "₹ "),
                                        TextSpan(
                                            text: '${snapshot.data?.docs[index]['price']}',
                                            style: const TextStyle(fontSize: 18))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height : 5)
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
            return const Center(child: Text("No Data Available"));
          }}
      ),
    );
  }
}
