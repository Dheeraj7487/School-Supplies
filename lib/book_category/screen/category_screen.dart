import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/book_category/screen/tool_category_screen.dart';
import 'package:school_supplies_hub/widgets/internet_screen.dart';
import 'package:school_supplies_hub/widgets/responsive_widget.dart';

import '../../home/provider/internet_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../model/class_category_model.dart';
import '../model/tool_category_model.dart';
import 'class_category_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<ClassCategoryModel> className = <ClassCategoryModel> [
      ClassCategoryModel(gridColor: Colors.amberAccent, className: '5 Class', classImage: AppImage.fifthClass),
      ClassCategoryModel(gridColor: Colors.orange, className: '6 Class', classImage: AppImage.sixClass),
      ClassCategoryModel(gridColor: Colors.greenAccent, className: '7 Class', classImage: AppImage.sevenClass),
      ClassCategoryModel(gridColor: Colors.lightGreen, className: '8 Class', classImage: AppImage.eightClass),
      ClassCategoryModel(gridColor: Colors.lightBlue, className: '9 Class', classImage: AppImage.nineClass),
      ClassCategoryModel(gridColor: Colors.deepPurpleAccent, className: 'Secondary',classImage: AppImage.secondaryClass),
      ClassCategoryModel(gridColor: Colors.redAccent, className: '11 Class',classImage: AppImage.elevenClass),
      ClassCategoryModel(gridColor: Colors.amberAccent, className: 'Senior Secondary',classImage: AppImage.seniorSecClass),
      ClassCategoryModel(gridColor: Colors.purple, className: 'First year',classImage: AppImage.firstClass),
      ClassCategoryModel(gridColor: Colors.purpleAccent, className: 'Second Year',classImage: AppImage.secondClass),
      ClassCategoryModel(gridColor: Colors.cyanAccent, className: 'Third Year',classImage: AppImage.thirdClass),
      ClassCategoryModel(gridColor: Colors.cyanAccent, className: 'Others',classImage: AppImage.otherBook),
    ];

    List<ToolCategoryModel> toolDetails = <ToolCategoryModel> [
      ToolCategoryModel(toolName: 'Protector', toolImage: AppImage.protector),
      ToolCategoryModel(toolName: 'Divider', toolImage: AppImage.divider),
      ToolCategoryModel(toolName: 'Eraser', toolImage: AppImage.eraser),
      ToolCategoryModel(toolName: 'Sharpener', toolImage: AppImage.sharpner),
      ToolCategoryModel(toolName: 'Ruler', toolImage: AppImage.ruler),
      ToolCategoryModel(toolName: 'Compass', toolImage: AppImage.compass),
      ToolCategoryModel(toolName: 'Set-Square', toolImage: AppImage.setSquare),
      ToolCategoryModel(toolName: 'Drafter', toolImage: AppImage.drafter),
      ToolCategoryModel(toolName: 'Others', toolImage: AppImage.other),
    ];

    return Consumer<InternetProvider>(
        builder: (context, internetSnapshot, _) {
          internetSnapshot.checkInternet().then((value) {});
          return internetSnapshot.isInternet ?
          DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: AppColor.appColor,
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: const TabBar(
                  indicatorColor: AppColor.redColor,
                  labelColor: AppColor.darkWhiteColor,
                  unselectedLabelColor: AppColor.whiteColor,
                  unselectedLabelStyle: TextStyle(fontSize: 10),
                  tabs: [
                    Tab(text: "Class"),
                    Tab(text: "Tools")
                  ],
                ),
              ),

              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 2 : 3,
                            mainAxisSpacing: 5,
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryClassScreen(getClassName: className[index].className,)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0,right: 5.0,top: 5),
                              child: GridTile(
                                footer: GridTileBar(
                                  backgroundColor: Colors.black38,
                                  title: Center(
                                    child: Text(className[index].className,maxLines: 2,overflow: TextOverflow.ellipsis,textAlign:TextAlign.center),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                  child: Image.asset(className[index].classImage,
                                      height: 120,width: double.infinity,fit: BoxFit.fill),
                                ),
                              ),
                            ),
                          );
                        }
                    )
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 2 : 3,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1.1,
                            mainAxisExtent: 160
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: toolDetails.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryToolScreen(getToolName: toolDetails[index].toolName,)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0,right: 5.0,top: 5),
                              child: GridTile(
                                footer: GridTileBar(
                                  backgroundColor: Colors.black38,
                                  title: Center(
                                    child: Text(toolDetails[index].toolName,maxLines: 2,overflow: TextOverflow.ellipsis,textAlign:TextAlign.center),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                  child: Image.asset(toolDetails[index].toolImage,
                                      height: 120,width: double.infinity,fit: BoxFit.fill),
                                ),
                              ),
                            ),
                          );
                        }
                    )
                  ),
                ],
              ),
            ),
          ) : noInternetDialog();
      }
    );
  }
}
