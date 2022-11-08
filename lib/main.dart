import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/add_details/provider/add_book_detail_provider.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:school_supplies_hub/utils/app_color.dart';
import 'package:school_supplies_hub/widgets/loading_widget.dart';
import 'login/provider/loading_provider.dart';
import 'login/screen/splash_screen.dart';

// const stripePublishableKey =  "pk_test_51LiBiMSA1JiaZapdYWXElEllmQ0MjwJNhmXjAyIsHVp5ev6Zv4DFOmg0lVBRzQ2whpZHhDOQQrtftbuNAATE7ggA00xTK2iHGW";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Stripe.publishableKey = stripePublishableKey;
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
            ChangeNotifierProvider<AddBookDetailProvider>(create: (_) => AddBookDetailProvider()),
          ], child: const MyApp()
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
          errorColor: Colors.redAccent.withOpacity(0.5),
          textTheme: const TextTheme(
            bodyText1: TextStyle(fontSize: 24.0,color: AppColor.whiteColor),
            bodyText2: TextStyle(fontSize: 12.0,color: AppColor.whiteColor),
            headline1: TextStyle(fontSize: 20.0,color: AppColor.whiteColor),
            headline2: TextStyle(fontSize: 18.0,color: AppColor.whiteColor),
            headline3: TextStyle(fontSize: 16.0,color: AppColor.whiteColor),
            headline4: TextStyle(fontSize: 14.0,color: AppColor.whiteColor),
            headline5: TextStyle(fontSize: 12.0,color: AppColor.whiteColor),
            headline6: TextStyle(fontSize: 12.0,color: AppColor.whiteColor,fontWeight: FontWeight.w300),
            subtitle1: TextStyle(fontSize: 12.0,color: AppColor.whiteColor),
            subtitle2: TextStyle(fontSize: 10.0,color: AppColor.whiteColor),
            headlineLarge: TextStyle(fontSize: 15.0,color: AppColor.whiteColor,decoration: TextDecoration.underline),
          ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColor.appColor))),
        appBarTheme: const AppBarTheme(
          color: AppColor.appColor,
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle:  TextStyle(
            color: AppColor.whiteColor,
          ),
          iconTheme:  IconThemeData(
            color: AppColor.whiteColor,
          ),
        ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColor.whiteColor),
      ),
      home: const SplashScreen(),
      builder: (context, child) {
        return  LoadingWidget(child: child!,);
      },
    );
  }
}
