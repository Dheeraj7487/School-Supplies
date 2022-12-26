import 'package:flutter/cupertino.dart';
import 'package:school_supplies_hub/add_details/model/add_geometry_detail_model.dart';
import '../../firebase/firebase_collection.dart';
import '../model/add_to_favorite_model.dart';

class AddToFavoriteAuth{

  Future<void> addToFavorite(
      {
        required String uId,
        required String publisherName,
        required String userEmail,
        required String userMobile,
        required String name,
        required String price,
        required String authorName,
        required String selectedSemester,
        required String selectedCourse,
        required String selectedClass,
        required List bookImages,
        required String bookVideo,
        required int itemAvailable,
        required int discountPercentage,
        required String toolImages,
        required String description,
        required double rating,
        required String currentUser,
        required String timestamp
      }) async {

    AddToFavoriteModel addToFavoriteModel = AddToFavoriteModel(
        userId: uId,
        userEmail: userEmail,
        userMobile: userMobile,
        itemName: name,
        publisherName: publisherName,
        description: description,
        price: price,
        authorName: authorName,
        selectedSemester: selectedSemester,
        selectedCourse: selectedCourse,
        selectedClass: selectedClass,
        bookImages: bookImages,
        bookVideo: bookVideo,
        itemAvailable: itemAvailable,
        discountPercentage: discountPercentage,
        toolImages: toolImages,
        rating: rating,
        currentUser: currentUser,
        timeStamp: timestamp
    );
    FirebaseCollection().favoriteCollection.doc('$currentUser$name').set(addToFavoriteModel.toJson()).whenComplete(() => debugPrint("Successfully order"))
        .catchError((e) => debugPrint(e));
  }
}