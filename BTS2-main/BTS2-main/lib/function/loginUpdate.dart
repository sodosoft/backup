import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api.dart';

class LoginUpdate{
  String loginFlag;

  LoginUpdate(this.loginFlag);

  static LoginflagChange(userID, flag)
  async {
    String result = '';

    var res = await http.post(Uri.parse(API.loginUpdate), body: {
      'userID': userID,
      'loginFlag': flag,
    });

    if (res.statusCode == 200) {
      var resLogin = jsonDecode(res.body);
      if (resLogin['success'] == true)
      {
        result = '변경 성공';
      }
      else
      {
        result = '변경 실패';
      }
    }
    return result;
  }
}