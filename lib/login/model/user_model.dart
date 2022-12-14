class UserModel {
  String? userId;
  String? userName;
  String? userEmail;
  String? userMobile;
  String? userAddress;
  String? chooseClass;
  String? fcmToken;
  int? userRating;
  String? currentUser;
  String? timeStamp;

  UserModel(
      { this.userId,
        this.userName,
        this.userEmail,
        this.userMobile,
        this.userAddress,
        this.fcmToken,
        this.chooseClass,
        this.userRating,
        this.currentUser,
        this.timeStamp});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    chooseClass = json['chooseClass'];
    userMobile = json['userMobile'];
    userAddress = json['userAddress'];
    fcmToken = json['fcmToken'];
    userRating = json['userRating'];
    currentUser = json['currentUser'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['userAddress'] = userAddress;
    data['chooseClass'] = chooseClass;
    data['fcmToken'] = fcmToken;
    data['userRating'] = userRating;
    data['currentUser'] = currentUser;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
