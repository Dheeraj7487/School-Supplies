import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Firebase/firebase_collection.dart';
import '../../book_details/screen/book_details_screen.dart';
import '../../utils/app_color.dart';
import '../screen/popular_books_screen.dart';

class PopularBookWidget extends StatelessWidget {
  const PopularBookWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20,bottom: 10,right: 10,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Popular ",
                        style: Theme.of(context).textTheme.headline2
                    ),
                    TextSpan(
                        text: "Books",
                        style: Theme.of(context).textTheme.headline4
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const PopularBooksScreen()));
                },
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('See All',style: Theme.of(context).textTheme.subtitle2)),
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: FirebaseCollection().addBookCollection.snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if(snapshot.hasError){
              return const Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasData){
              return SizedBox(
                height: 170,
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              BookDetailScreen(snapshotData: snapshot.data?.docs[index],
                                bookImages: snapshot.data?.docs[index]['bookImages'],)));
                        },
                        child: Container(
                          width: 220,
                          height: 160,
                          padding: const EdgeInsets.only(left:20,right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                    child: Image.network(snapshot.data?.docs[index]['bookImages'][1],
                                        height: 120,width: double.infinity,fit: BoxFit.fill),
                                  ),
                                  Visibility(
                                    visible : snapshot.data?.docs[index]['bookRating'] != 0,
                                    child: Positioned(
                                        bottom: 10,left: 10,right: 10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(left: 5,right: 10,top: 1,bottom: 1),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  color: AppColor.darkWhiteColor
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.star,color: Colors.amber,size: 20,),
                                                  const SizedBox(width: 2),
                                                  Text('${snapshot.data?.docs[index]['bookRating']}', style: const TextStyle(fontSize: 12),)
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child:  Text(snapshot.data?.docs[index]['bookName'],
                                    style: Theme.of(context).textTheme.subtitle1,
                                    maxLines: 2,overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(height: 2),
                              Padding(
                                padding: const EdgeInsets.only(right: 10,bottom: 10),
                                child: Text('${snapshot.data?.docs[index]['selectedCourse']}  |  ${snapshot.data?.docs[index]['selectedClass']}',
                                    style: Theme.of(context).textTheme.subtitle2,
                                    textAlign:TextAlign.start,maxLines: 2,overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        )
      ],
    );
  }
}
