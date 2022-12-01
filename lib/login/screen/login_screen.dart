import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/login/screen/register_screen.dart';
import 'package:school_supplies_hub/login/screen/reset_password_screen.dart';
import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';
import '../../utils/app_preference_key.dart';
import '../../utils/app_utils.dart';
import '../../widgets/bottom_nav_bar_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/textfield_widget.dart';
import '../auth/login_auth.dart';
import '../auth/login_provider.dart';
import '../provider/loading_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController(),passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = false;
  String? fcmToken;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint('Token: $value');
      setState(() {
        fcmToken = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.appColor,
        body: Center(
          child: SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Login", style: Theme.of(context).textTheme.bodyText1),
                    const SizedBox(height: 10),
                    Text('Please sign in to continue',style: Theme.of(context).textTheme.headline5,),
                    const SizedBox(height: 50),
                    Text('Email',style: Theme.of(context).textTheme.subtitle2,),
                    const SizedBox(height: 5),
                    TextFieldWidget().textFieldWidget(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Enter email",
                      prefixIcon: const Icon(Icons.email_outlined,color: AppColor.whiteColor),
                      validator: (value) {
                        if (value!.isEmpty || value.trim().isEmpty ) {
                          return 'Please enter an email';
                        }
                        else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                        r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)){
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    Text('Password',style: Theme.of(context).textTheme.subtitle2,),
                    const SizedBox(height: 5),
                    TextFieldWidget().textFieldWidget(
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: "Enter password",
                        prefixIcon: const Icon(Icons.lock_outline,color: AppColor.whiteColor),
                        obscureText: passwordVisibility ? false : true,
                        suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                passwordVisibility = !passwordVisibility;
                              });
                            },
                            icon: passwordVisibility ? const Icon(
                              Icons.visibility, color: AppColor.
                            whiteColor,
                            ) : const Icon(Icons.visibility_off,
                                color: AppColor.whiteColor)),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        }
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPasswordScreen()));
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('Reset Password',style: Theme.of(context).textTheme.headline6))),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ButtonWidget().appButton(
                      text: 'Login',
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if(_formKey.currentState!.validate()){
                          // ref.read(loadingProvider).startLoading();
                          User? user = await LoginAuth.signInUsingEmailPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              context: context
                          );

                          if(user != null){
                            AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
                            AppUtils.instance.setPref(PreferenceKey.stringKey, PreferenceKey.prefEmail, emailController.text);

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
                                Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const BottomNavBarScreen()));
                              });

                            }
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10,top: 10),
                          child: Text(
                              'Need an account?  ',
                              style: Theme.of(context).textTheme.headline6
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const RegisterScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10,top: 10),
                            child: Text(
                                'SIGN UP',
                                style: Theme.of(context).textTheme.headlineLarge
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
