import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_supplies_hub/firebase/firebase_collection.dart';
import 'package:shimmer/shimmer.dart';

import '../../book_details/screen/geometry_box_details_screen.dart';
import '../../shimmers/gridview_shimmers.dart';
import '../../utils/app_color.dart';
import '../../widgets/responsive_widget.dart';

class GeometryListModel{
  String toolName,toolImage;

  GeometryListModel({
    required this.toolImage,required this.toolName,
  });
}

List<GeometryListModel> toolDetails = <GeometryListModel> [
  GeometryListModel(toolName: 'Compass', toolImage: 'https://5.imimg.com/data5/BH/RS/MY-44697526/exam-plastic-geometric-parts-500x500.jpg'),
  GeometryListModel(toolName: 'Compass', toolImage: 'https://i0.wp.com/onlymyenglish.com/wp-content/uploads/geometric-box-tools-with-name.png?resize=840%2C963&ssl=1'),
  GeometryListModel(toolName: 'Ruler', toolImage: 'https://www.schooltech.in/image/cache/products/dec20/8901180673133_2-1400x1400.jpg'),
  GeometryListModel(toolName: 'Compass', toolImage: 'https://m.media-amazon.com/images/I/61RGJOTrllL._SX569_.jpg'),
  GeometryListModel(toolName: 'Protector', toolImage: 'https://www.jiomart.com/images/product/600x600/490094816/camlin-scholar-mathematical-geometry-box-product-images-o490094816-p490094816-7-202206061841.jpg'),
  GeometryListModel(toolName: 'Compass',toolImage: 'https://saraswatibook.in/wp-content/uploads/2022/02/490.jpg'),
  GeometryListModel(toolName: 'Divider',toolImage: 'https://rukminim1.flixcart.com/image/416/416/ki7qw7k0-0/geometry-box/d/f/r/teachers-geometry-box-plastic-big-size-with-case-for-teaching-original-imafy2dyyghxfg6w.jpeg?q=70'),
  GeometryListModel(toolName: 'Drafter',toolImage: 'http://www.hspmart.in/wp-content/uploads/2017/04/STAR-GEOMETRY-BOX.jpg'),
];

class GeometryBoxDetailWidget extends StatelessWidget {
  const GeometryBoxDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseCollection().addGeometryCollection.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.hasError || snapshot.connectionState == ConnectionState.waiting){
            return const GridViewShimmers();
          } else if(snapshot.requireData.docChanges.isNotEmpty){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 10,right: 20,top: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Geometry ",
                            style: Theme.of(context).textTheme.headline2
                        ),
                        TextSpan(
                            text: "Tools",
                            style: Theme.of(context).textTheme.headline4
                        )
                      ],
                    ),
                  ),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 2 : 4,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                      mainAxisExtent: 200
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data?.docs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>GeometryBoxDetailScreen(snapshotData: snapshot.data?.docs[index],)));
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
                                  imageUrl: snapshot.data?.docs[index]['toolImages'],
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
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error,color: AppColor.whiteColor,size: 30,),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                child: Text(snapshot.data?.docs[index]['toolName'],
                                  textAlign:TextAlign.start,maxLines: 2,
                                  style: Theme.of(context).textTheme.headline4,
                                  overflow: TextOverflow.ellipsis,),
                              ),
                               Padding(
                                 padding: const EdgeInsets.only(left: 5,right: 5,top: 3),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text('₹${snapshot.data?.docs[index]['price']}',
                                         maxLines: 2,overflow: TextOverflow.ellipsis,textAlign:TextAlign.start,
                                       style: const TextStyle(color: AppColor.greenColor,fontSize: 18),
                                     ),

                                     Container(
                                       padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                       decoration: BoxDecoration(
                                         color: AppColor.greenColor,
                                         borderRadius: BorderRadius.circular(2)
                                       ),
                                       child: const Icon(Icons.arrow_forward_outlined,size:18,color: AppColor.whiteColor,),
                                     )

                                   ],
                                 ),
                               ),
                              const SizedBox(height: 5)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        }
    );
  }
}
