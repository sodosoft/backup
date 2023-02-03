class User_test{
  String userID;
  String userName;
  String userPassword;

  User_test(this.userID, this.userName, this.userPassword);

  factory User_test.fromJson(Map<String, dynamic> json) => User_test(
      json['userID'],
      json['userName'],
      json['userPassword']
  );

  Map<String, dynamic> toJson() => {
    'userID' : userID,
    'userName' : userName,
    'userPassword' : userPassword,
  };
}