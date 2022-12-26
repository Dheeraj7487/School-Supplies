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
  int? itemAvailable;
  int? discountPercentage;
  String? selectedCourse;
  String? selectedSemester;
  double? bookRating;
  String? currentUser;
  String? timeStamp;
  String? description;
  String? authorName;

  AddBookDetailModel(
      { this.userId,
        this.publisherName,
        this.userEmail,
        this.userMobile,
        this.bookName,
        this.authorName,
        this.description,
        this.bookImages,
        this.bookVideo,
        this.price,
        this.itemAvailable,
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
    bookName = json['name'];
    price = json['price'];
    itemAvailable = json['itemAvailable'];
    discountPercentage = json['discountPercentage'];
    authorName = json['authorName'];
    description = json['description'];
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
    data['name'] = bookName;
    data['authorName'] = authorName;
    data['description'] = description;
    data['price'] = price;
    data['itemAvailable'] = itemAvailable;
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
