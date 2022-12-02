import 'dart:io';
import 'dart:typed_data';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/add_details/provider/add_book_detail_provider.dart';
import 'package:school_supplies_hub/add_details/remove_bg.dart';
import 'package:school_supplies_hub/login/provider/loading_provider.dart';
import 'package:school_supplies_hub/notification/push_notification.dart';
import 'package:school_supplies_hub/utils/app_image.dart';
import 'package:school_supplies_hub/utils/app_utils.dart';
import 'package:school_supplies_hub/widgets/button_widget.dart';
import 'package:school_supplies_hub/widgets/dropdown_widget.dart';
import '../Firebase/firebase_collection.dart';
import '../home/provider/internet_provider.dart';
import '../utils/app_color.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import '../widgets/textfield_widget.dart';
import 'auth/add_book_details_auth.dart';
import 'auth/add_geometry_details_auth.dart';

class AddBookDetail extends StatefulWidget {
  const AddBookDetail({Key? key}) : super(key: key);
  @override
  State<AddBookDetail> createState() => _AddBookDetailState();
}

class _AddBookDetailState extends State<AddBookDetail> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController publisherNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController toolNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  String selectBookVideoName = '';
  File? videoFile;
  String geometryImageName ='';
  bool checkBoxValue = false;
  bool geometryBoxValue = false;
  int counterValue = 0,bookAdded = 1;

  Uint8List? geometryFile;
  String? imagePath;
  //ScreenshotController controller = ScreenshotController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage(imageQuality: 40);
    if (selectedImages.isNotEmpty && selectedImages.length > 2) {
      imageFileList!.addAll(selectedImages);
    } else if(imageFileList!.length > 2){
      imageFileList!.addAll(selectedImages);
    } else {
      AppUtils.instance.showSnackBar(context, 'Minimum 3 file select');
    }
    debugPrint("Image List Length:${imageFileList!.length}");
    setState((){});
  }

  void selectBookVideo() async{
    final XFile? image = await imagePicker.pickVideo(source: ImageSource.gallery);
    if(image == null) return;
    final filePath = image.path;
    setState(() {
      videoFile = File(filePath);
      selectBookVideoName = image.name;
    });
  }

  Future<List> uploadBookDetail(context) async {
    //Store Image in firebase database
    Provider.of<LoadingProvider>(context,listen: false).startLoading();
    List imagesUrls=[];

    var snapshotData = await FirebaseCollection().userCollection.
    //where('userEmail',isNotEqualTo: FirebaseAuth.instance.currentUser?.email).
    where('chooseClass',isEqualTo: Provider.of<AddBookDetailProvider>(context,listen:false).selectClass.toString()).get();

    final bookVideoDestination = 'Book Video/$selectBookVideoName';

    try {
      final bookVideoRef = FirebaseStorage.instance.ref().child(bookVideoDestination);
      UploadTask bookVideoUploadTask =  bookVideoRef.putFile(videoFile!);
      final snapshot2 = await bookVideoUploadTask.whenComplete(() {});

      imageFileList?.forEach((image) async{
        final bookImageDestination = 'Book Image/${image.name}';
        final bookImageRef = FirebaseStorage.instance.ref().child(bookImageDestination);
        UploadTask bookImageUploadTask =  bookImageRef.putFile(File(image.path));
        final snapshot1 = await bookImageUploadTask.whenComplete(() {});
        imagesUrls.add(await snapshot1.ref.getDownloadURL().whenComplete((){}));

        final bookVideoUrl = await snapshot2.ref.getDownloadURL().whenComplete(() {});
        setState(() {});
        debugPrint('Image Url => ${imagesUrls.length} || ${imageFileList!.length}');
        if(imagesUrls.length == imageFileList!.length){
          AddBookDetailsAuth().addBookDetails(
              uId: FirebaseAuth.instance.currentUser!.uid,
              publisherName: publisherNameController.text,
              userEmail: emailController.text,
              userMobile: phoneController.text,
              bookName: bookNameController.text,
              authorName: authorController.text,
              bookDescription: descriptionController.text,
              price: priceController.text,
              discountPercentage : counterValue,
              bookAvailable: bookAdded,
              bookImages: imagesUrls,
              bookVideo: bookVideoUrl, selectedClass: Provider.of<AddBookDetailProvider>(context,listen:false).selectClass.toString(),
              selectedCourse: Provider.of<AddBookDetailProvider>(context,listen:false).selectCourse.toString(),
              selectedSemester: Provider.of<AddBookDetailProvider>(context,listen:false).selectSemester.toString(),
              bookRating: 0, currentUser: '${FirebaseAuth.instance.currentUser?.email}' ,
              timestamp: DateTime.now().toString()
          ).then((value) {
            debugPrint('Successfully Added');
            Provider.of<LoadingProvider>(context,listen: false).stopLoading();

            for(var data in snapshotData.docChanges){
              if(data.doc.get('userEmail') != FirebaseAuth.instance.currentUser?.email){
                PushNotification().sendPushNotification(data.doc.get('fcmToken'),
                    bookNameController.text,descriptionController.text);
              }
            }
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => const BottomNavBarScreen()), (Route<dynamic> route) => false);
          });
        }
      });
    } catch (e) {
      debugPrint('Failed to upload image');
      debugPrint('$e');
    }
    return imagesUrls;
  }

  uploadGeometryBoxDetail(context) async {
    Provider.of<LoadingProvider>(context,listen: false).startLoading();

    try {
      final bookImageDestination = 'Geometry Image/$geometryImageName';
      final bookImageRef = FirebaseStorage.instance.ref().child(bookImageDestination);
      UploadTask bookImageUploadTask =  bookImageRef.putFile(File(imagePath!));
      final snapshot = await bookImageUploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL().whenComplete((){});

      setState(() {});
      AddGeometryBoxDetailsAuth().addGeometryBoxDetails(
          uId: FirebaseAuth.instance.currentUser!.uid,
          publisherName: publisherNameController.text,
          userEmail: emailController.text,
          userMobile: phoneController.text,
          price: priceController.text,
          toolDescription: descriptionController.text,
          discountPercentage: counterValue,
          toolAvailable: bookAdded,
          toolName: toolNameController.text,
          toolImages: imageUrl.toString(),
          toolRating: 0,
          currentUser: '${FirebaseAuth.instance.currentUser?.email}',
          timestamp: DateTime.now().toString()
      ).then((value) {
        debugPrint('Successfully Added');
        Provider.of<LoadingProvider>(context, listen: false).stopLoading();
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(
            builder: (context) => const BottomNavBarScreen()), (
            Route<dynamic> route) => false);
      });

    } catch (e) {
      debugPrint('Failed to upload image');
      debugPrint('$e');
    }
  }

  /*String className = '';

  Future userClassName() async{
    var shopQuerySnapshot = await FirebaseCollection().userCollection.where('userEmail',
        isEqualTo: FirebaseAuth.instance.currentUser?.email).get();

    var snapshotData = await FirebaseCollection().userCollection.
    where('userEmail',isNotEqualTo: FirebaseAuth.instance.currentUser?.email).
    where('chooseClass',isEqualTo: Provider.of<AddBookDetailProvider>(context,listen:false).selectClass.toString())
        .get();


    for(var snapShot in snapshotData.docChanges){
      if(mounted){
        setState(() {
          //className = snapShot.doc.get('chooseClass');
          print('Print Data => ${snapShot.doc.get('chooseClass')} ');
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userClassName();
  }*/

  getGeometryImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        geometryImageName = pickedImage.name;
        geometryFile = await pickedImage.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      geometryFile = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.appColor,
        appBar: AppBar(
          title: const Text('Add Detail'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(AppImage.oldBook,height: 170,width: double.infinity,fit: BoxFit.fill,),
                  Consumer<AddBookDetailProvider>(
                      builder: (BuildContext context, snapshot, Widget? child) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Expanded(
                                      child: Text('If you add geometry box details please click the checkbox')),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: AppColor.greyColor,),
                                    child: Checkbox(
                                      checkColor: AppColor.whiteColor,
                                      activeColor: AppColor.greyColor,
                                      value: geometryBoxValue,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          geometryBoxValue = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              Visibility(
                                visible: geometryBoxValue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Tool Name'),
                                    const SizedBox(height: 5),
                                    TextFieldWidget().textFieldWidget(
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      hintText: "Enter Tool Name",
                                      controller: toolNameController,
                                      prefixIcon: const Icon(Icons.view_compact_sharp,color: AppColor.whiteColor),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value.trim().isEmpty) {
                                          return 'Please enter tool name';
                                        }
                                        return null;
                                      },
                                    ),

                                    const SizedBox(height: 20),
                                    const Text('Tool Price'),
                                    const SizedBox(height: 5),
                                    TextFieldWidget().textFieldWidget(
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      hintText: "Enter Tool Price",
                                      controller: priceController,
                                      prefixIcon: const Icon(Icons.attach_money,color: AppColor.whiteColor),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value.trim().isEmpty) {
                                          return 'Please enter tool price';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: !geometryBoxValue,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Book Name'),
                                      const SizedBox(height: 5),
                                      TextFieldWidget().textFieldWidget(
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.text,
                                        controller: bookNameController,
                                        hintText: "Enter Book Name",
                                        prefixIcon: const Icon(Icons.library_books,color: AppColor.whiteColor),
                                        validator: (value) {
                                          if (value == null || value.isEmpty || value.trim().isEmpty) {
                                            return 'Please enter book name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                              ),

                              const SizedBox(height: 20),
                              const Text('Publisher Name'),
                              const SizedBox(height: 5),
                              TextFieldWidget().textFieldWidget(
                                controller: publisherNameController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                hintText: "Enter Publisher Name",
                                prefixIcon: const Icon(Icons.person,color: AppColor.whiteColor),
                                validator: (value) {
                                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text('Email'),
                              const SizedBox(height: 5),
                              TextFieldWidget().textFieldWidget(
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                hintText: "Enter email",
                                prefixIcon: const Icon(Icons.email,color: AppColor.whiteColor),
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.trim().isEmpty) {
                                    return 'Please enter an email';
                                  } else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                                  r"[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                    return 'Please enter valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text('Mobile Number'),
                              const SizedBox(height: 5),
                              TextFieldWidget().textFieldWidget(
                                controller: phoneController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                hintText: "Enter Phone Number",
                                maxLength: 10,
                                counterText: '',
                                prefixIcon: const Icon(Icons.phone_android_outlined,color: AppColor.whiteColor),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),
                              const Text('Description'),
                              const SizedBox(height: 5),
                              TextFieldWidget().textFieldWidget(
                                controller: descriptionController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                hintText: "Enter Description",
                                maxLines: 4,
                                prefixIcon: const Icon(Icons.description_outlined,color: AppColor.whiteColor),
                                validator: (value) {
                                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              ),

                              Visibility(
                                visible: !geometryBoxValue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    const Text('Author Name'),
                                    const SizedBox(height: 5),
                                    TextFieldWidget().textFieldWidget(
                                      controller: authorController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      hintText: "Enter Author Name",
                                      prefixIcon: const Icon(Icons.accessibility_sharp,color: AppColor.whiteColor),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value.trim().isEmpty) {
                                          return 'Please enter name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    const Text('Book Price'),
                                    const SizedBox(height: 5),
                                    TextFieldWidget().textFieldWidget(
                                      textInputAction: TextInputAction.next,
                                      controller: priceController,
                                      keyboardType: TextInputType.number,
                                      hintText: "Enter Book Price",
                                      prefixIcon: const Icon(Icons.attach_money,color: AppColor.whiteColor),
                                      validator: (value) {
                                        if (value == null || value.isEmpty || value.trim().isEmpty) {
                                          return 'Please enter book price';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    appDropDown(
                                        value: snapshot.selectCourse,
                                        hint: 'Select Course',
                                        onChanged: (String? newValue) {
                                          snapshot.selectCourse = newValue!;
                                          snapshot.getSelectedCourse;
                                        },
                                        items:  snapshot.selectCourses
                                    ),

                                    const SizedBox(height: 20),
                                    appDropDown(
                                        value: snapshot.selectClass,
                                        hint: 'Select Class',
                                        onChanged: (String? newValue) {
                                          snapshot.selectClass = newValue;
                                          snapshot.getSelectedClass;
                                        },
                                        items:  snapshot.selectClasses
                                    ),
                                    Visibility(
                                      visible: snapshot.selectClass == 'First Year'
                                          || snapshot.selectClass == 'Second Year'
                                          || snapshot.selectClass == 'Third Year',
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              iconDisabledColor: Colors.grey,
                                              buttonHeight: 55,
                                              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                                              buttonDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: const Color(0x0c030303),
                                              ),
                                              itemHeight: 40,
                                              dropdownMaxHeight: 200,
                                              itemPadding: null,
                                              dropdownDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14),
                                                color: AppColor.appColor,
                                              ),
                                              scrollbarRadius: const Radius.circular(40),
                                              scrollbarAlwaysShow: true,
                                              value: snapshot.selectSemester,
                                              hint: const Text('Select Semester', style: TextStyle(fontSize: 12, color: AppColor.whiteColor)),
                                              isExpanded: true,
                                              isDense: true,
                                              iconOnClick: const Icon(Icons.arrow_drop_up,color: AppColor.whiteColor),
                                              icon: const Icon(Icons.arrow_drop_down, color: AppColor.whiteColor),
                                              onChanged: (String? newValue) {
                                                snapshot.selectSemester = newValue!;
                                                snapshot.getSemester;
                                              },
                                              items:  snapshot.selectSemesters.map<DropdownMenuItem<String>>((String className) {
                                                return DropdownMenuItem<String>(
                                                    value: className,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          className,
                                                          style: const TextStyle(color: AppColor.whiteColor),
                                                        )
                                                      ],
                                                    ));
                                              }).toList(),
                                            ),
                                          ),

                                          const SizedBox(height: 4),
                                          const Align(
                                              alignment: Alignment.topRight,
                                              child: Text('(Optional)',style: TextStyle(fontSize: 10),)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Expanded(
                                      child: Text('How many book are add')),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            bookAdded++;
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(15,10,15,10),
                                          child: Icon(Icons.add,color: AppColor.whiteColor,),
                                        ),
                                      ),
                                      Text("$bookAdded"),
                                      GestureDetector(
                                        onTap: (){
                                          if(bookAdded !=1){
                                            setState(() {
                                              bookAdded--;
                                            });
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.fromLTRB(15,10,15,10),
                                          child: Icon(Icons.remove,color: AppColor.whiteColor,),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Expanded(
                                      child: Text('If you provide the discount please click the checkbox')),
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: AppColor.greyColor,
                                    ),
                                    child: Checkbox(
                                      checkColor: AppColor.whiteColor,
                                      activeColor: AppColor.greyColor,
                                      value: checkBoxValue,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          checkBoxValue = value!;
                                          if(checkBoxValue == false){
                                            counterValue = 0;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Visibility(
                                visible: checkBoxValue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Expanded(child: Text('Discount Percentage')),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              counterValue++;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.fromLTRB(15,10,15,10),
                                            child: Icon(Icons.add,color: AppColor.whiteColor,),
                                          ),
                                        ),
                                        Text("$counterValue%"),
                                        GestureDetector(
                                          onTap: (){
                                            if(counterValue !=0){
                                              setState(() {
                                                counterValue--;
                                              });
                                            }
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.fromLTRB(15,10,15,10),
                                            child: Icon(Icons.remove,color: AppColor.whiteColor,),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              Visibility(
                                visible: geometryBoxValue,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () async{
                                          await getGeometryImage();
                                          geometryFile = await RemoveBgClient().removeBgApi(imagePath!);
                                          setState(() {});
                                        },
                                        child: Text('Select Tool Image',style: Theme.of(context).textTheme.subtitle1),
                                      ),
                                      Text(geometryImageName)
                                    ],
                                  )
                              ),

                              Visibility(
                                visible: !geometryBoxValue,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              selectImages();
                                            },
                                            child: Text('Select Book Images',style: Theme.of(context).textTheme.subtitle1),
                                          ),
                                          Visibility(
                                            visible: imageFileList!.isNotEmpty,
                                            child: IconButton(
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onPressed: (){
                                                  setState(() {
                                                    imageFileList?.clear();
                                                  });
                                                },
                                                icon: const Icon(Icons.clear,color: AppColor.whiteColor,)),
                                          )
                                        ],
                                      ),
                                      ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: imageFileList!.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Text('${File(imageFileList![index].name)}'.toString().replaceAll("File: 'image_picker", ''));
                                          }),

                                      ElevatedButton(
                                          onPressed: () {
                                            selectBookVideo();
                                          },
                                          child: Text('Select Video Clip',style: Theme.of(context).textTheme.subtitle1,)
                                      ),
                                      const SizedBox(height: 3,),
                                      Text(selectBookVideoName.replaceAll('image_picker', ''),style: const TextStyle(color: AppColor.whiteColor),),
                                    ],
                                  )
                              ),

                              const SizedBox(height: 40),
                              Consumer<InternetProvider>(
                                  builder: (context, internetSnapshot, _) {
                                    internetSnapshot.checkInternet().then((value) {});
                                    return ButtonWidget().appButton(
                                      text: 'Add',
                                      onTap: () async{
                                        FocusScope.of(context).unfocus();
                                        if(internetSnapshot.isInternet){
                                          if(_formKey.currentState!.validate()){
                                            if(imageFileList!.isNotEmpty && videoFile !=null){
                                             uploadBookDetail(context);
                                            }
                                            else if(geometryBoxValue == true && geometryFile!.isNotEmpty){
                                              uploadGeometryBoxDetail(context);
                                            }
                                            else {
                                              AppUtils.instance.showSnackBar(context, 'All field is required');
                                            }
                                          }
                                        } else {
                                          AppUtils.instance.showSnackBar(context, 'Please check your internet connection');
                                        }
                                      },
                                    );
                                  }
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      }
                  )
                ],
              )
            ),
          ),
        )
    );
  }
}


