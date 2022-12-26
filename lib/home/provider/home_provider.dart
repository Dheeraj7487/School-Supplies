import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../Firebase/firebase_collection.dart';

class HomeProvider extends ChangeNotifier{

  String? userName = ' ',userEmail,userMobile,userAddress;

  get getUserEmail{
    notifyListeners();
    return userEmail;
  }
  get getUserName{
    notifyListeners();
    return userName;
  }
  get getUserAddress{
    notifyListeners();
    return userAddress;
  }
  get getUserMobile{
    notifyListeners();
    return userMobile;
  }

  getUserData() async {
    var userData = await FirebaseCollection().userCollection
        .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

    for (var data in userData.docChanges) {
      userName = data.doc.get('userName');
      userEmail = data.doc.get('userEmail');
      userMobile = data.doc.get('userMobile');
      userAddress = data.doc.get('userAddress');
    }
    notifyListeners();
  }
}