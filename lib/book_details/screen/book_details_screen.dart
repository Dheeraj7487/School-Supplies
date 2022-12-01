// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:school_supplies_hub/add_details/auth/add_book_details_auth.dart';
import 'package:school_supplies_hub/payment/google_payment.dart';
import 'package:school_supplies_hub/payment/paytm.dart';
import 'package:school_supplies_hub/utils/app_image.dart';
import 'package:school_supplies_hub/widgets/internet_screen.dart';
import '../../Firebase/firebase_collection.dart';
import '../../home/provider/internet_provider.dart';
import '../../payment/payment_controller.dart';
import '../../payment/payment_screen.dart';
import '../../shimmers/horizontal_shimmers.dart';
import '../../utils/app_color.dart';
import '../../video_player/video_player_screen.dart';
import '../auth/buy_book_detail_auth.dart';
import 'give_rating_screen.dart';

class BookDetailScreen extends StatefulWidget {
  dynamic snapshotData;
  List bookImages;

  BookDetailScreen({Key? key, required this.snapshotData, required this.bookImages}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int bookIndex = 0;
  Map<String, dynamic>? paymentIntentData;

  late Razorpay _razorpay;
  String? userName,userEmail,userMobile,userAddress;

  getUserData() async {
    var userData = await FirebaseCollection().userCollection
        .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

    for (var data in userData.docChanges) {
      userName = data.doc.get('userName');
      userEmail = data.doc.get('userEmail');
      userMobile = data.doc.get('userMobile');
      userAddress = data.doc.get('userAddress');
      setState(() {});
    }
  }

  void updateBookStock(){
    int bookStock = widget.snapshotData['bookAvailable'] - 1;
    debugPrint('Book Stock $bookStock');
    AddBookDetailsAuth().addBookDetails(
      uId: widget.snapshotData['userId'],
      publisherName: widget.snapshotData['publisherName'],
      userEmail: widget.snapshotData['userEmail'],
      userMobile: widget.snapshotData['userMobile'],
      bookName: widget.snapshotData['bookName'],
      price: widget.snapshotData['bookPrice'],
      discountPercentage : widget.snapshotData['discountPercentage'],
      bookVideo: widget.snapshotData['bookVideo'],
      bookImages: widget.bookImages,
      selectedClass: widget.snapshotData['selectedClass'],
      selectedCourse: widget.snapshotData['selectedCourse'],
      selectedSemester: widget.snapshotData['selectedSemester'],
      authorName: widget.snapshotData['authorName'],
      timestamp: widget.snapshotData['timeStamp'],
      bookRating: widget.snapshotData['bookRating'],
      currentUser: widget.snapshotData['currentUser'],
      bookDescription: widget.snapshotData['bookDescription'],
      bookAvailable: widget.snapshotData['bookAvailable'] - 1,
    );
  }

  void openCheckout() async {
    double amount = double.parse(widget.snapshotData['bookPrice']);
    amount = amount - amount * widget.snapshotData['discountPercentage'] / 100;
    setState(() {});

    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': amount.floor()*100,
      'name': "${widget.snapshotData['bookName']}",
      'description': "",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': userMobile.toString(), 'email': userEmail.toString()},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('Success Response: $response');
   // AppUtils.instance.showSnackBar(context, "EXTERNAL_WALLET: ${response.paymentId}");

    double amount = double.parse(widget.snapshotData['bookPrice']);
    amount = amount - amount * widget.snapshotData['discountPercentage'] / 100;
    setState(() {});
    BuyBookDetailAuth().buyBookDetails(
        price: '${int.parse(amount.floor().toString())}',
        discountPercentage: widget.snapshotData['discountPercentage'],
        publisherName: '${widget.snapshotData['publisherName']}',
        userEmail: userEmail.toString(),
        bookAvailable: widget.snapshotData['bookAvailable'],
        userMobile: userMobile.toString(),
        userAddress: userAddress.toString(),
        bookName: '${widget.snapshotData['bookName']}',
        selectedClass: '${widget.snapshotData['selectedClass']}',
        bookVideo: '${widget.snapshotData['bookVideo']}',
        bookImages: widget.bookImages,
        selectedCourse: '${widget.snapshotData['selectedCourse']}',
        selectedSemester: '${widget.snapshotData['selectedSemester']}',
        authorName: '${widget.snapshotData['authorName']}',
        timestamp: DateTime.now().toString());

    updateBookStock();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Error Response: $response');
   // AppUtils.instance.showSnackBar(context, "EXTERNAL_WALLET: ${response.message}");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External SDK Response: $response');
    //AppUtils.instance.showSnackBar(context, "EXTERNAL_WALLET: ${response.walletName}");
  }

  @override
  void initState()  {
    getUserData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
        builder: (context, internetSnapshot, _) {
          internetSnapshot.checkInternet().then((value) {});
          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColor.appColor,
              appBar: AppBar(
              title: Text(widget.snapshotData['bookName']),
              actions: [
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(Icons.rate_review_outlined,
                              color: AppColor.whiteColor, size: 20),
                          const SizedBox(width: 10),
                          Text("Review",
                              style: Theme.of(context).textTheme.subtitle1)
                        ],
                      ),
                    ),
                  ],
                  offset: const Offset(0, 37),
                  color: AppColor.appColor,
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GiveReviewScreen(
                                    snapshotData: widget.snapshotData,
                                  )));
                    }
                  },
                ),
              ],
            ),
              body: internetSnapshot.isInternet ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Stack(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                                widget.snapshotData['bookImages'][bookIndex],
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 3,
                                fit: BoxFit.fill)),
                      ],
                    )),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        height: 80,
                        child: ListView.builder(
                            itemCount: widget.bookImages.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bookIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 3,
                                          color: AppColor.greyColor,
                                        )),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(widget.bookImages[index],
                                            height:
                                                MediaQuery.of(context).size.height /
                                                    4,
                                            width: 50,
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.snapshotData['bookName'],
                              style: Theme.of(context).textTheme.headline2,maxLines: 1,overflow: TextOverflow.ellipsis,),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoPlayerScreen(
                                          imageUrl:
                                              widget.snapshotData['bookVideo'])));
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 5),
                              decoration: BoxDecoration(
                                  color: AppColor.greyColor,
                                  borderRadius: BorderRadius.circular(100)),
                              child: const Icon(
                                Icons.play_arrow,
                                color: AppColor.whiteColor,
                                size: 22,
                              ),
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Author : ${widget.snapshotData['authorName']}',maxLines: 1,overflow: TextOverflow.ellipsis,),
                              const SizedBox(height: 5),
                              Text('Class : ${widget.snapshotData['selectedClass']}'),
                              const SizedBox(height: 5),
                              Text('Book Type : ${widget.snapshotData['selectedCourse']}'),
                              const SizedBox(height: 10),
                              Text('Book Price : ${widget.snapshotData['bookPrice']}'),
                              Text('Discount : ${widget.snapshotData['discountPercentage']}%'),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.snapshotData['bookAvailable'] != 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20,10,20,10),
                            decoration: BoxDecoration(
                              color: AppColor.darkWhiteColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text('In Stock ${widget.snapshotData['bookAvailable']}',
                              style: const TextStyle(color : AppColor.appColor,fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColor.greyColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: const [
                              Icon(Icons.book_outlined, color: AppColor.whiteColor),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Rarely Used\n Condition',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColor.greyColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              const Icon(Icons.date_range,
                                  color: AppColor.whiteColor),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Posted On\n ${DateFormat('dd MMM').format(DateTime.parse(widget.snapshotData['timeStamp']))}',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        //    color: AppColor.greyColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.greyColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                              width: 55,
                              height: 55,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColor.greyColor,
                              ),
                              child: Center(
                                  child: Text(
                                widget.snapshotData['publisherName']
                                    .toString()
                                    .substring(0, 1),
                                style: const TextStyle(fontSize: 18),
                              ))),
                          const SizedBox(
                            width: 20,
                          ),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "Posted By\n",
                                    style: Theme.of(context).textTheme.subtitle1),
                                TextSpan(
                                    text: "${widget.snapshotData['publisherName']}",
                                    style: Theme.of(context).textTheme.headline2)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Description', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 5),
                    Text(widget.snapshotData['bookDescription'],
                        style: const TextStyle(fontSize: 12, color: AppColor.greyColor)),
                    const SizedBox(height: 20),
                    Text('Related Books', style: Theme.of(context).textTheme.headline4,),
                    const SizedBox(height: 5),
                    StreamBuilder(
                        stream: FirebaseCollection().addBookCollection.
                            // where('bookName',isNotEqualTo: widget.snapshotData['bookName'])
                            where('selectedCourse', isEqualTo: widget.snapshotData['selectedCourse']).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: HorizontalShimmers(height: 175,width: 150,));
                          } else if (snapshot.hasError) {
                            return Center(child: HorizontalShimmers(height: 175,width: 150,));
                          } else if (!snapshot.hasData) {
                            return const SizedBox();
                          } else if (snapshot.requireData.docChanges.isEmpty) {
                            return const SizedBox();
                          } else if (snapshot.hasData) {
                            return SizedBox(
                              height: 180,
                              child: ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BookDetailScreen(
                                                      snapshotData:
                                                          snapshot.data?.docs[index],
                                                      bookImages: snapshot.data!
                                                          .docs[index]['bookImages'],
                                                    )));
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 180,
                                        padding: const EdgeInsets.only(right: 5),
                                        child: Card(
                                          elevation: 5,
                                          color: AppColor.appColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(10),
                                                    topLeft: Radius.circular(10)),
                                                child: Image.network(
                                                    snapshot.data!.docs[index]
                                                        ['bookImages'][0],
                                                    height: 120,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    3.0, 5, 3, 0),
                                                child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['bookName'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return Center(child: HorizontalShimmers(height: 175,width: 150,));
                          }
                        }),
                    const SizedBox(height: 20),
                    Text('Similar Class', style: Theme.of(context).textTheme.headline4,),
                    const SizedBox(height: 5),
                    StreamBuilder(
                        stream: FirebaseCollection().addBookCollection.
                            //where('bookName',isNotEqualTo: widget.snapshotData['bookName']).
                            where('selectedClass', isEqualTo: widget.snapshotData['selectedClass']).snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: HorizontalShimmers(height: 175,width: 150,));
                          } else if (snapshot.hasError) {
                            return Center(child: HorizontalShimmers(height: 175,width: 150,));
                          } else if (!snapshot.hasData) {
                            return const SizedBox();
                          } else if (snapshot.requireData.docChanges.isEmpty) {
                            return const SizedBox();
                          } else if (snapshot.hasData) {
                            return SizedBox(
                              height: 180,
                              child: ListView.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BookDetailScreen(
                                                      snapshotData:
                                                          snapshot.data?.docs[index],
                                                      bookImages: snapshot.data!
                                                          .docs[index]['bookImages'],
                                                    )));
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 180,
                                        padding: const EdgeInsets.only(right: 5),
                                        child: Card(
                                          elevation: 5,
                                          color: AppColor.appColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(10),
                                                    topLeft: Radius.circular(10)),
                                                child: Image.network(
                                                    snapshot.data!.docs[index]
                                                        ['bookImages'][1],
                                                    height: 120,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    3.0, 5, 3, 0),
                                                child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['bookName'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return Center(child: HorizontalShimmers(height: 175,width: 150,));
                          }
                        }),
                  ],
                ),
              ),
            ) : noInternetDialog(),
            bottomNavigationBar: widget.snapshotData['currentUser'] == FirebaseAuth.instance.currentUser?.email || !internetSnapshot.isInternet ?
            const SizedBox() : Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: AppColor.redColor, fontSize: 24),
                      children: [
                        const TextSpan(text: "₹ "),
                        TextSpan(
                            text:
                            "${(double.parse(widget.snapshotData['bookPrice']) - double.parse(widget.snapshotData['bookPrice']) * widget.snapshotData['discountPercentage'] / 100).floor()}",
                            style: const TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.snapshotData['bookAvailable'] == 0 ? null : () async {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return Wrap(
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10), color: AppColor.whiteColor),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  double amount = double.parse(widget.snapshotData['bookPrice']);
                                                  amount = amount - amount *
                                                      widget.snapshotData['discountPercentage'] / 100;
                                                  // print(int.parse(amount.floor().toString()));
                                                  setState(() {});
                                                  PaymentController().makePayment(
                                                      amount: '${int.parse(amount.floor().toString())}',
                                                      discountPercentage: widget.snapshotData['discountPercentage'],
                                                      currency: 'INR',
                                                      context: context,
                                                      publisherName: '${widget.snapshotData['publisherName']}',
                                                      userEmail: userEmail.toString(),
                                                      userMobile: userMobile.toString(),
                                                      userAddress: userAddress.toString(),
                                                      bookName: '${widget.snapshotData['bookName']}',
                                                      selectedClass: '${widget.snapshotData['selectedClass']}',
                                                      bookVideo: '${widget.snapshotData['bookVideo']}',
                                                      bookImage: widget.bookImages,
                                                      selectedCourse: '${widget.snapshotData['selectedCourse']}',
                                                      selectedSemester: '${widget.snapshotData['selectedSemester']}',
                                                      authorName: '${widget.snapshotData['authorName']}',
                                                      timeStamp: DateTime.now().toString(),
                                                      userId: widget.snapshotData['userId'],
                                                      bookPrice: '${widget.snapshotData['bookPrice']}',
                                                      bookRating: widget.snapshotData['bookRating'],
                                                      currentUser: widget.snapshotData['currentUser'],
                                                      bookDescription: widget.snapshotData['bookDescription'],
                                                      bookAvailable: widget.snapshotData['bookAvailable'] - 1);

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
                                                },
                                                child: bottomSheet(AppImage.stripe,)),
                                            const SizedBox(height: 10,),
                                            GestureDetector(
                                                onTap : () {
                                                  openCheckout();
                                                },
                                                child: bottomSheet(AppImage.razorpay)),
                                            const SizedBox(height: 10,),
                                            GestureDetector(
                                                onTap: () async{
                                                  await PaytmConfig().generateTxnToken(1, 'OREDRID_7487026406');
                                                }, child: bottomSheet(AppImage.paytm)),
                                            const SizedBox(height: 10,),
                                            GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const GooglePayScreen()));
                                                },
                                                child: bottomSheet(AppImage.googlePay)),
                                            const SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColor.greyColor,
                          borderRadius: BorderRadius.circular(10)),
                      child : widget.snapshotData['bookAvailable'] == 0 ?
                      const Text('Out of Stock',
                        style: TextStyle(color: AppColor.whiteColor, fontSize: 16), textAlign: TextAlign.center,
                      ) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Buy Now',
                            style:
                            TextStyle(color: AppColor.whiteColor, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_outlined,
                            color: AppColor.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
          );
      }
    );
  }

  Widget bottomSheet(String image) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8.0),
      decoration: BoxDecoration(
          color: AppColor.appColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Pay with',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            width: 10,
          ),
          Image.asset(
            image, height: 30, width: 30,
          )
        ],
      ),
    );
  }

}
