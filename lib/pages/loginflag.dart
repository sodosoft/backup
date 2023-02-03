import 'dart:convert';

import 'package:bangtong/api/api.dart';
import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../function/loginUpdate.dart';
import 'package:http/http.dart' as http;

class loginFlag extends StatefulWidget {
  const loginFlag({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<loginFlag> {
  var formKey = GlobalKey<FormState>();
  var idController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: idController,
                          validator: (val) =>
                          val == "" ? "아이디를 입력하세요!" : null,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: '아이디'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: passwordController,
                          validator: (val) =>
                          val == "" ? "비밀 번호를 입력하세요!" : null,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: '비밀번호'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  var res = await http.post(Uri.parse(API.login), body: {
                    'userID': idController.text.trim(),
                    'userPassword': passwordController.text.trim()
                  });

                  if (res.statusCode == 200) {
                    var resLogin = jsonDecode(res.body);
                    if (resLogin['success'] == true) {
                      LoginUpdate.LoginflagChange(idController.text, 'N');
                      Fluttertoast.showToast(msg: '중복 접속이 해제되었습니다!');

                      Navigator.pop(context);
                    }
                    else
                    {
                      Fluttertoast.showToast(msg: '아이디와 비밀 번호를 확인해주세요!');
                    }
                  }
                }
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        '중복해제',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: ()  {
                Navigator.pop(context);
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        '취소',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

