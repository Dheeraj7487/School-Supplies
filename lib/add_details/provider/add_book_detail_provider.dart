import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

// final addBookProvider = StateProvider<AddBookDetailProvider>((ref) {
//   return AddBookDetailProvider();
// });

class AddBookDetailProvider extends ChangeNotifier{
  String? selectClass,selectCourse,selectSemester,chooseClass;

  List<String> selectClasses = ['5 Class','6 Class','7 Class','8 Class',
      '9 Class','Secondary','11 Class','Senior Secondary','First Year','Second Year','Third Year'];

  List<String> chooseClasses = ['5 Class','6 Class','7 Class','8 Class',
    '9 Class','Secondary','11 Class','Senior Secondary','First Year','Second Year','Third Year','Parents'];

  List<String> selectCourses = ['NCERT','CBSE','GSEB','NTPC','PSEB','ICSE','UPSE'];

  List<String> selectSemesters = ['SEM 1','SEM 2','SEM 3','SEM 4','SEM 5','SEM 6'];

  Future<File> imageSizeCompress(
      {required File image, quality = 40, percentage = 50}) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,quality: 40,percentage: 50);
    return path;
  }

  get getSelectedClass {
    notifyListeners();
    return selectClass;
  }

  get getChooseClass {
    notifyListeners();
    return chooseClass;
  }

  get getSelectedCourse {
    notifyListeners();
    return selectCourse;
  }

  get getSemester {
    notifyListeners();
    return selectCourse;
  }
}