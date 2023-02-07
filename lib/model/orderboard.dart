class OrderData {
  String orderID;
  String orderIndex;
  String startArea;
  String endArea;
  String cost;
  String payMethod;
  String carKind;
  String product;
  String grade;
  String startDateTime;
  String endDateTime;
  String end1;
  String bottom;
  String startMethod;
  String steelCode;
  String orderYN;
  String confirmYN;
  String orderTel;
  String companyName;
  String? userCarNo;

  OrderData(
      this.orderID,
      this.orderIndex,
      this.startArea,
      this.endArea,
      this.cost,
      this.payMethod,
      this.carKind,
      this.product,
      this.grade,
      this.startDateTime,
      this.endDateTime,
      this.end1,
      this.bottom,
      this.startMethod,
      this.steelCode,
      this.orderYN,
      this.confirmYN,
      this.orderTel,
      this.companyName,
      this.userCarNo);

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
      json['orderID'],
      json['orderIndex'],
      json['startArea'],
      json['endArea'],
      json['cost'],
      json['payMethod'],
      json['carKind'],
      json['product'],
      json['grade'],
      json['startDateTime'],
      json['endDateTime'],
      json['end1'],
      json['bottom'],
      json['startMethod'],
      json['steelCode'],
      json['orderYN'],
      json['confirmYN'],
      json['orderTel'],
      json['companyName'],
      json['userCarNo']);

  Map<String, dynamic> toJson() => {
        'orderID': orderID,
        'orderIndex': orderIndex,
        'startArea': startArea,
        'endArea': endArea,
        'cost': cost,
        'payMethod': payMethod,
        'carKind': carKind,
        'product': product,
        'grade': grade,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'end1': end1,
        'bottom': bottom,
        'startMethod': startMethod,
        'steelCode': steelCode,
        'orderYN': orderYN,
        'confirmYN': confirmYN,
        'orderTel': orderTel,
        'companyName': companyName,
        'userCarNo': userCarNo
      };
}

class OrderData_driver {
  String orderID;
  String startArea;
  String endArea;
  String cost;
  String startDateTime;
  String endDateTime;
  String steelCode;
  String orderTel;
  String userCarNo;

  OrderData_driver(
      this.orderID,
      this.startArea,
      this.endArea,
      this.cost,
      this.startDateTime,
      this.endDateTime,
      this.steelCode,
      this.orderTel,
      this.userCarNo);

  factory OrderData_driver.fromJson(Map<String, dynamic> json) =>
      OrderData_driver(
          json['orderID'],
          json['startArea'],
          json['endArea'],
          json['cost'],
          json['startDateTime'],
          json['endDateTime'],
          json['steelCode'],
          json['orderTel'],
          json['userCarNo']);

  Map<String, dynamic> toJson() => {
        'orderID': orderID,
        'startArea': startArea,
        'endArea': endArea,
        'cost': cost,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'steelCode': steelCode,
        'orderTel': orderTel,
        'userCarNo': userCarNo
      };
}
