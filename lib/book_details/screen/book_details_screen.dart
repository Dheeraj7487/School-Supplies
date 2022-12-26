// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:school_supplies_hub/add_details/auth/add_book_details_auth.dart';
import 'package:school_supplies_hub/book_details/provider/book_details_provider.dart';
import 'package:school_supplies_hub/home/provider/home_provider.dart';
import 'package:school_supplies_hub/utils/app_image.dart';
import 'package:school_supplies_hub/widgets/internet_screen.dart';
import '../../Firebase/firebase_collection.dart';
import '../../home/provider/internet_provider.dart';
import '../../shimmers/horizontal_shimmers.dart';
import '../../utils/app_color.dart';
import '../../video_player/video_player_screen.dart';
import '../auth/add_to_favorite_auth.dart';
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

  late Razorpay _razorpay;
  bool favorite = false;
  boolFavoriteCheck() async{
    var checkData = await FirebaseCollection().favoriteCollection.
    where('${widget.snapshotData['currentUser']}'
        '${widget.snapshotData['name']}').get();

    for(var snapshot in checkData.docChanges){
      if(snapshot.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email
          && widget.snapshotData['name'] == snapshot.doc.get('name')) {
        favorite = true;
        debugPrint('data Found');
      }
    }
  }

  void updateBookStock(){
    int bookStock = widget.snapshotData['itemAvailable'] - 1;
    debugPrint('Book Stock $bookStock');
    AddBookDetailsAuth().addBookDetails(
      uId: widget.snapshotData['userId'],
      publisherName: widget.snapshotData['publisherName'],
      userEmail: widget.snapshotData['userEmail'],
      userMobile: widget.snapshotData['userMobile'],
      bookName: widget.snapshotData['name'],
      price: widget.snapshotData['price'],
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
      bookDescription: widget.snapshotData['description'],
      itemAvailable: widget.snapshotData['itemAvailable'] - 1,
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
      'prefill': {'contact': Provider.of<HomeProvider>(context,listen: false).userMobile.toString(), 'email': Provider.of<HomeProvider>(context,listen: false).userEmail.toString()},
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
    BuyBookDetailAuth().buyBookDetails(
        price: '${int.parse(amount.floor().toString())}',
        discountPercentage: widget.snapshotData['discountPercentage'],
        publisherName: '${widget.snapshotData['publisherName']}',
        userEmail: Provider.of<HomeProvider>(context,listen: false).userEmail.toString(),
        itemAvailable: widget.snapshotData['itemAvailable'],
        userMobile: Provider.of<HomeProvider>(context,listen: false).userMobile.toString(),
        userAddress: Provider.of<HomeProvider>(context,listen: false).userAddress.toString(),
        bookName: '${widget.snapshotData['name']}',
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
    boolFavoriteCheck();
    Provider.of<HomeProvider>(context,listen: false).getUserData();
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
    return Consumer2<InternetProvider,BookDetailProvider>(
        builder: (context, internetSnapshot,bookDetailProvider, _) {
          internetSnapshot.checkInternet().then((value) {});
          return Scaffold(
            backgroundColor: AppColor.appColor,
            appBar: AppBar(
              title: Text(widget.snapshotData['name']),
              actions: [
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(Icons.rate_review_outlined, color: AppColor.whiteColor, size: 20),
                          const SizedBox(width: 10),
                          Text("Review",
                              style: Theme.of(context).textTheme.subtitle1)
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(favorite ? Icons.favorite_border : Icons.favorite, color: AppColor.whiteColor, size: 20),
                          const SizedBox(width: 10),
                          Text(favorite ? "Remove to favorite" : "Add to favorite",
                              style: Theme.of(context).textTheme.subtitle1)
                        ],
                      ),
                    ),
                  ],
                  offset: const Offset(0, 37),
                  color: AppColor.appColor,
                  elevation: 2,
                  onSelected: (value) async{
                    if (value == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GiveReviewScreen(
                                snapshotData: widget.snapshotData,
                              )));
                    }
                    else if(value == 2) {
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
                            toolImages: '',
                            timestamp: widget.snapshotData['timeStamp'],
                            uId:  widget.snapshotData['userId'],
                            description:  widget.snapshotData['description'],
                            rating:  widget.snapshotData['bookRating'],
                            currentUser:  '${FirebaseAuth.instance.currentUser?.email}',
                            authorName: widget.snapshotData['authorName'],
                            selectedSemester: widget.snapshotData['selectedSemester'],
                            selectedCourse: widget.snapshotData['selectedCourse'],
                            selectedClass: widget.snapshotData['selectedClass'],
                            bookImages: widget.snapshotData['bookImages'],
                            bookVideo: widget.snapshotData['bookVideo']);
                      }
                      else {
                        for (var snapshot in checkData.docChanges) {
                          if (snapshot.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email &&
                              widget.snapshotData['name'] == snapshot.doc.get('name')) {

                            debugPrint('${snapshot.doc.get('currentUser') == FirebaseAuth.instance.currentUser?.email}');
                            debugPrint('${widget.snapshotData['name'] == snapshot.doc.get('name')}');

                            favorite = false;
                            FirebaseCollection().favoriteCollection.doc(
                                '${FirebaseAuth.instance.currentUser?.email}''${widget.snapshotData['name']}').delete();
                          }
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            body: !internetSnapshot.isInternet ? noInternetDialog() : SingleChildScrollView(
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
                                    widget.snapshotData['bookImages'][bookDetailProvider.bookIndex],
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
                                    bookDetailProvider.getBookIndexData(index);
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
                          child: Text(widget.snapshotData['name'],
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
                              Text('Book Price : ${widget.snapshotData['price']}'),
                              Text('Discount : ${widget.snapshotData['discountPercentage']}%'),
                            ],
                          ),
                        ),
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
                              SizedBox(height: 5,),
                              Text('Rarely Used\n Condition', textAlign: TextAlign.center,)
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
                    Text(widget.snapshotData['description'],
                        style: const TextStyle(fontSize: 12, color: AppColor.greyColor)),
                    const SizedBox(height: 20),
                    Text('Related Books', style: Theme.of(context).textTheme.headline4,),
                    const SizedBox(height: 5),
                    StreamBuilder(
                        stream: FirebaseCollection().addBookCollection.
                        // where('name',isNotEqualTo: widget.snapshotData['name'])
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
                                                      snapshotData: snapshot.data?.docs[index],
                                                      bookImages: snapshot.data!.docs[index]['bookImages'],
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
                                                    snapshot.data!.docs[index]['bookImages'][0],
                                                    height: 120,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(3.0, 5, 3, 0),
                                                child: Text(
                                                    snapshot.data!.docs[index]['name'],
                                                    style: Theme.of(context).textTheme.headline4,
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
                        //where('name',isNotEqualTo: widget.snapshotData['name']).
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
                                                    snapshot.data!.docs[index]['bookImages'][1],
                                                    height: 120, width: double.infinity,
                                                    fit: BoxFit.fill
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    3.0, 5, 3, 0),
                                                child: Text(
                                                    snapshot.data!.docs[index]
                                                    ['name'],
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
            ),
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
                            "${(double.parse(widget.snapshotData['price']) - double.parse(widget.snapshotData['price']) * widget.snapshotData['discountPercentage'] / 100).floor()}",
                            style: const TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                  GestureDetector(
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
                                                onTap: () async {
                                                  bookDetailProvider.stripePayment(widget.snapshotData['price'],
                                                      widget.snapshotData['discountPercentage'],
                                                      context, Provider.of<HomeProvider>(context,listen: false).userName.toString(),
                                                      Provider.of<HomeProvider>(context,listen: false).userEmail.toString(),
                                                      Provider.of<HomeProvider>(context,listen: false).userMobile.toString(),
                                                      Provider.of<HomeProvider>(context,listen: false).userAddress.toString(),
                                                      widget.snapshotData['name'],
                                                      widget.snapshotData['publisherName'], widget.snapshotData['selectedClass'],
                                                      widget.snapshotData['bookVideo'],
                                                      widget.bookImages,
                                                      widget.snapshotData['selectedCourse'], widget.snapshotData['selectedSemester'],
                                                      widget.snapshotData['authorName'], widget.snapshotData['bookRating'],
                                                      widget.snapshotData['userId'],
                                                      widget.snapshotData['description'], widget.snapshotData['currentUser'],
                                                      widget.snapshotData['itemAvailable']);
                                                },
                                                child: bottomSheet(AppImage.stripe,)),
                                            const SizedBox(height: 10,),
                                            GestureDetector(
                                                onTap : () {
                                                  openCheckout();
                                                },
                                                child: bottomSheet(AppImage.razorpay)),
                                            const SizedBox(height: 10,),
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
                                            const SizedBox(height: 10,),*/
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
                    child:
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColor.greyColor,
                          borderRadius: BorderRadius.circular(10)),
                      child : widget.snapshotData['itemAvailable'] == 0 ?
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
                          Icon(Icons.arrow_forward_outlined,
                            color: AppColor.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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