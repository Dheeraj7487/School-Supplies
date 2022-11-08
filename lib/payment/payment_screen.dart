import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import 'package:pay/pay.dart';
import 'package:pay/pay.dart' as pay;

class GooglePay extends StatefulWidget {
  const GooglePay({super.key});

  @override
  _GooglePayState createState() => _GooglePayState();
}
class _GooglePayState extends State<GooglePay> {
  List<PaymentItem> get paymentItems {
    const paymentItems = [
      pay.PaymentItem(
        label: 'Total Amount',
        amount: '450',
        status: pay.PaymentItemStatus.final_price,
      )
    ];
    return paymentItems;
  }

  @override
  void initState() {
    debugPrint("$paymentItems");
   // Stripe.instance.isApplePaySupported.addListener(update);
    super.initState();
  }
  // @override
  // void dispose() {
  //  // Stripe.instance.isApplePaySupported.removeListener(update);
  //   super.dispose();
  // }
  void update() {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: GooglePayButton(
               paymentConfigurationAsset: 'google_pay.json',
               paymentItems: paymentItems,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                  print(data);
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
                onPressed: () {  },
              ),
            ),
            // if (Stripe.instance.isApplePaySupported.value)
            //   Padding(
            //     padding: EdgeInsets.all(16),
            //     child:
            //     GooglePayButton(
            //         //paymentConfigurationAsset: 'google_pay_payment_profile.json',
            //         //paymentItems: _paymentItems,
            //         // style: GooglePayButtonStyle.black,
            //         // type: GooglePayButtonType.pay,
            //         // margin: const EdgeInsets.only(top: 16),
            //         // onPaymentResult: onGooglePayResult,
            //         // loadingIndicator: const Center(
            //         //   child: CircularProgressIndicator(),
            //         // ),
            //         onTap: () async {
            //         }
            //     ),
            //   )
            // else
            //   Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16),
            //     child: Text('Apple Pay is not available in this device'),
            //   ),
          ],
        ),
      ),
    );
  }
}

// Future<void> onGooglePayResult(paymentResult) async {
//   try {
//   } catch (e) {
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:school_supplies_hub/utils/app_color.dart';
//
// class PaymentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appColor,
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           // CardField(
//           //   onCardChanged: (card) {
//           //     print(card);
//           //   },
//           // ),
//           TextButton(
//             onPressed: () async {
//               // create payment method
//               const billingDetails = BillingDetails(
//                 email: 'dheeraj@gmail.com',
//                 phone: '+917487026406',
//                 address: Address(
//                   city: 'Sirohi',
//                   country: 'INDIA',
//                   line1: 'Aburoad Sirohi',
//                   line2: '',
//                   state: 'Rajasthan',
//                   postalCode: '307023',
//                 ),
//               );
//
//               const shippingDetails = ShippingDetails(
//                 phone: '+48888000888',
//                 address: Address(
//                   city: 'Sirohi',
//                   country: 'INDIA',
//                   line1: 'Aburoad Sirohi',
//                   line2: '',
//                   state: 'Rajasthan',
//                   postalCode: '307023',
//                 ),
//               );
//
//               final paymentMethod = await Stripe.instance.createPaymentMethod(params: PaymentMethodParams.card(
//               paymentMethodData: PaymentMethodData(
//               billingDetails: billingDetails)));
//             },
//             child: Text('pay'),
//           )
//         ],
//       ),
//     );
//   }
// }