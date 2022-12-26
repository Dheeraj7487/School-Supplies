import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../../payment/payment_controller.dart';
import '../../payment/payment_screen.dart';



class BookDetailProvider extends ChangeNotifier{

  int bookIndex = 0;
  Map<String, dynamic>? paymentIntentData;

  get getBookIndex{
    notifyListeners();
    return bookIndex;
  }

  void getBookIndexData(int index){
    bookIndex = index;
    notifyListeners();
  }

  void stripePayment(String price,int discountPercentage,BuildContext context,
      String userName, String userEmail,String userMobile,String userAddress,
      String bookName, String publisherName,String selectedClass,String bookVideo,List bookImages,
      String selectedCourse,String selectedSemester,String authorName,double bookRating,
      String userId,String bookDescription,String currentUser,int itemAvailable
      ) async{
    double amount = double.parse(price);
    amount = amount - amount *
        discountPercentage / 100;
    // print(int.parse(amount.floor().toString()));
    notifyListeners();
    PaymentController().makePayment(
        amount: '${int.parse(amount.floor().toString())}',
        discountPercentage: discountPercentage,
        currency: 'INR',
        context: context,
        publisherName: publisherName,
        userEmail: userEmail.toString(),
        userMobile: userMobile.toString(),
        userAddress: userAddress.toString(),
        bookName: bookName,
        selectedClass: selectedClass,
        bookVideo: bookVideo,
        bookImage: bookImages,
        selectedCourse: selectedCourse,
        selectedSemester: selectedSemester,
        authorName: authorName,
        timeStamp: DateTime.now().toString(),
        userId: userId,
        bookPrice: price,
        bookRating: bookRating,
        currentUser: currentUser,
        bookDescription: bookDescription,
        itemAvailable: itemAvailable - 1);

    await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          customerId: paymentIntentData?['customer'],
          setupIntentClientSecret: paymentIntentData?['client_secret'],
          paymentIntentClientSecret: paymentIntentData?['client_secret'],
          customerEphemeralKeySecret: paymentIntentData?['ephemeralKey'],
          style: ThemeMode.dark,
          billingDetails: stripe.BillingDetails(name: userName.toString(),
            email: 'mailto:${userEmail.toString()}',
            phone: userMobile.toString(),
            /*address: stripe.Address(
                                                            line1: 'shivranjni',
                                                            line2: 'shivranjni',
                                                            state: 'Gujarat',
                                                            postalCode: '12345',
                                                            city: 'Germany',
                                                            country: 'Germany')*/
          ),
        )).then((value) async {
      await stripe.Stripe.instance.presentPaymentSheet().then((value) {});
    });
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => const CheckOutPayment()));
  }
}