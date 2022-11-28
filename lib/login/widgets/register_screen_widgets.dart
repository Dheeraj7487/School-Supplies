import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/login/auth/login_auth.dart';
import 'package:school_supplies_hub/login/screen/login_screen.dart';
import 'package:school_supplies_hub/widgets/textfield_widget.dart';
import '../../add_details/provider/add_book_detail_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_utils.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/dropdown_widget.dart';
import '../auth/login_provider.dart';
import '../provider/loading_provider.dart';

class RegisterScreenWidget extends StatefulWidget {
  const RegisterScreenWidget({Key? key}) : super(key: key);

  @override
  State<RegisterScreenWidget> createState() => _RegisterScreenWidgetState();
}

class _RegisterScreenWidgetState extends State<RegisterScreenWidget> {

  RegExp passwordValidation = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = false,confirmPasswordVisibility = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
             Text(
              "Register",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            Text(
                'Please sign up to continue'
                    ,style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 40),
            Text('Full Name',style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 5),
            TextFieldWidget().textFieldWidget(
              controller: nameController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              hintText: "Enter Name",
              prefixIcon: const Icon(Icons.person_outline,color: AppColor.whiteColor),
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),
            Text('Email',style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 5),
            TextFieldWidget().textFieldWidget(
              controller: emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              hintText: "Enter email",
              prefixIcon: const Icon(Icons.email_outlined,color: AppColor.whiteColor),
              validator: (value) {
                if (value!.isEmpty ||
                    value.trim().isEmpty) {
                  return 'Please enter an email';
                } else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)){
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text('Mobile Number',style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 5),
            TextFieldWidget().textFieldWidget(
              controller: phoneController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
              hintText: "Enter Phone Number",
              maxLength: 10,
              // prefixText: '+91',
              counterText: '',
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

            const SizedBox(height: 20),
            Text('Address',style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 5),
            TextFieldWidget().textFieldWidget(
              controller: addressController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              hintText: "Enter Address",
              prefixIcon: const Icon(Icons.villa_outlined,color: AppColor.whiteColor),
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            Text('Choose Class',style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 5),
            Consumer<AddBookDetailProvider>(
                builder: (BuildContext context, snapshot, Widget? child) {
                  return appDropDown(
                      value: snapshot.chooseClass,
                      hint: 'Choose Class',
                      onChanged: (String? newValue) {
                        snapshot.chooseClass = newValue!;
                        snapshot.getChooseClass;
                      },
                      items:  snapshot.chooseClasses
                  );
                },
            ),

            const SizedBox(height: 20),
            Text('Password',style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 5),
            TextFieldWidget().textFieldWidget(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              hintText: "Enter password",
              obscureText: passwordVisibility ? false : true,
              prefixIcon: const Icon(Icons.lock_outline,color: AppColor.whiteColor),
              suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      passwordVisibility = !passwordVisibility;
                    });
                  },
                  icon: passwordVisibility ? const Icon(
                    Icons.visibility, color: AppColor.whiteColor,
                  ) : const Icon(Icons.visibility_off,
                      color: AppColor.whiteColor)),
              validator: (value) {
                if (value!.isEmpty || value.trim().isEmpty) {
                  return 'Please enter password';
                } else if (!passwordValidation
                    .hasMatch(passwordController.text)) {
                  return 'Password must contain at least one number and both lower upper case letters and special characters.';
                } else if (value.length < 8) {
                  return 'Password must be atLeast 8 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),
            Text('Confirm Password',style: Theme.of(context).textTheme.subtitle2,),
            const SizedBox(height: 5),
            TextFieldWidget().textFieldWidget(
              controller: confirmPasswordController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              hintText: "Enter password",
              obscureText: confirmPasswordVisibility ? false : true,
              prefixIcon: const Icon(Icons.lock_outline,color: AppColor.whiteColor),
              suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      confirmPasswordVisibility = !confirmPasswordVisibility;
                    });
                  },
                  icon: confirmPasswordVisibility ? const Icon(
                    Icons.visibility, color: AppColor.whiteColor,
                  ) : const Icon(Icons.visibility_off,
                      color: AppColor.whiteColor)),
              validator: (value) {
                if (value != passwordController.text) {
                  return "Password does Not Match";
                }
                // else if (passwordController.text.isNotEmpty &&
                //     passwordController.text.length >= 8 &&
                //     passwordController.text.length <= 16 &&
                //     !passwordController.text.contains(' ') &&
                //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                //         .hasMatch(
                //         passwordController.text.toString())) {
                //   return null;
                // }
                return null;
              },
            ),
            const SizedBox(height: 40),


            Consumer<AddBookDetailProvider>(
                builder: (BuildContext context, snapshot, Widget? child) {
                  return ButtonWidget().appButton(
                    text: 'Sign Up',
                    onTap: () async{
                      debugPrint('Selected Class ${Provider.of<AddBookDetailProvider>(context,listen: false).selectClass}');
                      if(_formKey.currentState!.validate()){
                        Provider.of<LoadingProvider>(context,listen: false).startLoading();
                        User? user = await LoginAuth.registerUsingEmailPassword(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            mobile: phoneController.text.trim(),
                            password: passwordController.text.trim(),
                            context: context
                        );

                        if(user !=null){
                          LoginProvider().addUserDetail(
                              uId: "${FirebaseAuth.instance.currentUser?.uid}",
                              userName: nameController.text.trim(),
                              userEmail: emailController.text.trim(),
                              userMobile: phoneController.text.trim(),
                              userAddress: addressController.text.trim(),
                              fcmToken: fcmToken.toString(),
                              rating: 0,
                              chooseClass: snapshot.chooseClass.toString(),
                              currentUser: "${FirebaseAuth.instance.currentUser?.email}",
                              timestamp: DateTime.now().toString()).then((value) {
                            AppUtils.instance.showSnackBar(context, 'Register Successfully');
                            Provider.of<LoadingProvider>(context,listen: false).stopLoading();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                          });
                        }
                      }
                    },
                  );
                },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10,top: 10),
                  child: Text(
                    'Already have an account?  ',
                      style: Theme.of(context).textTheme.headline6
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10,top: 10),
                    child: Text(
                      'LOGIN',
                        style: Theme.of(context).textTheme.headlineLarge
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


