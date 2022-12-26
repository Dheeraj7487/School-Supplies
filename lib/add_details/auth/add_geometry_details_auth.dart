import 'package:flutter/cupertino.dart';
import 'package:school_supplies_hub/add_details/model/add_geometry_detail_model.dart';
import '../../firebase/firebase_collection.dart';


class AddGeometryBoxDetailsAuth{

  Future<void> addGeometryBoxDetails(
      {
        required String uId,
        required String publisherName,
        required String userEmail,
        required String userMobile,
        required String toolName,
        required String price,
        required int itemAvailable,
        required int discountPercentage,
        required String toolImages,
        required String toolDescription,
        required double toolRating,
        required String currentUser,
        required String timestamp
      }) async {

    AddGeometryBoxDetailModel addGeometryBoxDetailModel = AddGeometryBoxDetailModel(
      userId: uId,
      userEmail: userEmail,
      userMobile: userMobile,
      toolName: toolName,
      publisherName: publisherName,
      description: toolDescription,
      toolPrice: price,
      itemAvailable: itemAvailable,
      discountPercentage: discountPercentage,
      toolImages: toolImages,
      toolRating: toolRating,
      currentUser: currentUser,
      timeStamp: timestamp
    );
    FirebaseCollection().addGeometryCollection.doc('$currentUser$toolName').set(addGeometryBoxDetailModel.toJson()).whenComplete(() => debugPrint("Added Tools Detail"))
        .catchError((e) => debugPrint(e));
  }
}