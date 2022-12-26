import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/Firebase/firebase_collection.dart';
import 'package:school_supplies_hub/book_details/screen/book_details_screen.dart';
import 'package:school_supplies_hub/utils/app_color.dart';

import '../../book_details/screen/geometry_box_details_screen.dart';
import '../../home/provider/internet_provider.dart';
import '../../widgets/internet_screen.dart';

class CategoryToolScreen extends StatefulWidget {
  String getToolName;
  CategoryToolScreen({Key? key,required this.getToolName}) : super(key: key);

  @override
  State<CategoryToolScreen> createState() => _CategoryToolScreenState();
}

class _CategoryToolScreenState extends State<CategoryToolScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.appColor,
        appBar: AppBar(
          title: Text(widget.getToolName),
        ),
        body: Consumer<InternetProvider>(
            builder: (context, internetSnapshot, _) {
              internetSnapshot.checkInternet().then((value) {});
              return internetSnapshot.isInternet ? StreamBuilder(
                  stream: FirebaseCollection().addGeometryCollection.where('name',isEqualTo: widget.getToolName).snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    } else if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.requireData.docChanges.isEmpty){
                      return const Center(child: Text("No Tools Available"));
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>GeometryBoxDetailScreen(snapshotData: snapshot.data?.docs[index])));
                              },
                              child: Card(
                                color: AppColor.appColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network('${snapshot.data?.docs[index]['toolImages']}',
                                      color: const Color.fromRGBO(255, 255, 255, 0.6),
                                      colorBlendMode: BlendMode.modulate,
                                      height: 200,width: double.infinity,fit: BoxFit.fill,),
                                    const SizedBox(height: 5,),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5.0,0,10,10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${snapshot.data?.docs[index]['name']}',
                                            style: Theme.of(context).textTheme.headline3,maxLines: 2,overflow: TextOverflow.ellipsis,),
                                          const SizedBox(height: 5,),
                                          Text('${snapshot.data?.docs[index]['description']}',
                                            style: Theme.of(context).textTheme.headline6,maxLines: 3,overflow: TextOverflow.ellipsis,),
                                          const SizedBox(height: 5,),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }
                  }
              ) : noInternetDialog();
            }
        )
    );
  }
}
