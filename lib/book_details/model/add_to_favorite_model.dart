class AddToFavoriteModel {
  String? userId;
  String? publisherName;
  String? userEmail;
  String? userMobile;
  String? itemName;
  List? bookImages;
  String? toolImages;
  String? bookVideo;
  String? selectedClass;
  String? price;
  int? itemAvailable;
  int? discountPercentage;
  String? selectedCourse;
  String? selectedSemester;
  double? rating;
  String? currentUser;
  String? timeStamp;
  String? description;
  String? authorName;

  AddToFavoriteModel(
      { this.userId,
        this.publisherName,
        this.userEmail,
        this.userMobile,
        this.itemName,
        this.authorName,
        this.description,
        this.bookImages,
        this.toolImages,
        this.bookVideo,
        this.price,
        this.itemAvailable,
        this.discountPercentage,
        this.selectedClass,
        this.selectedCourse,
        this.selectedSemester,
        this.rating,
        this.currentUser,
        this.timeStamp
      });

  AddToFavoriteModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    publisherName = json['publisherName'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    itemName = json['name'];
    price = json['price'];
    itemAvailable = json['itemAvailable'];
    discountPercentage = json['discountPercentage'];
    authorName = json['authorName'];
    description = json['description'];
    bookImages = json['bookImages'];
    toolImages = json['toolImages'];
    bookVideo = json['bookVideo'];
    selectedClass = json['selectedClass'];
    selectedCourse = json['selectedCourse'];
    selectedSemester = json['selectedSemester'];
    rating = json['rating'];
    currentUser = json['currentUser'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['publisherName'] = publisherName;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['name'] = itemName;
    data['authorName'] = authorName;
    data['description'] = description;
    data['price'] = price;
    data['itemAvailable'] = itemAvailable;
    data['discountPercentage'] = discountPercentage;
    data['bookImages'] = bookImages;
    data['toolImages'] = toolImages;
    data['bookVideo'] = bookVideo;
    data['selectedClass'] = selectedClass;
    data['selectedCourse'] = selectedCourse;
    data['selectedSemester'] = selectedSemester;
    data['bookRating'] = rating;
    data['currentUser'] = currentUser;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
