class User{
  String user_id;
  String user_name;
  String user_password;
  String userTel;
  String userGrade;
  String userCompany;
  String userComNo;
  String userCarNo;
  String loginTime;
  String steelCode;
  int codeCount;
  int cancelCount;
  String loginFlag;
  String payment;
  String paymentDay;
  String introducer;
  String loginT;
  String deviceID;

  User(this.user_id, this.user_password, this.user_name, this.userTel,
      this.userGrade, this.userCompany, this.userComNo, this.userCarNo,
      this.loginTime, this.steelCode, this.codeCount, this.cancelCount,
      this.loginFlag, this.payment, this.paymentDay, this.introducer, this.loginT, this.deviceID
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
      json['userID'],
      json['userPassword'],
      json['userName'],
      json['userGrade'],
      json['userTel'],
      json['userCompany'],
      json['userComNo'],
      json['userCarNo'],
      json['loginTime'],
      json['steelCode'],
      json['codeCount'],
      json['cancelCount'],
      json['loginFlag'],
      json['payment'],
      json['paymentDay'],
      json['introducer'],
      json['loginT'],
      json['deviceID']
  );

  Map<String, dynamic> toJson() => {
    'userID' : user_id,
    'userPassword' : user_password,
    'userName' : user_name,
    'userGrade' : userGrade,
    'userTel' : userTel,
    'userCompany' : userCompany,
    'userComNo' : userComNo,
    'userCarNo' : userCarNo,
    'steelCode' : steelCode,
    'codeCount' : codeCount.toString(),
    'cancelCount' : cancelCount.toString(),
    'loginFlag' : loginFlag,
    'payment' : payment,
    'paymentDay' : paymentDay,
    'introducer' : introducer,
    'loginT' : loginT,
    'deviceID' : deviceID
  };
}