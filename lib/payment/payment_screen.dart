import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../utils/app_color.dart';

class CheckOutPayment extends StatefulWidget {
  const CheckOutPayment({super.key});

  @override
  CheckOutPaymentState createState() => CheckOutPaymentState();
}
class CheckOutPaymentState extends State<CheckOutPayment> {

  CardEditController? controller = CardEditController();
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async{
                // Provider.of<PaymentController>(context,listen: false).makePayment(amount: '5', currency: 'INR',context: context);
                await Stripe.instance
                    .initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
                        customerId: paymentIntentData?['customer'],
                        setupIntentClientSecret: paymentIntentData?['client_secret'],
                        paymentIntentClientSecret: paymentIntentData?['client_secret'],
                        customerEphemeralKeySecret: paymentIntentData?['ephemeralKey'],
                        style: ThemeMode.dark,
                        billingDetails: const BillingDetails(
                            name: "Dheeraj",
                            email: 'mailto:dheeraj@gmail.com',
                            phone: '+30 123456789',
                            address: Address(
                                line1: 'Shivranjani',
                                line2: 'Shivranjani',
                                state: 'Gujarat',
                                postalCode: '12345',
                                city: 'Germany',
                                country: 'Germany')),)).then((value) async {
                                  await Stripe.instance.presentPaymentSheet().then((value){
                      });
                });
               },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(20.0,8,20,8),
                    child: Text(
                      'Make Payment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
