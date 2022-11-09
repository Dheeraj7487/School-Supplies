import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
class BookNotificationDetailScreen extends StatelessWidget {
  const BookNotificationDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.fromLTRB(20,10,10,20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.greyColor
                ),
                  child: const Icon(Icons.notification_add_outlined)
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Book Name',style: Theme.of(context).textTheme.headline4,),
                  const SizedBox(height: 5,),
                  Text('Book Description',style: Theme.of(context).textTheme.headline6)
                ],
              ),
              const Spacer(),
              Text('20/04/2022',style: Theme.of(context).textTheme.subtitle2,)
            ],
          ),
        );
      });
  }
}
