import 'package:firebase_messaging/firebase_messaging.dart';

import '../Firebase/firebase_collection.dart';
import '../book_category/screen/book_category_class_screen.dart';
import '../book_details/screen/book_details_screen.dart';
import '../book_notification_detail/screen/book_notification_details_screen.dart';
import '../home/screen/home_screen.dart';
import '../my_library/screen/my_library_screen.dart';
import '../notification/push_notification.dart';
import '../profile/profile_screen.dart';
import '../utils/app_color.dart';
import 'package:flutter/material.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {

  int _selectedIndex=0;
  List<Widget> buildScreen(){
    return [
      const HomeScreen(),
      const BookCategoryScreen(),
      const MyLibraryScreen(),
      const BookNotificationDetailScreen(),
      const ProfileScreen()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotification().getNotification(context);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        var notificationData = await FirebaseCollection().addBookCollection.get();

        for(var data in notificationData.docChanges){
          if(data.doc.get('bookName') == message.data.values.last
              && data.doc.get('currentUser') == message.data.values.first){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                BookDetailScreen(snapshotData: data.doc, bookImages: data.doc.get('bookImages'))));
          }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appColor,
      // floatingActionButton:FloatingActionButton(
      //   splashColor: AppColor.appColor,
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddBookDetail()));
      //   },
      //   child: const Icon(Icons.add,color: AppColor.appColor), //icon inside button
      // ),

      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: WillPopScope(
          onWillPop: () async{
            if(_selectedIndex != 0) {
              setState(() {
                _selectedIndex = 0;
              });
              return false;
            } else {
              return true;
            }
          },
          child: buildScreen().elementAt(_selectedIndex)),

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: AppColor.appColor,
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(), //shape of notch
          notchMargin: 3,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: AppColor.darkWhiteColor,
            unselectedItemColor: AppColor.whiteColor,
            onTap: _onItemTapped,
            items:  const [
              BottomNavigationBarItem(
                  label: "Home",
                  icon:  Icon(Icons.home)
              ),
              BottomNavigationBarItem(
                  label: "Class",
                  icon: Icon(Icons.class_)
              ),
              BottomNavigationBarItem(
                  label: "Library",
                  icon: Icon(Icons.library_books)
              ),
              BottomNavigationBarItem(
                  label: "Notification",
                  icon: Icon(Icons.notification_add)
              ),
              BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(Icons.person)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

