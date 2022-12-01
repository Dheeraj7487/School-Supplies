import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/utils/app_image.dart';
import 'package:school_supplies_hub/widgets/internet_screen.dart';
import '../Firebase/firebase_collection.dart';
import '../Login/screen/login_screen.dart';
import '../home/provider/internet_provider.dart';
import '../login/auth/login_provider.dart';
import '../utils/app_color.dart';
import '../utils/app_utils.dart';
import 'edit_profile_screen.dart';
import 'my_orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
        builder: (context, internetSnapshot, _) {
          internetSnapshot.checkInternet().then((value) {});
          return internetSnapshot.isInternet ?
         SafeArea(
          child: Scaffold(
              backgroundColor: AppColor.appColor,
              body: StreamBuilder(
                  stream: FirebaseCollection().userCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot){
                    if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    else if(snapshot.requireData.exists){
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(height: 140),
                                Positioned(
                                  left: 0,right: 0,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 30,),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: AppColor.darkWhiteColor,
                                            ),
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: ClipOval(
                                            child: Container(
                                              color: AppColor.whiteColor,
                                              height: 70,width: 70,child: Center(
                                              child: Text('${data['userName']?.substring(0,1).toUpperCase()}',
                                                  style: const TextStyle(color: AppColor.appColor,fontSize: 24)),
                                            ),)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Positioned(
                                    right: 5,
                                    child: PopupMenuButton<int>(
                                      offset: const Offset(0, 37),
                                      color: AppColor.appColor,
                                      elevation: 2,
                                      icon: Image.asset(AppImage.menu,height: 15,width: 15,color: AppColor.whiteColor,),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: const [
                                              Icon(Icons.person_outline,color: AppColor.whiteColor,size: 20),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Edit Profile",style: TextStyle(fontSize: 13))
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Row(
                                            children: const [
                                              Icon(Icons.rate_review_outlined,color: AppColor.whiteColor,size: 20),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("My Orders",style: TextStyle(fontSize: 13))
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 3,
                                          child: Row(
                                            children: const [
                                              Icon(Icons.logout,color: AppColor.whiteColor,size: 20,),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Logout",style: TextStyle(fontSize: 13))
                                            ],
                                          ),
                                        ),
                                      ],
                                      onSelected: (value) {
                                        if (value == 1) {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
                                        }
                                        else if (value == 2) {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=>const MyOrderScreen()));
                                        }
                                        else if (value == 3) {
                                          FirebaseAuth.instance.signOut()
                                              .then((value){
                                            LoginProvider().addUserDetail(
                                                uId: data['userId'],
                                                userName: data['userName'],
                                              userAddress: data['userAddress'],
                                                userEmail: data['userEmail'], userMobile: data['userMobile'],
                                                fcmToken: '', rating: data['userRating'],
                                              currentUser: data['currentUser'], chooseClass: data['chooseClass'],
                                              timestamp: data['timeStamp'],
                                            );
                                          });
                                          AppUtils.instance.clearPref().then((value) =>
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                                                  ModalRoute.withName('/')
                                              ));
                                        }

                                      },
                                    )
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 30),
                              child: Column(
                                children: [
                                  _profileDetail(AppImage.userName,data['userName']),
                                  const SizedBox(height: 10,),
                                  _profileDetail(AppImage.email,data['userEmail']),
                                  const SizedBox(height: 10,),
                                  _profileDetail(AppImage.mobile,data['userMobile']),
                                  const SizedBox(height: 10,),
                                  _profileDetail(AppImage.address,data['userAddress']),
                                  const SizedBox(height: 10,),
                                  _profileDetail(AppImage.classIcon,data['chooseClass']),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
              )
          ),
        ) : noInternetDialog();
      }
    );
  }

  Widget _profileDetail(String icon,String userDetails){
    return Card(
      color: AppColor.appColor,
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.only(top: 15,bottom: 15),
              margin: const EdgeInsets.only(left: 10,right: 10),
              child: Image.asset(icon,color: AppColor.whiteColor,height: 20,width: 20,fit: BoxFit.fill,)),
          const SizedBox(height: 5,),
          Expanded(
            child: Container(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                margin: const EdgeInsets.only(left: 15,right: 15),
                child: Text(userDetails,style: const TextStyle(fontSize: 12,),maxLines: 2,overflow: TextOverflow.ellipsis,)),
          ),
        ],
      ),
    );
  }
}
