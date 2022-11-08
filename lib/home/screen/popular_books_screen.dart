import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:school_supplies_hub/Firebase/firebase_collection.dart';
import 'package:school_supplies_hub/utils/app_color.dart';
import 'package:school_supplies_hub/video_player/video_player_screen.dart';

class PopularBooksScreen extends StatelessWidget {
  const PopularBooksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      body: StreamBuilder(
        stream: FirebaseCollection().addBookCollection.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){},
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
                              height: 90,width: 70,fit: BoxFit.fill,),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20,top: 10,left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(snapshot.data?.docs[index]['bookName'],
                                            style: Theme.of(context).textTheme.headline4,maxLines: 1,overflow: TextOverflow.ellipsis),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                        decoration: BoxDecoration(
                                          //color: AppColor.darkGreen,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Text('\$ ${snapshot.data?.docs[index]['bookPrice']}',
                                            style: Theme.of(context).textTheme.headline5,maxLines: 1,overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),

                                  Text('${snapshot.data?.docs[index]['selectedCourse']} | ${snapshot.data?.docs[index]['selectedClass']}',
                                    style: Theme.of(context).textTheme.headline6,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                  // const SizedBox(height: 5),
                                  // const Text('snapshot.data?.docs[index]bookDescription',
                                  //   style: TextStyle(fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                  //const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating: double.parse('${snapshot.data?.docs[index]['bookRating']}'),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
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
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=>VideoPlayerScreen(imageUrl: snapshot.data?.docs[index]['bookVideo'])));
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(10.0,5,10,5),
                                          child: Icon(Icons.play_arrow,color: AppColor.whiteColor,size: 22,),
                                        ))
                                    ],
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
            return const Center(child: CircularProgressIndicator(),);
          }
        }
      )
    );
  }
}
