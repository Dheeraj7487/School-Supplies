
class BuyBookDetailModel {
  String? userId;
  String? userEmail;
  String? userMobile;
  String? bookName;
  List? bookImages;
  String? bookVideo;
  String? selectedClass;
  String? bookPrice;
  int? discountPercentage;
  int? bookAvailable;
  String? selectedCourse;
  String? selectedSemester;
  String? timeStamp;
  String? authorName;
  String? userAddress;

  BuyBookDetailModel(
      {  this.userId,
         this.userEmail,
         this.userMobile,
         this.bookName,
         this.authorName,
         this.bookImages,
         this.bookVideo,
         this.bookPrice,
         this.bookAvailable,
         this.discountPercentage,
         this.selectedClass,
         this.selectedCourse,
         this.selectedSemester,
         this.userAddress,
         this.timeStamp
      });

  BuyBookDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    bookName = json['bookName'];
    authorName = json['authorName'];
    bookImages = json['bookImages'];
    bookVideo = json['bookVideo'];
    bookPrice = json['bookPrice'];
    discountPercentage = json['discountPercentage'];
    bookAvailable = json['bookAvailable'];
    selectedClass = json['selectedClass'];
    selectedCourse = json['selectedCourse'];
    selectedSemester = json['selectedSemester'];
    userAddress = json['userAddress'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['bookName'] = bookName;
    data['authorName'] = authorName;
    data['bookImages'] = bookImages;
    data['bookVideo'] = bookVideo;
    data['bookPrice'] = bookPrice;
    data['bookAvailable'] = bookAvailable;
    data['discountPercentage'] = discountPercentage;
    data['selectedClass'] = selectedClass;
    data['selectedCourse'] = selectedCourse;
    data['selectedSemester'] = selectedSemester;
    data['userAddress'] = userAddress;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
