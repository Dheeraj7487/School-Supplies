import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:school_supplies_hub/add_details/auth/add_book_details_auth.dart';
import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';
import '../../utils/app_utils.dart';
import '../../widgets/textfield_widget.dart';
import '../auth/rating_auth.dart';

class GiveReviewScreen extends StatefulWidget {
  var snapshotData;
  GiveReviewScreen({Key? key,required this.snapshotData}) : super(key: key);

  @override
  State<GiveReviewScreen> createState() => _GiveReviewScreenState();
}

class _GiveReviewScreenState extends State<GiveReviewScreen> {

  TextEditingController reviewController = TextEditingController();
  bool buttonVisible = false;
  double userRating = 0;
  double rating = 0;
  int userLength = 0;
  double sum = 0.0;
  List ratingList = [];
  var bookImages = [];

  late String authorName,bookName,bookDescription,
      bookVideo,bookPrice,currentUser,
      selectedClass,selectedCourse,selectedSemester,publisherName,
      timeStamp,userId,userEmail,userMobile,timestamp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: Text(widget.snapshotData['bookName']),
        actions: [
          Visibility(
            visible: buttonVisible,
            child: TextButton(
                onPressed: () async {
                  ratingList.clear();
                  var querySnapShot = await FirebaseCollection().userCollection.
                  where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

                  var queryUserRatingSnapshots = await FirebaseCollection().userRatingCollection.
                  where('bookName',isEqualTo: widget.snapshotData['bookName']).get();

                  var queryBookSnapshots = await FirebaseCollection().addBookCollection.
                  where('bookName',isEqualTo: widget.snapshotData['bookName']).get();

                  for (var snapshot in querySnapShot.docChanges) {
                    RatingAuth().userRating(
                      bookName: widget.snapshotData['bookName'],
                      currentUser: FirebaseAuth.instance.currentUser!.email.toString(),
                      userRating: userRating,
                      userGiveExprience: reviewController.text,
                      timestamp: Timestamp.now(),
                      userName: snapshot.doc.get('userName'),
                    ).then((value) {
                      AppUtils.instance.showSnackBar(context,'Your review will be post');
                      for (var snapshot1 in queryUserRatingSnapshots.docChanges) {
                        for(int i = 0;i<1;i++){
                          userRating = snapshot1.doc.get('bookRating');
                          ratingList.add(snapshot1.doc.get('bookRating'));
                          sum = ratingList.reduce((a, b) => a + b);
                          userLength = queryUserRatingSnapshots.docs.length;
                          rating = sum/userLength;
                          debugPrint('User Rating => $sum = $userLength = $rating = $userRating');
                          break;
                        }
                      }
                      for(var bookSnapshot in queryBookSnapshots.docChanges){
                        authorName = bookSnapshot.doc.get('authorName');
                        bookDescription = bookSnapshot.doc.get('bookDescription');
                        bookImages = bookSnapshot.doc.get('bookImages');
                        bookName = bookSnapshot.doc.get('bookName');
                        bookVideo = bookSnapshot.doc.get('bookVideo');
                        currentUser = bookSnapshot.doc.get('currentUser');
                        bookPrice= bookSnapshot.doc.get('bookPrice');
                        selectedSemester= bookSnapshot.doc.get('selectedSemester');
                        publisherName= bookSnapshot.doc.get('publisherName');
                        selectedCourse= bookSnapshot.doc.get('selectedCourse');
                        selectedClass= bookSnapshot.doc.get('selectedClass');
                        userId= bookSnapshot.doc.get('userId');
                        userEmail= bookSnapshot.doc.get('userEmail');
                        timestamp= bookSnapshot.doc.get('timeStamp');
                        userMobile = bookSnapshot.doc.get('userMobile');
                        //print(bookImages);
                      }

                     // print(bookImages);
                      AddBookDetailsAuth().addBookDetails(
                          uId: userId, publisherName: publisherName,
                          userEmail: userEmail, userMobile: userMobile,
                          bookName: bookName, price: bookPrice,
                          bookImages: bookImages, bookVideo: bookVideo,
                          selectedClass: selectedClass, selectedCourse: selectedCourse,
                          selectedSemester: selectedSemester, bookRating: rating,
                          currentUser: currentUser, authorName: authorName,
                          bookDescription: bookDescription,
                          timestamp: timestamp);
                     Navigator.pop(context);
                    });
                 }
                }, child: Text('POST',style: Theme.of(context).textTheme.subtitle2,)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                      stream:  FirebaseCollection().userRatingCollection.
                      where('bookName',isEqualTo: widget.snapshotData['bookName']).
                      where('currentUser',isEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                        if(!snapshot.hasData || snapshot.requireData.docChanges.isEmpty){
                          return RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            unratedColor: AppColor.greyColor,
                            itemSize: 30,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              debugPrint('$rating');
                              setState(() {
                                userRating = 0;
                                buttonVisible = true;
                                ratingList.clear();
                                userRating = rating;
                                debugPrint('I am user Rating => $userRating');
                              });

                            },
                          );
                        }
                        else if(snapshot.hasData){
                          return RatingBar.builder(
                            initialRating: snapshot.data?.docs[0]['bookRating'],
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 30,
                            ignoreGestures: false,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) async {
                              setState(() {
                                buttonVisible = true;
                                userRating = 0;
                                ratingList.clear();
                                userRating = rating;
                                debugPrint('I am user Rating another => $userRating');
                                debugPrint('I am Firebase Rating  => ${snapshot.data?.docs[0]['bookRating']}');
                              });

                            },
                          );
                        }
                        else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFieldWidget().textFieldWidget(
                  hintText: 'Describe your Exprience (Optional)',
                  controller: reviewController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
