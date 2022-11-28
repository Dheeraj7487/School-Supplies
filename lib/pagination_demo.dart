import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_supplies_hub/utils/app_color.dart';

class PaginationDemo extends StatefulWidget {
  const PaginationDemo({Key? key}) : super(key: key);

  @override
  State<PaginationDemo> createState() => _PaginationDemoState();
}

class _PaginationDemoState extends State<PaginationDemo> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot? lastDocument;
  final ScrollController _scrollController = ScrollController();

  getProducts() async {
    if (!hasMore) {
      debugPrint('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('book_details')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('book_details')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      debugPrint('${1}');
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    products.addAll(querySnapshot.docs);
    debugPrint("$products");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: const Text('Flutter Pagination with Firestore'),
      ),
      body: Column(
       children: [
        Expanded(
          child: products.isEmpty
              ? const Center(
            child: Text('No Data...'),
          ) : ListView.builder(
            controller: _scrollController,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Image.network('${products[index]['bookImages'][0]}',height: 200,width: double.infinity,fit: BoxFit.fill,);
            },
          ),
        ),
        isLoading
            ? Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(5),
          color: AppColor.appColor,
          child: const Text(
            'Loading',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : Container()
      ]),
    );
  }
}
