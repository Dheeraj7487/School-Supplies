import 'package:flutter/material.dart';
import 'package:pay/pay.dart' as pay;
import 'package:pay/pay.dart';
import 'package:school_supplies_hub/utils/app_color.dart';

class GooglePayScreen extends StatefulWidget {
  const GooglePayScreen({Key? key}) : super(key: key);

  @override
  State<GooglePayScreen> createState() => _GooglePayScreenState();
}

class _GooglePayScreenState extends State<GooglePayScreen> {

  List<PaymentItem> get paymentItems {
    const paymentItems = [
      pay.PaymentItem(
        label: 'Total Amount',
        amount: '1',
        status: pay.PaymentItemStatus.final_price,
      )
    ];
    return paymentItems;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: const Text('Google Pay Demo'),
      ),
      body: SingleChildScrollView(
        child: pay.GooglePayButton(
          paymentConfigurationAsset: 'google_pay.json',
          paymentItems: paymentItems,
          type: pay.GooglePayButtonType.buy,
          margin: const EdgeInsets.only(top: 15.0),
          onPaymentResult: (data) {debugPrint('$data');},
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
          onPressed: () {  },
        ),
      ),
    );
  }
}
