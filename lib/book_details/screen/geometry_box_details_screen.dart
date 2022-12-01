import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/app_color.dart';

class GeometryBoxDetailScreen extends StatefulWidget {
  var snapshotData;
  GeometryBoxDetailScreen({Key? key,required this.snapshotData}) : super(key: key);

  @override
  State<GeometryBoxDetailScreen> createState() => _GeometryBoxDetailScreenState();
}

class _GeometryBoxDetailScreenState extends State<GeometryBoxDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.appColor,
        // appBar: AppBar(
        //   title: Text(widget.snapshotData['toolName']),
        // ),
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
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.arrow_back_outlined,color: AppColor.whiteColor,),
                        ),
                      )
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,10,10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.snapshotData['toolName'],
                            style: Theme.of(context).textTheme.headline2,maxLines: 2,overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(width: 10),
                        Text("₹${widget.snapshotData['price']}",style: const TextStyle(fontSize: 22),)
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
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Rarely Used\n Condition',
                                textAlign: TextAlign.center,
                              )
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
                              const Icon(Icons.date_range,
                                  color: AppColor.whiteColor),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Posted On\n ${DateFormat('dd MMM').format(DateTime.parse(widget.snapshotData['timeStamp']))}',
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

                    const SizedBox(height: 20),
                    Text('Description', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 5),
                    const Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged'),
                    const SizedBox(height: 20),

                    Card(
                      color: AppColor.appColor.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(child: Text('Buy Now')),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
