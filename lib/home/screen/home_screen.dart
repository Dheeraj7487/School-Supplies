import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_supplies_hub/utils/app_color.dart';
import '../../Firebase/firebase_collection.dart';
import '../../add_details/add_book_details_screen.dart';
import '../../profile/edit_profile_screen.dart';
import '../widget/recent_book_widget.dart';
import '../widget/latest_book_widget.dart';
import '../widget/popular_books_widget.dart';
import '../widget/recently_added_book_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  String? userName = ' ';

  Future shopDetailsCheck() async{
    var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
        isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
    for(var snapShot in shopQuerySnapshot.docChanges){
      if(mounted){
        setState(() {
          userName = snapShot.doc.get('userName');
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    shopDetailsCheck();
  }

  @override
  Widget build(BuildContext context) {
    var hour = DateTime.now().hour;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appColor,
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          backgroundColor: AppColor.whiteColor.withOpacity(0.1),
          toolbarHeight: 80,
          title: Stack(
            children: [
              Container(
                height: 80,
                decoration: const BoxDecoration(
                   // color: AppColor.whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50))
                ),
              ),
              Positioned(
                top: 15,left: 20,right: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName == null ? '' : 'Hi, $userName'
                                  ,style: Theme.of(context).textTheme.headline6),
                                const SizedBox(height: 3),
                                Text(hour < 12 ? 'Good Morning' :
                                hour < 17 ? 'Good Afternoon' : 'Good Evening',
                                    style : Theme.of(context).textTheme.headline3),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  backgroundColor: AppColor.appColor,
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            ClipOval(
                                                child: Container(
                                                    color: AppColor.whiteColor,
                                                    height: 40,width: 40,child: Center(
                                                  child: Text('${userName?.substring(0,1).toUpperCase()}',
                                                    style: const TextStyle(color: AppColor.appColor),
                                                  ),) )
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(20.0,0,10,0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('$userName'),
                                                    const SizedBox(height: 3,),
                                                    Text('${FirebaseAuth.instance.currentUser?.email}'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                            onTap: (){
                                              Navigator.pop(context);
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfileScreen()));
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                              decoration: BoxDecoration(
                                                  color: AppColor.whiteColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: const Text('Edit Your Profile',
                                                  style: TextStyle(fontSize: 12,color: AppColor.appColor),textAlign: TextAlign.center),
                                            )),
                                        const SizedBox(height: 10),
                                      ],
                                    )
                                  ],
                                );
                              });
                            },
                            child: ClipOval(
                                child: Container(
                                    color: AppColor.whiteColor,
                                    height: 40,width: 40,child: Center(
                                  child: Text('${userName?.substring(0,1).toUpperCase()}',
                                    style: const TextStyle(color: AppColor.appColor),
                                  ),) )
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15,),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              children:  const [
                RecentlyAddedBookSliderWidget(),
                SizedBox(height: 10),
                LatestBookWidget(),
                SizedBox(height: 10),
                PopularBookWidget(),
                SizedBox(height: 10),
                RecentBookWidget(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        floatingActionButton:FloatingActionButton(
          splashColor: AppColor.appColor,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddBookDetail()));
          },
          child: const Icon(Icons.add,color: AppColor.appColor), //icon inside button
        ),
      ),
    );
  }
}
