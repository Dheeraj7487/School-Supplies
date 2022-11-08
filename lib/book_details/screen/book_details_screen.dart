import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Firebase/firebase_collection.dart';
import '../../payment/payment_screen.dart';
import '../../utils/app_color.dart';
import '../../video_player/video_player_screen.dart';
import 'give_rating_screen.dart';

//ignore: must_be_immutable
class BookDetailScreen extends StatefulWidget {
  dynamic snapshotData;
  List bookImages;

  BookDetailScreen({Key? key,required this.snapshotData,required this.bookImages}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {

  int bookIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: Text(widget.snapshotData['bookName']),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    const Icon(Icons.rate_review_outlined,color: AppColor.whiteColor,size: 20),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Review",style: Theme.of(context).textTheme.subtitle1)
                  ],
                ),
              ),
            ],
            offset: const Offset(0, 37),
           // icon: Image.asset(AppImage.menu,height: 20,width: 17,color: AppColor.whiteColor,),
            color: AppColor.appColor,
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GiveReviewScreen(snapshotData: widget.snapshotData,)));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius:  BorderRadius.circular(10),
                          child: Image.network(widget.snapshotData['bookImages'][bookIndex],
                              height: MediaQuery.of(context).size.height/4,
                              width: MediaQuery.of(context).size.width/3,fit: BoxFit.fill)),
                    ],
                  )
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                      itemCount: widget.bookImages.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,int index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              bookIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 3,
                                  color: AppColor.greyColor,
                                )
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(widget.bookImages[index],
                                      height: MediaQuery.of(context).size.height/4,
                                      width: 50,fit: BoxFit.fill)),
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(widget.snapshotData['bookName'],style: Theme.of(context).textTheme.headline2),
              const SizedBox(height: 10),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: AppColor.redColor,fontSize: 24),
                      children: [
                        const TextSpan(text: "₹ "),
                        TextSpan(
                            text: "${widget.snapshotData['bookPrice']}",
                            style: const TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>VideoPlayerScreen(imageUrl: widget.snapshotData['bookVideo'])));
                      },
                      child:  Container(
                        padding: const EdgeInsets.fromLTRB(10.0,5,10,5),
                        decoration: BoxDecoration(
                          color: AppColor.greyColor,
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: const Icon(Icons.play_arrow,color: AppColor.whiteColor,size: 22,),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Text('Author : ${widget.snapshotData['authorName']}'),
              const SizedBox(height: 5),
               Text('Class : ${widget.snapshotData['selectedClass']}'),
              const SizedBox(height: 5),
               Text('Book Type : ${widget.snapshotData['selectedCourse']}'),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColor.greyColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children:  const [
                        Icon(Icons.book_outlined,color: AppColor.whiteColor),
                        SizedBox(height: 5,),
                        Text('Rarely Used\n Condition',textAlign: TextAlign.center,)
                      ],
                    ),
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColor.greyColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.date_range,color: AppColor.whiteColor),
                        const SizedBox(height: 5,),
                        Text('Posted On\n ${DateFormat('dd MMM').format(DateTime.parse(widget.snapshotData['timeStamp']))}',textAlign: TextAlign.center,)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                //    color: AppColor.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColor.greyColor
                  ),

                ),
                child: Row(
                  children: [
                    Container(
                        width: 55,
                        height: 55,
                      padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColor.greyColor,
                        ),
                        child: Center(child: Text(widget.snapshotData['publisherName'].toString().substring(0,1),
                        style: const TextStyle(fontSize: 18),))),
                    const SizedBox(width: 20,),

                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Posted By\n",style: Theme.of(context).textTheme.subtitle1),
                          TextSpan(
                              text: "${widget.snapshotData['publisherName']}",
                              style: Theme.of(context).textTheme.headline2)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text('Description',style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 5),
              Text(widget.snapshotData['bookDescription'],
                style: const TextStyle(fontSize: 12,color: AppColor.greyColor)),
              const SizedBox(height: 20),
              Text('Related Books',style: Theme.of(context).textTheme.headline4,),
              const SizedBox(height: 5),
              StreamBuilder(
                  stream: FirebaseCollection().addBookCollection.
                  // where('bookName',isNotEqualTo: widget.snapshotData['bookName'])
                  where('selectedCourse',isEqualTo: widget.snapshotData['selectedCourse'])
                      .snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else if (snapshot.hasError) {
                      return const SizedBox();
                    } else if (!snapshot.hasData) {
                      return  const SizedBox();
                    } else if (snapshot.requireData.docChanges.isEmpty){
                      return const SizedBox();
                    } else if(snapshot.hasData){
                      return SizedBox(
                        height: 180,
                        child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                                      BookDetailScreen(snapshotData: snapshot.data?.docs[index], bookImages: snapshot.data!.docs[index]['bookImages'],)));
                                },
                                child: Container(
                                  width: 150,
                                  height: 180,
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Card(
                                    elevation: 5,
                                    color: AppColor.appColor,
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                          child: Image.network(snapshot.data!.docs[index]['bookImages'][0],
                                              height: 120,width: double.infinity,fit: BoxFit.fill),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(snapshot.data!.docs[index]['bookName'],
                                            style: Theme.of(context).textTheme.headline4,textAlign:TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      );
                    } else{
                      return const CircularProgressIndicator();
                    }
                  }
              ),

              const SizedBox(height: 20),
              Text('Similar Class',style: Theme.of(context).textTheme.headline4,),
              const SizedBox(height: 5),
              StreamBuilder(
                  stream: FirebaseCollection().addBookCollection.
                  //where('bookName',isNotEqualTo: widget.snapshotData['bookName']).
                  where('selectedClass',isEqualTo: widget.snapshotData['selectedClass']).snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else if (snapshot.hasError) {
                      return const SizedBox();
                    } else if (!snapshot.hasData) {
                      return  const SizedBox();
                    } else if (snapshot.requireData.docChanges.isEmpty){
                      return const SizedBox();
                    } else if(snapshot.hasData){
                      return SizedBox(
                        height: 180,
                        child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context,index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                                      BookDetailScreen(snapshotData: snapshot.data?.docs[index], bookImages: snapshot.data!.docs[index]['bookImages'],)));                                },
                                child: Container(
                                  width: 150,
                                  height: 180,
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Card(
                                    elevation: 5,
                                    color: AppColor.appColor,
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                          child: Image.network(snapshot.data!.docs[index]['bookImages'][1],
                                              height: 120,width: double.infinity,fit: BoxFit.fill),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(snapshot.data!.docs[index]['bookName'],
                                            style: Theme.of(context).textTheme.headline4,textAlign:TextAlign.center,maxLines: 2,overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      );
                    } else{
                      return const CircularProgressIndicator();
                    }
                  }
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const GooglePay()));
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen()));
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          color: AppColor.whiteColor,
          child: const Text('Buy Now',style: TextStyle(color: AppColor.appColor,fontSize: 16), textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
