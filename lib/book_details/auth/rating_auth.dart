import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../Firebase/firebase_collection.dart';

class RatingAuth{

  Future<void> userRating(
      { required String bookName,
        required String currentUser,
        required double userRating,
        required String userName,
        required String userGiveExprience,
        required Timestamp timestamp,
      }
      ) async {
    DocumentReference documentReferencer = FirebaseCollection().userRatingCollection.
    doc('$currentUser $bookName');

    Map<String, dynamic> data = <String, dynamic>{
      "bookName": bookName.toString(),
      'bookRating' : userRating,
      'userGiveExprience' : userGiveExprience,
      "currentUser": currentUser.toString(),
      "userName": userName.toString(),
      "timeStamp" : timestamp
    };
    debugPrint('User Rating Data=> $data');

    await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint('our review will be post'))
        .catchError((e) => debugPrint(e));
  }
}