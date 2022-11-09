import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/login/provider/loading_provider.dart';

import '../../utils/app_utils.dart';

class LoginAuth {

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String mobile,
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
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak');
        AppUtils.instance.showSnackBar(context, 'The password provided is too weak');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
      }
      else if (e.code == 'email-already-in-use') {
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showSnackBar(context, 'The account already exists for that email');
      }
    } catch (e) {
      debugPrint('$e');
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
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