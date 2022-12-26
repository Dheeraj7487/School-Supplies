import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/Firebase/firebase_collection.dart';
import 'package:school_supplies_hub/book_details/screen/book_details_screen.dart';
import 'package:school_supplies_hub/utils/app_color.dart';
import 'package:school_supplies_hub/video_player/video_player_screen.dart';
import 'package:school_supplies_hub/widgets/internet_screen.dart';

import '../provider/internet_provider.dart';

class PopularBooksScreen extends StatefulWidget {
  const PopularBooksScreen({Key? key}) : super(key: key);

  @override
  State<PopularBooksScreen> createState() => _PopularBooksScreenState();
}

class _PopularBooksScreenState extends State<PopularBooksScreen> {

  List<DocumentSnapshot> books = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 20;
  DocumentSnapshot? lastDocument;
  final ScrollController _scrollController = ScrollController();

  getBooks() async {
    if (!hasMore) {
      debugPrint('No More Books');
      setState(() {
        isLoading = false;
      });
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
      querySnapshot = await FirebaseCollection().addBookCollection.limit(documentLimit).get();
    } else {
      querySnapshot = await FirebaseCollection().addBookCollection
          .startAfterDocument(lastDocument!).limit(documentLimit).get();
      //debugPrint('${1}');
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    books.addAll(querySnapshot.docs);
    debugPrint("$books");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBooks();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: const Text('All Book'),
      ),
      body: Consumer<InternetProvider>(
          builder: (context, internetSnapshot, _) {
            internetSnapshot.checkInternet().then((value) {});
            return internetSnapshot.isInternet ? Column(
            children: [
              Expanded(
                child: books.isEmpty ? const Center(child: Text('No Data...'),) :
                ListView.builder(
                    itemCount: books.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              BookDetailScreen(snapshotData: books[index], bookImages: books[index]['bookImages'])));
                        }, child: Container(
                              margin: const EdgeInsets.only(left: 10,right: 10,top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:  Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                child: Image.network(books[index]['bookImages'][0],
                                  height: 90,width: 90,fit: BoxFit.fill,),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20,top: 10,left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(books[index]['name'],
                                                style: Theme.of(context).textTheme.headline4,maxLines: 1,overflow: TextOverflow.ellipsis),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                            decoration: BoxDecoration(
                                              //color: AppColor.darkGreen,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Text('₹ ${books[index]['price']}',
                                                style: Theme.of(context).textTheme.headline5,maxLines: 1,overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),

                                      Text('${books[index]['selectedCourse']} | ${books[index]['selectedClass']}',
                                        style: Theme.of(context).textTheme.headline6,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                      // const SizedBox(height: 5),
                                      // const Text('books[index]bookDescription',
                                      //   style: TextStyle(fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                      //const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: double.parse('${books[index]['bookRating']}'),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            ignoreGestures : true,
                                            itemSize: 10,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              debugPrint('$rating');
                                            },
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                              onTap: (){
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context)=>VideoPlayerScreen(imageUrl: books[index]['bookVideo'])));
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(10.0,5,10,5),
                                                child: Icon(Icons.play_arrow,color: AppColor.whiteColor,size: 22,),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                )
              ),
              isLoading ? const CircularProgressIndicator() : const SizedBox()
            ],
          ) : noInternetDialog();
        }
      ),
    );
  }
}
