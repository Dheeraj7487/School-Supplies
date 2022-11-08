import 'package:flutter/material.dart';
import 'package:school_supplies_hub/widgets/button_widget.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../widgets/textfield_widget.dart';
import '../auth/login_auth.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,0,20,0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                        AppImage.appLogo,
                        height: 70,width: 70,fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 15),
                  Text('Reset Your Password',style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(height: 5,),
                  Text('Provider your account email for which you want to reset your password',style: Theme.of(context).textTheme.headline2),
                  const SizedBox(height: 40),
                  Text('Email',style: Theme.of(context).textTheme.subtitle2),
                  const SizedBox(height: 5),
                  TextFieldWidget().textFieldWidget(
                    controller: emailController,
                    textInputAction: TextInputAction.done,
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
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ButtonWidget().appButton(
                        text: 'Reset Password',
                        onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          LoginAuth().resetPassword(email: emailController.text,context: context);
                        }}
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
