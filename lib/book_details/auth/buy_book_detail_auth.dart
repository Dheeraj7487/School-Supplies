import 'package:flutter/cupertino.dart';
import 'package:school_supplies_hub/book_details/model/buy_book_details_model.dart';
import '../../firebase/firebase_collection.dart';

class BuyBookDetailAuth{

  Future<void> buyBookDetails(
      {
        String? uId,
        required String publisherName,
        required String userEmail,
        required String userMobile,
        required String bookName,
        required String price,
        required int itemAvailable,
        required int discountPercentage,
        required List bookImages,
        required String bookVideo,
        required String selectedClass,
        required String selectedCourse,
        required String selectedSemester,
        required String userAddress,
        required String authorName,
        required String timestamp
      }) async {

    BuyBookDetailModel buyBookDetailModel = BuyBookDetailModel(
      userId: uId,
      userEmail: userEmail,
      userMobile: userMobile,
      bookName: bookName,
      authorName: authorName,
      bookImages: bookImages,
      bookPrice: price,
      bookAvailable: itemAvailable,
      discountPercentage: discountPercentage,
      bookVideo: bookVideo,
      selectedClass: selectedClass,
      selectedCourse: selectedCourse,
      selectedSemester: selectedSemester,
      userAddress: userAddress,
      timeStamp: timestamp,
    );
    FirebaseCollection().buyBookCollection.doc('$userEmail$bookName$itemAvailable').set(buyBookDetailModel.toJson()).whenComplete(() => debugPrint("Successfully order"))
        .catchError((e) => debugPrint(e));
  }
}