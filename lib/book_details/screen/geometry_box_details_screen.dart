import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:school_supplies_hub/book_details/auth/add_to_favorite_auth.dart';
import '../../Firebase/firebase_collection.dart';
import '../../add_details/auth/add_geometry_details_auth.dart';
import '../../payment/geomatry_stripe_controller.dart';
import '../../payment/payment_screen.dart';
import '../../utils/app_color.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../../utils/app_image.dart';
import '../auth/buy_geometry_box_detail_auth.dart';

class GeometryBoxDetailScreen extends StatefulWidget {
  var snapshotData;
  GeometryBoxDetailScreen({Key? key,required this.snapshotData}) : super(key: key);

  @override
  State<GeometryBoxDetailScreen> createState() => _GeometryBoxDetailScreenState();
}

class _GeometryBoxDetailScreenState extends State<GeometryBoxDetailScreen> {

  bool favorite = false;

  Map<String, dynamic>? paymentIntentData;

  late Razorpay _razorpay;
  String? userName,userEmail,userMobile,userAddress;

  boolFavoriteCheck() async{
    var checkData = await FirebaseCollection().favoriteCollection.
    where('${widget.snapshotData['currentUser']}'
        '${widget.snapshotData['name']}').get();

    for(var snapshot in checkData.docChanges){
     // setState(() {

      if(snapshot.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email
          && widget.snapshotData['name'] == snapshot.doc.get('name')) {
        favorite = true;
        debugPrint('data Found');
      }

     // });
    }
  }

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

  void updateToolStock(){

    AddGeometryBoxDetailsAuth().addGeometryBoxDetails(
        uId: widget.snapshotData['userId'],
        publisherName: widget.snapshotData['publisherName'],
        userEmail: widget.snapshotData['userEmail'],
        userMobile: widget.snapshotData['userMobile'],
        price: widget.snapshotData['price'],
        toolDescription: widget.snapshotData['description'],
        discountPercentage: widget.snapshotData['discountPercentage'],
        itemAvailable: widget.snapshotData['itemAvailable'] - 1,
        toolName: widget.snapshotData['name'],
        toolImages: widget.snapshotData['toolImages'],
        toolRating: widget.snapshotData['rating'],
        currentUser: widget.snapshotData['currentUser'],
        timestamp: DateTime.now().toString()
    );
  }

