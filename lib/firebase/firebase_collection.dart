import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollection {
  static const String userCollectionName = 'users';
  static const String addBookCollectionName = 'book_details';
  static const String addGeometryCollectionName = 'tool_details';
  static const String userRatingCollectionName = 'rating';
  static const String buyBookCollectionName = 'buy_book';
  CollectionReference userCollection = FirebaseFirestore.instance.collection(userCollectionName);
  CollectionReference addBookCollection = FirebaseFirestore.instance.collection(addBookCollectionName);
  CollectionReference addGeometryCollection = FirebaseFirestore.instance.collection(addGeometryCollectionName);
  CollectionReference userRatingCollection = FirebaseFirestore.instance.collection(userRatingCollectionName);
  CollectionReference buyBookCollection = FirebaseFirestore.instance.collection(buyBookCollectionName);
}