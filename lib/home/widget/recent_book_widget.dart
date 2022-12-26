import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:school_supplies_hub/Firebase/firebase_collection.dart';
import 'package:school_supplies_hub/home/screen/popular_books_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../book_details/screen/book_details_screen.dart';
import '../../shimmers/gridview_shimmers.dart';
import '../../utils/app_color.dart';
import '../../widgets/responsive_widget.dart';

class RecentBookWidget extends StatelessWidget {
  const RecentBookWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseCollection().addBookCollection.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.hasError){
            return const GridViewShimmers();
          } else if(snapshot.hasData){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Recent ",
                            style: Theme.of(context).textTheme.headline2
                        ),
                        TextSpan(
                            text: "Books",
                            style: Theme.of(context).textTheme.headline4
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 2 : 3,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                      mainAxisExtent: 215
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length <= 3 ? snapshot.data!.docs.length : 4,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                            BookDetailScreen(snapshotData: snapshot.data?.docs[index],
                                bookImages: snapshot.data?.docs[index]['bookImages'])));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: Card(
                          elevation: 5,
                          color: AppColor.appColor,
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: "${snapshot.data?.docs[index]['bookImages'][1]}",
                                  height: 120,width: double.infinity,fit: BoxFit.fill,
                                  placeholder: (context, url) => Shimmer.fromColors(
                                    highlightColor: AppColor.appColor,
                                    baseColor: Colors.grey.shade100,
                                    period: const Duration(seconds: 2),
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.height/3,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Container(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                child: Text(snapshot.data?.docs[index]['name'],
                                  textAlign:TextAlign.start,maxLines: 2,
                                  style: Theme.of(context).textTheme.headline4,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                                child: RatingBar.builder(
                                  initialRating: double.parse('${snapshot.data?.docs[index]['bookRating']}'),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures : true,
                                  itemSize: 14,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    debugPrint('$rating');
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5,right: 5,top: 3),
                                child : Text('₹ ${snapshot.data?.docs[index]['price']}',
                                    maxLines: 2,overflow: TextOverflow.ellipsis,textAlign:TextAlign.start),
                              ),
                              const SizedBox(height: 5)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Visibility(
                  visible: snapshot.data!.docs.length >= 4,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const PopularBooksScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      child: Card(
                        color: AppColor.appColor.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(child: Text('View All')),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return const GridViewShimmers();
          }
        }
    );
  }
}
