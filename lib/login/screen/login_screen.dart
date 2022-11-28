import 'package:flutter/material.dart';
import 'package:school_supplies_hub/login/widgets/login_screen_widgets.dart';
import '../../utils/app_color.dart';
import '../../widgets/responsive_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
            child:  ResponsiveWidget.isSmallScreen(context) ?
            const Padding(
              padding: EdgeInsets.only(top: 20.0,left: 20,right: 20),
              child: LoginScreenWidget()
            ) : SizedBox(
                width: 600,
                child: Container(
                    color: AppColor.appColor.withOpacity(0.5),
                    child: const LoginScreenWidget())
            )

          ),
        ),
      ),
    );
  }
}
