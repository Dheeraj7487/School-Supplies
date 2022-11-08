class UserModel {
  String? userId;
  String? userName;
  String? userEmail;
  String? userMobile;
  int? userRating;
  String? currentUser;
  String? timeStamp;

  UserModel(
      { this.userId,
        this.userName,
        this.userEmail,
        this.userMobile,
        this.userRating,
        this.currentUser,
        this.timeStamp});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userMobile = json['userMobile'];
    userRating = json['userRating'];
    currentUser = json['currentUser'];
    timeStamp = json['timeStamp'];
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     "messageid": messageid,
  //     "sender": sender,
  //     "text": text,
  //     "seen": seen,
  //     "timeStamp": timeStamp
  //   };
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['userMobile'] = userMobile;
    data['userRating'] = userRating;
    data['currentUser'] = currentUser;
    data['timeStamp'] = timeStamp;
    return data;
  }
}
