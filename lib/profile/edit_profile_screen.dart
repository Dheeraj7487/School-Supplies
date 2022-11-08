import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_supplies_hub/login/model/user_model.dart';
import 'package:school_supplies_hub/widgets/button_widget.dart';
import '../../Firebase/firebase_collection.dart';
import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../widgets/textfield_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: formKey,
        child: StreamBuilder(
          stream: FirebaseCollection().userCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.requireData.exists){
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        Container(height: 100),
                        Positioned(
                          left: 0,right: 0,
                          child: Column(
                            children: [
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          TextFieldWidget().textFieldWidget(
                            controller: nameController..text = data['userName'],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            hintText: "Enter Name",
                            prefixIcon: const Icon(Icons.person,color: AppColor.whiteColor),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10,),
                          TextFieldWidget().textFieldWidget(
                            controller: mobileController..text = data['userMobile'],
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            counterText: "",
                            hintText: "Enter Phone Number",
                            prefixIcon: const Icon(Icons.phone_android_outlined,color: AppColor.whiteColor),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          Align(
                            alignment: Alignment.center,
                            child: ButtonWidget().appButton(
                                onTap: () async {
                                  if(formKey.currentState!.validate() ) {
                                    UserModel updateUserDetail = UserModel(
                                      userName: nameController.text.trim(),
                                      userMobile: mobileController.text.trim(),
                                      userId: data["userId"],
                                      userEmail: data["userEmail"],
                                      userRating: data["userRating"],
                                      timeStamp: data["timeStamp"],
                                      currentUser: data["currentUser"]
                                    );
                                    FirebaseCollection().userCollection.doc(FirebaseAuth.instance.currentUser?.email).
                                    update(updateUserDetail.toJson()).whenComplete(() => debugPrint("Update user Details"))
                                        .catchError((e) => debugPrint(e));
                                    Navigator.pop(context);
                                  }
                                }, text: 'Edit Profile'),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
