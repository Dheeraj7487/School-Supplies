import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/add_details/auth/add_book_details_auth.dart';
import '../../Firebase/firebase_collection.dart';
import '../../home/provider/internet_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_utils.dart';
import '../../widgets/textfield_widget.dart';
import '../auth/rating_auth.dart';

class GiveReviewScreen extends StatefulWidget {
  var snapshotData;
  GiveReviewScreen({Key? key, required this.snapshotData}) : super(key: key);

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

  late String authorName, bookName, bookDescription,
      bookVideo, bookPrice, currentUser,
      selectedClass, selectedCourse, selectedSemester,
      publisherName, timeStamp, userId,
      userEmail, userMobile, timestamp;

  late int discountPercentage, bookAvailable;

  giveRating() async{
    ratingList.clear();
    var querySnapShot = await FirebaseCollection().userCollection
        .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

    var queryUserRatingSnapshots = await FirebaseCollection().userRatingCollection
        .where('bookName', isEqualTo: widget.snapshotData['bookName']).get();

    var queryBookSnapshots = await FirebaseCollection().addBookCollection
        .where('bookName', isEqualTo: widget.snapshotData['bookName']).get();

    for (var snapshot in querySnapShot.docChanges) {
      RatingAuth().userRating(
        bookName: widget.snapshotData['bookName'],
        currentUser: FirebaseAuth.instance.currentUser!.email.toString(),
        userRating: userRating,
        userGiveExprience: reviewController.text,
        timestamp: Timestamp.now(),
        userName: snapshot.doc.get('userName'),
      ).then((value) {
        AppUtils.instance.showSnackBar(context, 'Your review will be post');

        if (queryUserRatingSnapshots.docChanges.isEmpty) {
          ratingList.add(userRating);
          sum = ratingList.reduce((a, b) => a + b);
          userLength = ratingList.length;
          rating = sum / userLength;
          debugPrint('Inside Empty User Rating => $ratingList === $sum = $userLength = $rating = $userRating');
        }
        for (var snapshot1 in queryUserRatingSnapshots.docChanges) {
          for (int i=0; i < 1; i++) {
            if (snapshot1.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email) {
              ratingList.add(userRating);
              sum = ratingList.reduce((a, b) => a + b);
              userLength = queryUserRatingSnapshots.docs.length;
              rating = sum / userLength;
              debugPrint('Inside One and Fetch User  || User Rating => $ratingList === $sum = $userLength = $rating = $userRating');
              break;
            }

            /*else {
                                ratingList.add(userRating);
                                sum = ratingList.reduce((a, b) => a + b);
                                userLength = queryUserRatingSnapshots.docs.length;
                                rating = sum / userLength;
                                debugPrint('Else If User Rating => $ratingList === $sum = $userLength = $rating = $userRating');
                                print('i val $i');
                                break;
                              }*/

            /* else if(queryUserRatingSnapshots.docs.length == userLength){
                                ratingList.add(userRating);
                                sum = ratingList.reduce((a, b) => a + b);
                                userLength = queryUserRatingSnapshots.docs.length;
                                rating = sum / userLength;
                                debugPrint('Else If User Rating => $ratingList === $sum = $userLength = $rating = $userRating');
                              }*/

            else {
              ratingList.add(snapshot1.doc.get('bookRating'));
              sum = ratingList.reduce((a, b) => a + b);
              userLength = queryUserRatingSnapshots.docs.length;
              rating = sum / userLength;
              debugPrint('Else User Rating => $ratingList === $sum = $userLength = $rating = $userRating');
              break;
              /*if (snapshot1.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email) {
                                  //   userRating = snapshot1.doc.get('bookRating');
                                  ratingList.add(userRating);
                                  sum = ratingList.reduce((a, b) => a + b);
                                  userLength = queryUserRatingSnapshots.docs.length;
                                  rating = sum / userLength;
                                  debugPrint('Else (If) User Rating => $ratingList === $sum = $userLength = $rating = $userRating');
                                  break;
                                }
                                else {
                                  //userRating = snapshot1.doc.get('bookRating');
                                  ratingList.add(snapshot1.doc.get('bookRating'));
                                  sum = ratingList.reduce((a, b) => a + b);
                                  userLength = queryUserRatingSnapshots.docs.length;
                                  rating = sum / userLength;
                                  debugPrint('Else User Rating => $ratingList === $sum = $userLength = $rating = $userRating');
                                }*/
            }
          }
        }

        for (var bookSnapshot in queryBookSnapshots.docChanges) {
          authorName = bookSnapshot.doc.get('authorName');
          bookDescription = bookSnapshot.doc.get('bookDescription');
          bookImages = bookSnapshot.doc.get('bookImages');
          bookName = bookSnapshot.doc.get('bookName');
          bookVideo = bookSnapshot.doc.get('bookVideo');
          currentUser = bookSnapshot.doc.get('currentUser');
          bookPrice = bookSnapshot.doc.get('bookPrice');
          selectedSemester =
              bookSnapshot.doc.get('selectedSemester');
          publisherName = bookSnapshot.doc.get('publisherName');
          selectedCourse = bookSnapshot.doc.get('selectedCourse');
          selectedClass = bookSnapshot.doc.get('selectedClass');
          userId = bookSnapshot.doc.get('userId');
          userEmail = bookSnapshot.doc.get('userEmail');
          timestamp = bookSnapshot.doc.get('timeStamp');
          userMobile = bookSnapshot.doc.get('userMobile');
          discountPercentage =
              bookSnapshot.doc.get('discountPercentage');
          bookAvailable = bookSnapshot.doc.get('bookAvailable');
        }

        AddBookDetailsAuth().addBookDetails(
            uId: userId,
            publisherName: publisherName,
            userEmail: userEmail,
            userMobile: userMobile,
            bookName: bookName,
            price: bookPrice,
            bookImages: bookImages,
            bookVideo: bookVideo,
            discountPercentage: discountPercentage,
            bookAvailable: bookAvailable,
            selectedClass: selectedClass,
            selectedCourse: selectedCourse,
            selectedSemester: selectedSemester,
            bookRating: rating,
            currentUser: currentUser,
            authorName: authorName,
            bookDescription: bookDescription,
            timestamp: timestamp);
        Navigator.pop(context);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: Text(widget.snapshotData['bookName']),
        actions: [
          Visibility(
            visible: buttonVisible,
            child: Consumer<InternetProvider>(
                builder: (context, internetSnapshot, _) {
                return TextButton(
                    onPressed: () async {
                      if(internetSnapshot.isInternet){
                        giveRating();
                      }else{
                        AppUtils.instance.showSnackBar(context, 'Please check your internet connection');
                      }
                    },
                    child: Text('POST', style: Theme.of(context).textTheme.subtitle2,));
              }
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
                visible: widget.snapshotData['currentUser'] !=
                    FirebaseAuth.instance.currentUser?.email,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder(
                            stream: FirebaseCollection()
                                .userRatingCollection
                                .where('bookName',
                                    isEqualTo: widget.snapshotData['bookName'])
                                .where('currentUser',
                                    isEqualTo: FirebaseAuth
                                        .instance.currentUser?.email)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot<Object?>>
                                    snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.requireData.docChanges.isEmpty) {
                                return RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  glowColor: Colors.transparent,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  glow: false,
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
                                      debugPrint(
                                          'I am user Rating => $userRating');
                                    });
                                  },
                                );
                              } else if (snapshot.hasData) {
                                return RatingBar.builder(
                                  initialRating: snapshot.data?.docs[0]
                                      ['bookRating'],
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  glow: false,
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
                                      debugPrint(
                                          'I am user Rating another => $userRating');
                                      debugPrint(
                                          'I am Firebase Rating  => ${snapshot.data?.docs[0]['bookRating']}');
                                    });
                                  },
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                      child: TextFieldWidget().textFieldWidget(
                        hintText: 'Describe your Exprience (Optional)',
                        controller: reviewController,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            StreamBuilder(
                stream: FirebaseCollection()
                    .userRatingCollection
                    .where('bookName',
                        isEqualTo: widget.snapshotData['bookName'])
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.requireData.docChanges.isEmpty) {
                    return const Center(child: Text('No review'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 10),
                          child: Text(
                            "User Rating",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: AppColor.appColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                margin: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                        child: Container(
                                      color:
                                          AppColor.greyColor.withOpacity(0.3),
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                        child: Text(
                                            '${snapshot.data?.docs[index]['userName'].substring(0, 1).toUpperCase()}',
                                            style: const TextStyle(
                                                color: AppColor.whiteColor)),
                                      ),
                                    )),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${snapshot.data?.docs[index]['userName']}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          RatingBar.builder(
                                            initialRating: snapshot.data
                                                ?.docs[index]['bookRating'],
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ignoreGestures: true,
                                            itemSize: 15,
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              debugPrint('$rating');
                                            },
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${snapshot.data?.docs[index]['userGiveExprience']}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ),
      ),
    );
  }
}
