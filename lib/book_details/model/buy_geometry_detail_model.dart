
class BuyToolDetailModel {
  String? userId;
  String? userEmail;
  String? userMobile;
  String? toolName;
  String? toolImages;
  String? publisherName;
  String? toolPrice;
  String? selectedCourse;
  String? selectedClass;
  String? selectedSemester;
  int? discountPercentage;
  int? toolAvailable;
  String? timeStamp;
  String? userAddress;

  BuyToolDetailModel(
      {  this.userId,
        this.userEmail,
        this.userMobile,
        this.toolName,
        this.toolImages,
        this.toolPrice,
        this.publisherName,
        this.selectedClass,
        this.selectedCourse,
        this.selectedSemester,
        this.toolAvailable,
        this.discountPercentage,
        this.userAddress,
        this.timeStamp
      });

  BuyToolDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    toolName = json['name'];
    toolImages = json['images'];
    publisherName = json['publisherName'];
    selectedSemester = json['selectedSemester'];
    selectedClass = json['selectedClass'];
    selectedCourse = json['selectedCourse'];
    toolPrice = json['price'];
    discountPercentage = json['discountPercentage'];
    toolAvailable = json['available'];
    userAddress = json['userAddress'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['name'] = toolName;
    data['selectedCourse'] = selectedCourse;
    data['selectedClass'] = selectedClass;
    data['selectedSemester'] = selectedSemester;
    data['images'] = toolImages;
    data['publisherName'] = publisherName;
    data['price'] = toolPrice;
    data['available'] = toolAvailable;
    data['discountPercentage'] = discountPercentage;
    data['userAddress'] = userAddress;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
