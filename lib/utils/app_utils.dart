import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_color.dart';
import 'app_preference_key.dart';

class AppUtils{
  AppUtils._privateConstructor();
  static final AppUtils instance = AppUtils._privateConstructor();

  showSnackBar(BuildContext? context,
      String msg, {Color? color, int? duration}) {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(msg,style: const TextStyle(color: AppColor.appColor),),
        backgroundColor: color??AppColor.whiteColor,
        duration: Duration(seconds: duration ?? 3),
      ),
    );
  }

  getPreferenceValueViaKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (key == PreferenceKey.prefEmail) {
      return prefs.getString(key);
    } else if (key == PreferenceKey.prefLogin) {
      return prefs.getBool(key);
    }
  }

  setPref(String type, String key, var value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == "String") {
      prefs.setString(key, value);
    } else if (type == "Bool") {
      prefs.setBool(key, value);
    } else if (type == "Double") {
      prefs.setDouble(key, value);
    }else if(type=="StringList"){
      prefs.setStringList(key, value);
    }else {
      prefs.setInt(key, value);
    }
  }

  Future<void> clearPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
