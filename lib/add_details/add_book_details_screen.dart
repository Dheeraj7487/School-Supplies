import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_supplies_hub/add_details/provider/add_book_detail_provider.dart';
import 'package:school_supplies_hub/login/provider/loading_provider.dart';
import 'package:school_supplies_hub/utils/app_image.dart';
import 'package:school_supplies_hub/utils/app_utils.dart';
import 'package:school_supplies_hub/widgets/button_widget.dart';
import 'package:school_supplies_hub/widgets/dropdown_widget.dart';
import '../utils/app_color.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import '../widgets/textfield_widget.dart';
import 'auth/add_book_details_auth.dart';

class AddBookDetail extends StatefulWidget {
  const AddBookDetail({Key? key}) : super(key: key);
  @override
  State<AddBookDetail> createState() => _AddBookDetailState();
}

class _AddBookDetailState extends State<AddBookDetail> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bookDescriptionController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  String? selectedCourses;
  String selectBookVideoName = '';
  File? file;
  String bookVideoName ='';
  String bookImageName ='';

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
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     allowMultiple: true,
    //     type: FileType.video
    // );
    final XFile? image = await imagePicker.pickVideo(source: ImageSource.gallery);
    if(image == null) return;
    final filePath = image.path;
    //File compressImage = await snapshot.imageSizeCompress(image: File(filePath!));
    setState(() {
      file = File(filePath);
      selectBookVideoName = image.name;
    });
  }

  Future<List> uploadFile(context) async {
    //Store Image in firebase database
    Provider.of<LoadingProvider>(context,listen: false).startLoading();
    List imagesUrls=[];

    //if (file == null) return;
    final bookVideoDestination = 'Book Video/$selectBookVideoName';

    try {
      final bookVideoRef = FirebaseStorage.instance.ref().child(bookVideoDestination);
      UploadTask bookVideoUploadTask =  bookVideoRef.putFile(file!);
      final snapshot2 = await bookVideoUploadTask.whenComplete(() {});

      imageFileList?.forEach((image) async{
       // File file1 = image as File;
        final bookImageDestination = 'Book Image/${image.name}';
        final bookImageRef = FirebaseStorage.instance.ref().child(bookImageDestination);
        UploadTask bookImageUploadTask =  bookImageRef.putFile(File(image.path));
        final snapshot1 = await bookImageUploadTask.whenComplete(() {});
        imagesUrls.add(await snapshot1.ref.getDownloadURL().whenComplete((){}));

        final bookVideoUrl = await snapshot2.ref.getDownloadURL().whenComplete(() {
          // Provider.of<LoadingProvider>(context,listen: false).startLoading();
        });
        setState(() {});
        debugPrint('Image Url => ${imagesUrls.length} || ${imageFileList!.length}');
        if(imagesUrls.length == imageFileList!.length){
          AddBookDetailsAuth().addBookDetails(
              uId: FirebaseAuth.instance.currentUser!.uid,
              publisherName: nameController.text,
              userEmail: emailController.text,
              userMobile: phoneController.text,
              bookName: bookNameController.text,
              authorName: authorController.text,
              bookDescription: bookDescriptionController.text,
              price: priceController.text,
              bookImages: imagesUrls,
              bookVideo: bookVideoUrl, selectedClass: Provider.of<AddBookDetailProvider>(context,listen:false).selectClass.toString(),
              selectedCourse: Provider.of<AddBookDetailProvider>(context,listen:false).selectCourse.toString(),
              selectedSemester: Provider.of<AddBookDetailProvider>(context,listen:false).selectSemester.toString(),
              bookRating: 0, currentUser: '${FirebaseAuth.instance.currentUser?.email}' ,
              timestamp: DateTime.now().toString()
          ).then((value) {
            debugPrint('Successfully Added');
            Provider.of<LoadingProvider>(context,listen: false).stopLoading();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBarScreen()), (Route<dynamic> route) => false);
          });
        }
      });


    } catch (e) {
      debugPrint('Failed to upload image');
      debugPrint('$e');
    }
    return imagesUrls;
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

                            const SizedBox(height: 20),
                            const Text('Publisher Name'),
                            const SizedBox(height: 5),
                            TextFieldWidget().textFieldWidget(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              hintText: "Enter Name",
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
                                r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)){
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
                            const Text('Description'),
                            const SizedBox(height: 5),
                            TextFieldWidget().textFieldWidget(
                              controller: bookDescriptionController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              hintText: "Enter Book Description",
                              maxLines: 4,
                              prefixIcon: const Icon(Icons.description_outlined,color: AppColor.whiteColor),
                              validator: (value) {
                                if (value == null || value.isEmpty || value.trim().isEmpty) {
                                  return 'Please enter book description';
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
                                  setState(() {
                                    selectedCourses = newValue;
                                  });
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
                                        color: Colors.black12.withOpacity(0.1),
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
                                      hint: const Text('Select Semester', style: TextStyle(fontSize: 13, color: AppColor.whiteColor)),
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
                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () {
                                selectImages();
                              },
                              child: Text('Select Book Images',style: Theme.of(context).textTheme.subtitle1,),
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
                                child: Text('Select Video Clip',style: Theme.of(context).textTheme.subtitle1,)),
                            const SizedBox(height: 3,),
                            Text(selectBookVideoName.replaceAll('image_picker', ''),style: const TextStyle(color: AppColor.whiteColor),),

                            const SizedBox(height: 40),
                            ButtonWidget().appButton(
                              text: 'Add',
                              onTap: () async{
                                if(_formKey.currentState!.validate()){
                                  if(imageFileList!.isNotEmpty && file !=null){
                                    uploadFile(context);
                                  } else {
                                    AppUtils.instance.showSnackBar(context, 'All field is required');
                                  }
                                  // ref.watch(addBookDetailsAuthProvider).addBookDetails(
                                  //     uId: FirebaseAuth.instance.currentUser!.uid,
                                  //     userName: nameController.text,
                                  //     userEmail: '${FirebaseAuth.instance.currentUser?.email}',
                                  //     userMobile: phoneController.text,
                                  //     bookName: bookNameController.text, bookImages: imageFileList,
                                  //     bookVideo: file.toString(), selectedClass: snapshot.selectClass.toString(),
                                  //     selectedCourse: snapshot.selectCourse.toString(),
                                  //     selectedSemester: snapshot.selectSemester.toString(),
                                  //     bookRating: 0, currentUser: '${FirebaseAuth.instance.currentUser?.email}' ,
                                  //     timestamp: DateTime.now().toString()
                                  // );
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    }
                )


              ],
            ),
          ),
        )
    );
  }
}


