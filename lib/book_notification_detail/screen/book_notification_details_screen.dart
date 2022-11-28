import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Firebase/firebase_collection.dart';
import '../../utils/app_color.dart';
class BookNotificationDetailScreen extends StatefulWidget {
  const BookNotificationDetailScreen({Key? key}) : super(key: key);

  @override
  State<BookNotificationDetailScreen> createState() => _BookNotificationDetailScreenState();
}

class _BookNotificationDetailScreenState extends State<BookNotificationDetailScreen> {

  String className = '';

  Future userClassName() async{
    var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
        isEqualTo: FirebaseAuth.instance.currentUser?.email).get();
    for(var snapShot in shopQuerySnapshot.docChanges){
      if(mounted){
        setState(() {
          className = snapShot.doc.get('chooseClass');
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userClassName();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseCollection().addBookCollection.where('selectedClass',isEqualTo: className)
        //.where('currentUser',isNotEqualTo: FirebaseAuth.instance.currentUser?.email)
        //.orderBy("timeStamp", descending: false)
            .snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError) {
            return const SizedBox();
          } else if (!snapshot.hasData) {
            return  const Center(child: Text('No Notification Available'),);
          } else if (snapshot.requireData.docChanges.isEmpty){
            return const Center(child: Text('No Notification Available'),);
          } else if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10,20,10,10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: AppColor.greyColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: const Icon(Icons.notification_important,color: AppColor.whiteColor,),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    const TextSpan(text: "Notification for ",
                                        style: TextStyle(fontWeight: FontWeight.bold)
                                    ),
                                    TextSpan(
                                      text: "${snapshot.data?.docs[index]['bookName']}",
                                      style: Theme.of(context).textTheme.headline5,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Text(DateFormat('dd/MMMM/yyyy').format(DateTime.parse(snapshot.data?.docs[index]['timeStamp'])),
                                  style: Theme.of(context).textTheme.headline6)
                            ],
                          ),
                        ),
                        //const Spacer(),
                        Text(DateFormat.jm().format(DateTime.parse(snapshot.data?.docs[index]['timeStamp'])),
                          style: Theme.of(context).textTheme.subtitle2,)
                      ],
                    ),
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
      }
    );
  }
}
