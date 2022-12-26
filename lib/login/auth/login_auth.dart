import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/add_details/provider/add_book_detail_provider.dart';
import 'package:school_supplies_hub/login/provider/loading_provider.dart';

import '../../Firebase/firebase_collection.dart';
import '../../Login/auth/login_provider.dart';
import '../../Login/screen/login_screen.dart';
import '../../utils/app_preference_key.dart';
import '../../utils/app_utils.dart';
import '../../widgets/bottom_nav_bar_widget.dart';

class LoginAuth {

  String? fcmToken;


  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String mobile,
    required String address,
    required String fcmToken,
    required String password,
    required BuildContext context,
  })
  async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      Provider.of<LoadingProvider>(context,listen: false).startLoading();
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();

      LoginProvider().addUserDetail(
          uId: "${FirebaseAuth.instance.currentUser?.uid}",
          userName: name,
          userEmail: email,
          userMobile: mobile,
          userAddress: address,
          fcmToken: fcmToken.toString(),
          rating: 0,
          chooseClass: Provider.of<AddBookDetailProvider>(context,listen: false).chooseClass.toString(),
          currentUser: "${FirebaseAuth.instance.currentUser?.email}",
          timestamp: DateTime.now().toString()).then((value) {
        AppUtils.instance.showSnackBar(context, 'Register Successfully');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
      });

      user = auth.currentUser;
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak');
        AppUtils.instance.showSnackBar(context, 'The password provided is too weak');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      }
      else if (e.code == 'email-already-in-use') {
        AppUtils.instance.showSnackBar(context, 'The account already exists for that email');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      }
    } catch (e) {
      debugPrint('$e');
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
    }
    Provider.of<LoadingProvider>(context,listen: false).stopLoading();
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required String fcmToken,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      Provider.of<LoadingProvider>(context,listen: false).startLoading();
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      if(user != null){
        AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
        AppUtils.instance.setPref(PreferenceKey.stringKey, PreferenceKey.prefEmail, email);

        var snapshotData = await FirebaseCollection().userCollection.
        where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
        for(var data in snapshotData.docChanges){
          LoginProvider().addUserDetail(
              uId: "${FirebaseAuth.instance.currentUser?.uid}",
              userName: data.doc.get('userName'),
              userEmail: data.doc.get('userEmail'),
              userMobile: data.doc.get('userMobile'),
              userAddress: data.doc.get('userAddress'),
              chooseClass: data.doc.get('chooseClass'),
              fcmToken: fcmToken.toString(),
              rating: data.doc.get('userRating'),
              currentUser: "${FirebaseAuth.instance.currentUser?.email}",
              timestamp: DateTime.now().toString()).then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavBarScreen()));
          });
        }
      }
      Provider.of<LoadingProvider>(context,listen: false).stopLoading();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showSnackBar(context, 'No user found for that email');
      }
      else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showSnackBar(context, 'Wrong password provided');
      }
    }
    Provider.of<LoadingProvider>(context,listen: false).stopLoading();
    return user;
  }

  Future resetPassword({required String email,BuildContext? context}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      AppUtils.instance.showSnackBar(context, 'sent a reset password link on your gmail account');
      Navigator.of(context!).pop();
    }).catchError((e) {
      AppUtils.instance.showSnackBar(context, 'No user found for that email');
    });
  }
}