import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:school_supplies_hub/add_details/auth/add_geometry_details_auth.dart';
import 'package:school_supplies_hub/utils/app_utils.dart';
import '../book_details/auth/buy_geometry_box_detail_auth.dart';

class GeometryPaymentController{
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      { required String amount,
        required String currency,
        required String publisherName,
        required String userEmail,
        required String userId,
        required String userMobile,
        required String toolName,
        required String toolImage,
        required String userAddress,
        required int discountPercentage,
        required String toolPrice,
        required double toolRating,
        required String currentUser,
        required String toolDescription,
        required int itemAvailable,
        required String timeStamp,
        required BuildContext context}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              // applePay: true,
              // googlePay: true,
              // testEnv: true,
              // merchantCountryCode: 'US',
              merchantDisplayName: 'Prospects',
              customerId: paymentIntentData!['customer'],
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            ));

        try {
          await Stripe.instance.presentPaymentSheet();
          Navigator.pop(context);
          AppUtils.instance.showSnackBar(context, 'Payment Success');

          BuyToolBoxDetailAuth().buyToolBoxDetails(
              uId: FirebaseAuth.instance.currentUser!.uid,
              publisherName: publisherName,
              userEmail: userEmail,
              userMobile: userMobile,
              toolName: toolName,
              price: amount,
              discountPercentage : discountPercentage,
              toolImages: toolImage,
              userAddress: userAddress,
              timestamp: timeStamp, toolAvailable: itemAvailable,);

          AddGeometryBoxDetailsAuth().addGeometryBoxDetails(
            uId: userId,
            publisherName: publisherName,
            userEmail: userEmail,
            userMobile: userMobile,
            toolName: toolName,
            price: toolPrice,
            discountPercentage : discountPercentage,
            timestamp: timeStamp,
            currentUser: currentUser,
            itemAvailable:  itemAvailable,
            toolImages: toolImage, toolDescription: toolDescription,
            toolRating: toolRating,
          );

        } on Exception catch (e) {
          if (e is StripeException) {
            AppUtils.instance.showSnackBar(context, '${e.error.localizedMessage}');
            debugPrint("Error from Stripe: ${e.error.localizedMessage}");
          } else {
            AppUtils.instance.showSnackBar(context, '$e');
            debugPrint("Unforeseen error: $e");
          }
        } catch (e) {
          AppUtils.instance.showSnackBar(context, '$e');
          debugPrint("exception:$e");
        }
      }
    } catch (e, s) {
      AppUtils.instance.showSnackBar(context, '$e$s');
      debugPrint('exception:$e$s');
    }
  }


  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': '${(int.parse(amount)) * 100}',
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51LiBiMSA1JiaZapda3BdjLgQiJlVTmxCj41Z6sgVAuYSrPMJjAokXSwGCkx9pUMOmxX30qGJzpTJtwJ0eybzt6tf007poFpurd',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      debugPrint("Response Code${response.statusCode}");
      debugPrint(response.body);
      return jsonDecode(response.body);

    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
    }
  }
}
