class AddBookDetailModel {
  String? userId;
  String? publisherName;
  String? userEmail;
  String? userMobile;
  String? bookName;
  List? bookImages;
  String? bookVideo;
  String? selectedClass;
  String? price;
  int? bookAvailable;
  int? discountPercentage;
  String? selectedCourse;
  String? selectedSemester;
  double? bookRating;
  String? currentUser;
  String? timeStamp;
  String? bookDescription;
  String? authorName;

  AddBookDetailModel(
      { this.userId,
        this.publisherName,
        this.userEmail,
        this.userMobile,
        this.bookName,
        this.authorName,
        this.bookDescription,
        this.bookImages,
        this.bookVideo,
        this.price,
        this.bookAvailable,
        this.discountPercentage,
        this.selectedClass,
        this.selectedCourse,
        this.selectedSemester,
        this.bookRating,
        this.currentUser,
        this.timeStamp
      });

  AddBookDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    publisherName = json['publisherName'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    bookName = json['bookName'];
    price = json['bookPrice'];
    bookAvailable = json['bookAvailable'];
    discountPercentage = json['discountPercentage'];
    authorName = json['authorName'];
    bookDescription = json['bookDescription'];
    bookImages = json['bookImages'];
    bookVideo = json['bookVideo'];
    selectedClass = json['selectedClass'];
    selectedCourse = json['selectedCourse'];
    selectedSemester = json['selectedSemester'];
    bookRating = json['bookRating'];
    currentUser = json['currentUser'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['publisherName'] = publisherName;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['bookName'] = bookName;
    data['authorName'] = authorName;
    data['bookDescription'] = bookDescription;
    data['bookPrice'] = price;
    data['bookAvailable'] = bookAvailable;
    data['discountPercentage'] = discountPercentage;
    data['bookImages'] = bookImages;
    data['bookVideo'] = bookVideo;
    data['selectedClass'] = selectedClass;
    data['selectedCourse'] = selectedCourse;
    data['selectedSemester'] = selectedSemester;
    data['bookRating'] = bookRating;
    data['currentUser'] = currentUser;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
