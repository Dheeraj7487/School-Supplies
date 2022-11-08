import 'package:flutter/cupertino.dart';
import '../../firebase/firebase_collection.dart';
import '../model/add_book_detail_model.dart';

// final addBookDetailsAuthProvider = StateProvider<AddBookDetailsAuth>((ref) {
//   return AddBookDetailsAuth();
// });

class AddBookDetailsAuth{

  Future<void> addBookDetails(
      {
        required String uId,
        required String publisherName,
        required String userEmail,
        required String userMobile,
        required String bookName,
        required String price,
        required List bookImages,
        required String bookVideo,
        required String selectedClass,
        required String selectedCourse,
        required String selectedSemester,
        required double bookRating,
        required String currentUser,
        required String authorName,
        required String bookDescription,
        required String timestamp
      }) async {

    AddBookDetailModel addBookDetailModel = AddBookDetailModel(
        userId: uId,
        publisherName: publisherName,
        userEmail: userEmail,
        userMobile: userMobile,
        bookName: bookName,
        authorName: authorName,
        bookDescription: bookDescription,
        bookImages: bookImages,
        price: price,
        bookVideo: bookVideo,
        selectedClass: selectedClass,
        selectedCourse: selectedCourse,
        selectedSemester: selectedSemester,
        bookRating: bookRating,
        currentUser: currentUser,
        timeStamp: timestamp,
    );
    FirebaseCollection().addBookCollection.doc('$currentUser$bookName').set(addBookDetailModel.toJson()).whenComplete(() => debugPrint("Added Book Details"))
        .catchError((e) => debugPrint(e));
  }
}