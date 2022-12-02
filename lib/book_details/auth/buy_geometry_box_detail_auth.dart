import 'package:flutter/cupertino.dart';
import '../../firebase/firebase_collection.dart';
import '../model/buy_geometry_detail_model.dart';

class BuyToolBoxDetailAuth{

  Future<void> buyToolBoxDetails(
      {
        String? uId,
        required String publisherName,
        required String userEmail,
        required String userMobile,
        required String toolName,
        required String price,
        required int toolAvailable,
        required int discountPercentage,
        required String toolImages,
        required String userAddress,
        required String timestamp
      }) async {

    BuyToolDetailModel buyToolDetailModel = BuyToolDetailModel(
      userId: uId,
      userEmail: userEmail,
      userMobile: userMobile,
      toolName: toolName,
      publisherName : publisherName,
      toolImages: toolImages,
      toolPrice: price,
      selectedSemester: '',
      selectedClass: '',
      selectedCourse: '',
      toolAvailable: toolAvailable,
      discountPercentage: discountPercentage,
      userAddress: userAddress,
      timeStamp: timestamp,
    );
    FirebaseCollection().buyBookCollection.doc('$userEmail$toolName$toolAvailable').set(buyToolDetailModel.toJson()).whenComplete(() => debugPrint("Successfully order"))
        .catchError((e) => debugPrint(e));
  }
}