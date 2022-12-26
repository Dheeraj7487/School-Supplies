class AddGeometryBoxDetailModel {
  String? userId;
  String? docId;
  String? publisherName;
  String? userEmail;
  String? userMobile;
  String? toolName;
  String? toolImages;
  String? description;
  String? toolPrice;
  int? itemAvailable;
  int? discountPercentage;
  double? toolRating;
  String? currentUser;
  String? timeStamp;

  AddGeometryBoxDetailModel(
      { this.userId,
        this.docId,
        this.publisherName,
        this.userEmail,
        this.userMobile,
        this.toolName,
        this.description,
        this.toolImages,
        this.toolPrice,
        this.itemAvailable,
        this.discountPercentage,
        this.toolRating,
        this.currentUser,
        this.timeStamp
      });

  AddGeometryBoxDetailModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    docId = json['docId'];
    publisherName = json['publisherName'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    toolName = json['name'];
    description = json['description'];
    toolPrice = json['price'];
    itemAvailable = json['itemAvailable'];
    discountPercentage = json['discountPercentage'];
    toolImages = json['toolImages'];
    toolRating = json['rating'];
    currentUser = json['currentUser'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['docId'] = docId;
    data['publisherName'] = publisherName;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['name'] = toolName;
    data['description'] = description;
    data['price'] = toolPrice;
    data['itemAvailable'] = itemAvailable;
    data['discountPercentage'] = discountPercentage;
    data['toolImages'] = toolImages;
    data['rating'] = toolRating;
    data['currentUser'] = currentUser;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
