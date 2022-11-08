import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollection {
  static const String userCollectionName = 'users';
  static const String addBookCollectionName = 'book_details';
  static const String userRatingCollectionName = 'rating';
  CollectionReference userCollection = FirebaseFirestore.instance.collection(userCollectionName);
  CollectionReference addBookCollection = FirebaseFirestore.instance.collection(addBookCollectionName);
  CollectionReference userRatingCollection = FirebaseFirestore.instance.collection(userRatingCollectionName);
}