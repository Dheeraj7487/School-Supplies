import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../widgets/responsive_widget.dart';
import '../widgets/register_screen_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColor.appColor,
        body: Center(
          child: SingleChildScrollView(
              child: ResponsiveWidget.isSmallScreen(context)
                  ?   const Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: RegisterScreenWidget())
                  :   const Scrollbar(
                      child: SizedBox(
                        width: 300,
                        child: RegisterScreenWidget(),
                      ),
                    )),
        ),
      ),
    );
  }
}
