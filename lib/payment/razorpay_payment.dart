/*
import 'package:flutter/cupertino.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPayment extends ChangeNotifier{

  late Razorpay razorpay;

  void openCheckout(price,discount,String bookName,String userMobile,String userEmail) async {
    double amount = double.parse(price);
    amount = amount - amount * discount / 100;
    notifyListeners();

    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': amount.floor()*100,
      'name': bookName,
      'description': "",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': userMobile, 'email': userEmail},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(price,discountPercentage,orderData) async {
   // debugPrint('Success Response: $response');
    // AppUtils.instance.showSnackBar(context, "EXTERNAL_WALLET: ${response.paymentId}");

    orderData();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error Response: $response');
    // AppUtils.instance.showSnackBar(context, "EXTERNAL_WALLET: ${response.message}");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External SDK Response: $response');
    //AppUtils.instance.showSnackBar(context, "EXTERNAL_WALLET: ${response.walletName}");
  }

  razorPayInitialize(){
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


}*/
