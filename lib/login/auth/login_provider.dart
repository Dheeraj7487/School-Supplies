import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_supplies_hub/login/model/user_model.dart';
import '../../firebase/firebase_collection.dart';

// final loginProvider = StateProvider<LoginProvider>((ref) {
//   return LoginProvider();
// });

class LoginProvider{

  Future<void> addUserDetail(
      { required String uId,
        required String userName,
        required String userEmail,
        required String userMobile,
        required double rating,
        required String currentUser,
        required String timestamp
      }) async {

    UserModel addUserDetail = UserModel(
      userId: uId,
      userName: userName,
      userEmail: userEmail,
      userMobile: userMobile,
      userRating: 0,
      timeStamp: timestamp,
      currentUser: currentUser
    );
    FirebaseCollection().userCollection.doc(userEmail).set(addUserDetail.toJson()).whenComplete(() => debugPrint("Added user Details"))
        .catchError((e) => debugPrint(e));
  }
}