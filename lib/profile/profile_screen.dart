import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Firebase/firebase_collection.dart';
import '../Login/screen/login_screen.dart';
import '../widgets/button_widget.dart';
import '../utils/app_color.dart';
import '../utils/app_utils.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                                right: 15,top: 10,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                      child: const Icon(Icons.edit,color: AppColor.whiteColor,size: 20,)),
                                )
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 30),
                          child: Column(
                            children: [
                              _profileDetail(Icons.person_outline,data['userName']),
                              const SizedBox(height: 10,),
                              _profileDetail(Icons.email_outlined,data['userEmail']),
                              const SizedBox(height: 10,),
                              _profileDetail(Icons.phone_android_outlined,data['userMobile']),
                              const SizedBox(height: 50),
                              ButtonWidget().appButton(
                                text: 'Logout',
                                onTap: (){
                                  FirebaseAuth.instance.signOut();
                                  AppUtils.instance.clearPref().then((value) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                  });
                                },
                              ),
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
    );
  }

  Widget _profileDetail(IconData icon,String userDetails){
    return Card(
      color: AppColor.appColor,
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.only(top: 15,bottom: 15),
              margin: const EdgeInsets.only(left: 10,right: 10),
              child: Icon(icon,color: AppColor.whiteColor,)),
          const SizedBox(height: 5,),
          Container(
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              margin: const EdgeInsets.only(left: 15,right: 15),
              child: Text(userDetails,style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