  void openCheckout() async {
    double amount = double.parse(widget.snapshotData['price']);
    amount = amount - amount * widget.snapshotData['discountPercentage'] / 100;
    setState(() {});

    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': amount.floor()*100,
      'name': "${widget.snapshotData['name']}",
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

    double amount = double.parse(widget.snapshotData['price']);
    amount = amount - amount * widget.snapshotData['discountPercentage'] / 100;
    setState(() {});
    BuyToolBoxDetailAuth().buyToolBoxDetails(
        uId: widget.snapshotData['userId'],
        publisherName: widget.snapshotData['userId'],
        userEmail: userEmail.toString(),
        userMobile: userMobile.toString(),
        price: '${int.parse(amount.floor().toString())}',
        discountPercentage: widget.snapshotData['discountPercentage'],
        toolAvailable: widget.snapshotData['itemAvailable'] - 1,
        toolName: widget.snapshotData['name'],
        toolImages: widget.snapshotData['toolImages'],
        timestamp: DateTime.now().toString(),
        userAddress: userAddress.toString()
    );
    updateToolStock();
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
    boolFavoriteCheck();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(widget.snapshotData['toolImages'],
                    height: MediaQuery.of(context).size.height/3, width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                     left: 10,top: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.greyColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(100)
                        ), child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.arrow_back_outlined,color: AppColor.whiteColor),
                        ),
                      )
                  ),

                  Positioned(
                      right: 10,top: 7,
                      child: IconButton(
                        onPressed: () async{
                          var checkData = await FirebaseCollection().favoriteCollection.
                          where('${widget.snapshotData['currentUser']}'
                              '${widget.snapshotData['name']}').get();

                          if(favorite == false){
                            favorite = true;
                            AddToFavoriteAuth().addToFavorite(
                                publisherName: widget.snapshotData['publisherName'],
                                userEmail: widget.snapshotData['userEmail'],
                                userMobile: widget.snapshotData['userMobile'],
                                name: widget.snapshotData['name'], price: widget.snapshotData['price'],
                                itemAvailable: widget.snapshotData['itemAvailable'],
                                discountPercentage: widget.snapshotData['discountPercentage'],
                                toolImages: widget.snapshotData['toolImages'],
                                timestamp: widget.snapshotData['timeStamp'],
                                uId:  widget.snapshotData['userId'],
                                description:  widget.snapshotData['description'],
                                rating:  widget.snapshotData['rating'],
                                currentUser:  '${FirebaseAuth.instance.currentUser?.email}',
                                authorName: '', selectedSemester: '', selectedCourse: '',
                                selectedClass: '', bookImages: [], bookVideo: '');
                          }
                          else {
                            for (var snapshot in checkData.docChanges) {
                              if (snapshot.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email &&
                                  widget.snapshotData['name'] == snapshot.doc.get('name')) {

                                debugPrint('${snapshot.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email}');
                                debugPrint('${widget.snapshotData['name'] ==
                                    snapshot.doc.get('name')}');

                                favorite = false;
                                FirebaseCollection().favoriteCollection.doc(
                                    '${FirebaseAuth.instance.currentUser?.email}''${widget.snapshotData['name']}').delete();
                              }
                            }
                          }
                          setState(() {});
                        },
                        icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,size: 30,color: AppColor.greenColor,),
                      )
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,10,20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.snapshotData['name'],
                            style: Theme.of(context).textTheme.headline2,maxLines: 2,overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 10),
                        Text("₹${widget.snapshotData['price']}",style: const TextStyle(fontSize: 22,color: AppColor.redColor),)
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              SizedBox(height: 5,),
                              Text('Rarely Used\n Condition', textAlign: TextAlign.center)
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
                              const Icon(Icons.date_range, color: AppColor.whiteColor),
                              const SizedBox(height: 5,),
                              Text('Posted On\n ${DateFormat('dd MMM').format(DateTime.parse(widget.snapshotData['timeStamp']))}',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

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
                                  child: Text(widget.snapshotData['publisherName'].toString().substring(0, 1),
                                    style: const TextStyle(fontSize: 18),
                                  ))
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Posted By\n",
                                      style: Theme.of(context).textTheme.subtitle1),
                                  TextSpan(
                                      text: "${widget.snapshotData['publisherName']}",
                                      style: const TextStyle(color: AppColor.greyColor,fontSize: 20,overflow: TextOverflow.ellipsis))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text('Discount : ${widget.snapshotData['discountPercentage']}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),)),
                        Visibility(
                          visible: widget.snapshotData['itemAvailable'] != 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15,7,15,7),
                            decoration: BoxDecoration(
                                color: AppColor.darkWhiteColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text('In Stock ${widget.snapshotData['itemAvailable']}',
                              style: const TextStyle(color : AppColor.appColor,fontWeight: FontWeight.w500),),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),
                    Text('Description', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 5),
                    Text(widget.snapshotData['description']),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: widget.snapshotData['currentUser'] == FirebaseAuth.instance.currentUser?.email ?
        const SizedBox() : Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: GestureDetector(
            onTap: widget.snapshotData['itemAvailable'] == 0 ? null : () async {
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
                                        onTap : () {
                                          openCheckout();
                                        },
                                        child: bottomSheet(AppImage.razorpay)),
                                    const SizedBox(height: 10,),

                                    GestureDetector(
                                        onTap: () async {
                                          double amount = double.parse(widget.snapshotData['price']);
                                          amount = amount - amount *
                                              widget.snapshotData['discountPercentage'] / 100;
                                          // print(int.parse(amount.floor().toString()));
                                          setState(() {});
                                          GeometryPaymentController().makePayment(
                                              amount: '${int.parse(amount.floor().toString())}',
                                              discountPercentage: widget.snapshotData['discountPercentage'],
                                              currency: 'INR',
                                              context: context,
                                              publisherName: '${widget.snapshotData['publisherName']}',
                                              userEmail: userEmail.toString(),
                                              userMobile: userMobile.toString(),
                                              userAddress: userAddress.toString(),
                                              toolName: '${widget.snapshotData['name']}',
                                              toolImage: '${widget.snapshotData['toolImages']}',
                                              timeStamp: DateTime.now().toString(),
                                              userId: widget.snapshotData['userId'],
                                              currentUser: widget.snapshotData['currentUser'],
                                              toolDescription: widget.snapshotData['description'],
                                              itemAvailable: widget.snapshotData['itemAvailable'] - 1,
                                              toolPrice: '${widget.snapshotData['price']}',
                                              toolRating: widget.snapshotData['rating']
                                          );

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

                                    /* GestureDetector(
                                        onTap: () async{
                                          await PaytmConfig().generateTxnToken(1, 'OREDRID_7487026406');
                                        }, child: bottomSheet(AppImage.paytm)),
                                    const SizedBox(height: 10,),
                                    GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const GooglePayScreen()));
                                        },
                                        child: bottomSheet(AppImage.googlePay)),
                                    const SizedBox(height: 10,), */
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
            child: Card(
              color: AppColor.greyColor.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(child: Text( widget.snapshotData['itemAvailable'] == 0 ? 'Out of Stock' : 'Buy Now')),
              ),
            ),
          ),
        )

        /*
        Padding(
          padding: const EdgeInsets.fromLTRB(10,10,10,10),
          child: Card(
            color: AppColor.greyColor.withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(child: Text('Buy Now')),
            ),
          ),
        ),
       */
      ),
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
