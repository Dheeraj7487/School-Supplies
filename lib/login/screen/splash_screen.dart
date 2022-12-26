import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_supplies_hub/utils/app_image.dart';

import '../../main.dart';
import '../../utils/app_color.dart';
import '../../utils/app_preference_key.dart';
import '../../utils/app_utils.dart';
import '../../widgets/bottom_nav_bar_widget.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>{

  bool isUserLogin=false;
  String? email;

  getPreferenceData()async{
    isUserLogin= await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefLogin)??false;
    email=await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefEmail)?? "";
    setState(() {});
    Timer(
        const Duration(seconds: 3), (){
        if(isUserLogin){
          Timer(
              const Duration(seconds: 3), (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) =>  const BottomNavBarScreen()));
          });
        } else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>  const LoginScreen()));
        }
    });
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin.cancelAll();
    getPreferenceData();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.appColor,
      body: Center(
        child:Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                  child: Image.asset(AppImage.appLogo,height: 130,width: 130,fit: BoxFit.fill)),
              const Text('School Supplies Hub',textAlign: TextAlign.center,style: TextStyle(fontSize: 18))
            ],
          ),
        ),
      ),
    );
  }
}