import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_supplies_hub/Firebase/firebase_collection.dart';
import '../utils/app_color.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseCollection().buyBookCollection.where('userEmail',isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (!snapshot.hasData) {
            return  const Center(child: Text("No Orders"));
          } else if (snapshot.requireData.docChanges.isEmpty){
            return  const Center(child: Text("No Orders"));
          } else if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data?.docChanges.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10.0,10,10,10),
                    child: Card(
                      color: AppColor.greyColor.withOpacity(0.2),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10,top: 10,right: 10,left: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child:  Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  child: Image.network(snapshot.data?.docs[index]['bookImages'][0],
                                      height: 70,width: 90,fit: BoxFit.fill),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        Text('Buy on  ${DateFormat('MMM dd').format(DateTime.parse(snapshot.data?.docs[index]['timeStamp']))}',
                                            maxLines: 2,overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 2),
                                        Text(snapshot.data?.docs[index]['bookName'],
                                            style: Theme.of(context).textTheme.headline4,
                                            maxLines: 1,overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 2),
                                        const Text("IIFCO Office, Shivranjani Ahmedabad (300024)",
                                            style : TextStyle(color: AppColor.greyColor,fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(height: 10,color: AppColor.greyColor,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Book Details : ',style: Theme.of(context).textTheme.headline4,),
                                    const SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text('Course Name',style: Theme.of(context).textTheme.subtitle1,),
                                        const SizedBox(height: 5),
                                        Text('Class Name',style:Theme.of(context).textTheme.subtitle1,),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(snapshot.data?.docs[index]['selectedCourse'],style: const TextStyle(fontSize: 12)),
                                    const SizedBox(height: 5),
                                    Text(snapshot.data?.docs[index]['selectedClass'],style: const TextStyle(fontSize: 12)),
                                    const SizedBox(height: 5),
                                  ],
                                )
                              ],
                            ),
                            const Divider(height: 10,color: AppColor.whiteColor,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Text('Price',style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 5,),
                                    Text('Discount',style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('₹ ${snapshot.data?.docs[index]['bookPrice']}',style: const TextStyle(fontSize: 12)),
                                    const SizedBox(height: 5),
                                    const Text('10.0%',style: TextStyle(fontSize: 12)),
                                    const SizedBox(height: 3),
                                    Container(width: 50,height: 1,color: AppColor.whiteColor,),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total',
                                  style: TextStyle(color: AppColor.redColor,fontWeight: FontWeight.w500)),
                                Text('₹ ${double.parse(snapshot.data?.docs[index]['bookPrice']) -
                                    double.parse(snapshot.data?.docs[index]['bookPrice'])*10/100}',
                                  style: Theme.of(context).textTheme.headline3),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('You Save :',
                                  style: Theme.of(context).textTheme.subtitle1),
                                SizedBox(width: 10,),
                                Text('₹ ${double.parse(snapshot.data?.docs[index]['bookPrice'])*10/100}',
                                  style: Theme.of(context).textTheme.subtitle2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }

        }
      )

    );
  }
}
