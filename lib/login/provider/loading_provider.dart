// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final loadingProvider = StateProvider<LoadingProvider>((ref) {
//   return LoadingProvider();
// });

import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier{
  bool isLoading=false;

  void startLoading(){
    isLoading=true;
    notifyListeners();
  }
  void stopLoading(){
    isLoading=false;
    notifyListeners();
  }
}