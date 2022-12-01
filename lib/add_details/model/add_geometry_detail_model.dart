class AddGeometryBoxDetailModel {
  String? userId;
  String? publisherName;
  String? userEmail;
  String? userMobile;
  String? toolName;
  String? toolImages;
  String? toolPrice;
  int? toolAvailable;
  int? discountPercentage;
  double? toolRating;
  String? currentUser;
  String? timeStamp;

  AddGeometryBoxDetailModel(
      { this.userId,
        this.publisherName,
        this.userEmail,
        this.userMobile,
        this.toolName,
        this.toolImages,
        this.toolPrice,
        this.toolAvailable,
        this.discountPercentage,
        this.toolRating,
        this.currentUser,
        this.timeStamp
      });

  AddGeometryBoxDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    publisherName = json['publisherName'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    toolName = json['toolName'];
    toolPrice = json['price'];
    toolAvailable = json['toolAvailable'];
    discountPercentage = json['discountPercentage'];
    toolImages = json['toolImages'];
    toolRating = json['toolRating'];
    currentUser = json['currentUser'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['publisherName'] = publisherName;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['toolName'] = toolName;
    data['price'] = toolPrice;
    data['toolAvailable'] = toolAvailable;
    data['discountPercentage'] = discountPercentage;
    data['toolImages'] = toolImages;
    data['toolRating'] = toolRating;
    data['currentUser'] = currentUser;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
