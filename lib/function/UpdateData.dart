import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';

class UpdateData {
  String loginID;

  UpdateData(this.loginID);

  static passwordChange(userID, password) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdatePassWord), body: {
      'userID': userID,
      'userPassword': password,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static TelChange(userID, telNo) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdateTel), body: {
      'userID': userID,
      'userTel': telNo,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static companyChange(userID, company) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdateCom), body: {
      'userID': userID,
      'userCompany': company,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static comNoChange(userID, comNo) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdateComNo), body: {
      'userID': userID,
      'userComNo': comNo,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static carNoChange(userID, carNo) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdateCarNO), body: {
      'userID': userID,
      'userCarNo': carNo,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static deviceIDChange(userID, deviceID) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdatedeviceID), body: {
      'userID': userID,
      'deviceID': deviceID,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static calcelCountChange(userID, cancelCount) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdateCancelCount),
        body: {'userID': userID, 'cancelCount': cancelCount});

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static orederYNChange(orderIndex, orderYN) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdateOrderYN),
        body: {'orderIndex': orderIndex, 'orderYN': orderYN});

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  static confirmYNChange(orderIndex, userCarNo, confirmYN) async {
    bool result = false;

    var res = await http.post(Uri.parse(API.UpdateConfirmYN), body: {
      'orderIndex': orderIndex,
      'userCarNo': userCarNo,
      'confirmYN': confirmYN
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }
}
