import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:school_supplies_hub/utils/app_utils.dart';

import '../book_details/auth/buy_book_detail_auth.dart';

class PaymentController{
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      {required String amount, required String currency,
        required String publisherName,required String userEmail,
        required String userMobile,required String bookName,
        required List bookImage,
        required String bookVideo,
        required String selectedClass,
        required String selectedCourse,required String selectedSemester,
        required String userAddress,
        required String authorName,
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
          AppUtils.instance.showSnackBar(context, 'Payment Success');

          BuyBookDetailAuth().buyBookDetails(
              uId: FirebaseAuth.instance.currentUser!.uid,
              publisherName: publisherName,
              userEmail: userEmail,
              userMobile: userMobile,
              bookName: bookName,
              price: amount,
              bookVideo: bookVideo,bookImages: bookImage,
              selectedClass: selectedClass,
              selectedCourse: selectedCourse,
              selectedSemester: selectedSemester,
              userAddress: userAddress, authorName: authorName,
              timestamp: timeStamp);
          //debugPrint('Payment Success');
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

  /*displayPaymentSheet(context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      AppUtils.instance.showSnackBar(context, 'Payment Success');

      //debugPrint('Payment Success');
    } on Exception catch (e) {
      if (e is StripeException) {
        AppUtils.instance.showSnackBar(context, '${e.error.localizedMessage}');
        debugPrint("Error from Stripe: ${e.error.localizedMessage}");
      } else {

        debugPrint("Unforeseen error: $e");
      }
    } catch (e) {
      debugPrint("exception:$e");
    }
  }*/

  //  Future<Map<String, dynamic>>
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
      debugPrint("${response.statusCode}");
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('err charging user: ${err.toString()}');
    }
  }
}
