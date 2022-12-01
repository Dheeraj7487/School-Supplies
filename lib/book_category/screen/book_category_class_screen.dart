import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/widgets/internet_screen.dart';
import 'package:school_supplies_hub/widgets/responsive_widget.dart';

import '../../home/provider/internet_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../model/book_category_class_model.dart';
import 'category_book_list_screen.dart';

class BookCategoryScreen extends StatelessWidget {
  const BookCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<CategoryListModel> className = <CategoryListModel> [
      CategoryListModel(gridColor: Colors.amberAccent, className: '5 Class', classImage: AppImage.fifthClass),
      CategoryListModel(gridColor: Colors.orange, className: '6 Class', classImage: AppImage.sixClass),
      CategoryListModel(gridColor: Colors.greenAccent, className: '7 Class', classImage: AppImage.sevenClass),
      CategoryListModel(gridColor: Colors.lightGreen, className: '8 Class', classImage: AppImage.eightClass),
      CategoryListModel(gridColor: Colors.lightBlue, className: '9 Class', classImage: AppImage.nineClass),
      CategoryListModel(gridColor: Colors.deepPurpleAccent, className: 'Secondary',classImage: AppImage.secondaryClass),
      CategoryListModel(gridColor: Colors.redAccent, className: '11 Class',classImage: AppImage.elevenClass),
      CategoryListModel(gridColor: Colors.amberAccent, className: 'Senior Secondary',classImage: AppImage.seniorSecClass),
      CategoryListModel(gridColor: Colors.purple, className: 'First year',classImage: AppImage.firstClass),
      CategoryListModel(gridColor: Colors.purpleAccent, className: 'Second Year',classImage: AppImage.secondClass),
      CategoryListModel(gridColor: Colors.cyanAccent, className: 'Third Year',classImage: AppImage.thirdClass),
    ];

    return Consumer<InternetProvider>(
        builder: (context, internetSnapshot, _) {
          internetSnapshot.checkInternet().then((value) {});
          return internetSnapshot.isInternet ?
          SafeArea(
          child: Scaffold(
            backgroundColor: AppColor.appColor,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                    child: Text('Choose Class',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                  ),
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 2 : 3,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                          mainAxisExtent: 160
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: className.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryBookListScreen(getClassName: className[index].className,)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0,right: 5),
                            child: Card(
                              elevation: 5,
                              color: AppColor.appColor,
                              shape:  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                    child: Image.asset(className[index].classImage,
                                        height: 120,width: double.infinity,fit: BoxFit.fill),
                                  ),
                                  const SizedBox(height: 5),
                                  Expanded(
                                    child: Center(
                                      child: Text(className[index].className,maxLines: 2,overflow: TextOverflow.ellipsis,textAlign:TextAlign.center),
                                    ),
                                  ),
                                  const SizedBox(height: 5)
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  )
                ],
              ),
            ),
          ),
        ) : noInternetDialog();
      }
    );
  }
}
