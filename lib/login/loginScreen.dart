import 'dart:convert';

import 'package:bangtong/function/loginUpdate.dart';
import 'package:bangtong/pages/loginflag.dart';
import 'package:bangtong/pages/setting.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bangtong/login/signup.dart';
import 'package:bangtong/pages/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:bangtong/pages/main_screen_driver.dart';

import '../api/api.dart';
import '../config/palette.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static late String allCarNo;
  static late String allID;
  static late String allPW;
  static late String allName;
  static late String allTel;
  static late String allComName;
  static late String allComNo;
  static late String allGrade;

  static late int cancelCount;
  static late String paymentDay;

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var idController = TextEditingController();
  var passwordController = TextEditingController();

  userLogin() async {
    try {
      var res = await http.post(Uri.parse(API.login), body: {
        'userID': idController.text.trim(),
        'userPassword': passwordController.text.trim()
      });

      if (res.statusCode == 200) {
        var resLogin = jsonDecode(res.body);
        if (resLogin['success'] == true) {
          // User userInfo = User.fromJson(resLogin['userName']);
          // await RememberUser.saveRememberUserInfo(userInfo);
          if (resLogin['loginFlag'].toString() == 'Y') {
            Fluttertoast.showToast(msg: '중복 접속입니다. 중복 해제 부탁 드립니다!');
          } else {
            String userName = resLogin['userName'].toString();
            String userPW = resLogin['userPassword'].toString();
            String userID = resLogin['userID'].toString();
            String userTel = resLogin['userTel'].toString();
            String paymentYN = resLogin['payment'].toString();
            String paymentDay = resLogin['paymentDay'].toString();
            int cancelCount = resLogin['cancelCount'];

            LoginUpdate.LoginflagChange(userID, 'Y');

            Fluttertoast.showToast(msg: '로그인 성공!');

            LoginScreen.allID = userID;
            LoginScreen.allPW = userPW;
            LoginScreen.allName = userName;
            LoginScreen.allTel = userTel;
            LoginScreen.paymentDay = paymentDay;
            LoginScreen.cancelCount = cancelCount;

            String userGrade = resLogin['userGrade'].toString();

            LoginScreen.allGrade = userGrade;
            LoginScreen.allComName = resLogin['userCompany'].toString();
            LoginScreen.allComNo = resLogin['userComNo'].toString();
            LoginScreen.allCarNo = resLogin['userCarNo'].toString();

            if (paymentYN == 'Y') {
              if (userGrade == 'D') {
                // 차주 전용 화면
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreenDriver()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
              }

              setState(() {
                idController.clear();
                passwordController.clear();
              });
            } else //미결제
            {
              Fluttertoast.showToast(msg: '결제 부탁 드립니다!');
              //데모 화면
            }
          }
        } else {
          Fluttertoast.showToast(msg: '아이디와 비밀 번호를 확인해주세요!');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/green2.jpg'),
                    fit: BoxFit.fill),
              ),
              child: Container(
                  padding: EdgeInsets.only(top: 90, left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '방통 배차 시스템',
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 25,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'ⓒCopyright 2023, SODOsoft',
                            style: TextStyle(
                              letterSpacing: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      Image(
                        image: AssetImage('assets/images/truck.gif'),
                        width: 80.0,
                        height: 80.0,
                      ),
                    ],
                  )),
            ),
          ),
          //배경
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            top: 220,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              padding: EdgeInsets.all(20.0),
              height: 230.0,
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Text(
                          '로그인',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Palette.textColor1),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: idController,
                            obscureText: false,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Palette.iconColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.textColor1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(35.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.textColor1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(35.0),
                                  ),
                                ),
                                hintText: '아이디',
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Palette.textColor1),
                                contentPadding: EdgeInsets.all(10)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Palette.iconColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.textColor1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(35.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palette.textColor1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(35.0),
                                  ),
                                ),
                                hintText: '비밀 번호',
                                hintStyle: TextStyle(
                                    fontSize: 14, color: Palette.textColor1),
                                contentPadding: EdgeInsets.all(10)),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //텍스트 폼 필드
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            top: 400,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(15),
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.greenAccent, Colors.green],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    color: Colors.white,
                    tooltip: '로그인',
                    onPressed: () async {
                      if (idController.text != '' &&
                          passwordController.text != '') {
                        userLogin();
                      } else if (idController.text == '' &&
                          passwordController.text == '') {
                        Fluttertoast.showToast(msg: '아이디와 비밀 번호를 입력해주세요!');
                        return;
                      } else if (idController.text == '') {
                        Fluttertoast.showToast(msg: '아이디를 입력해주세요!');
                        return;
                      } else if (passwordController.text == '') {
                        Fluttertoast.showToast(msg: '비밀 번호를 입력해주세요!');
                        return;
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          //전송버튼
          Positioned(
            top: MediaQuery.of(context).size.height - 205,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('회원이 아니신가요?'),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupPage())),
                      child: Text(
                        ' 회원 가입!',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('중복 접속 중이신가요?'),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => loginFlag())),
                      child: Text(
                        ' 중복해제!',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
