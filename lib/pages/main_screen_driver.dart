import 'dart:async';
import 'dart:convert';

import 'package:bangtong/login/loginScreen.dart';
import 'package:bangtong/pages/driver_first.dart';
import 'package:bangtong/pages/driver_first_listVersion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bangtong/pages/first.dart';
import 'package:bangtong/pages/board.dart';
import 'package:bangtong/pages/history.dart';
import 'package:bangtong/pages/4.dart';
import 'package:bangtong/pages/addScreen.dart';
import 'package:bangtong/pages/costlist.dart';
import 'package:bangtong/pages/setting.dart';

import '../../login/login.dart';
import '../../model/board.dart';
import '../../model/user.dart';
import '../function/loginUpdate.dart';
import '../user_pref.dart';
import 'history_D.dart';

class MainScreenDriver extends StatefulWidget {
  MainScreenDriver({Key? key}) : super(key: key);

  @override
  State<MainScreenDriver> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreenDriver> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _start();
    super.initState();
  }

  void _start() {
    _timer = Timer.periodic(Duration(minutes: 60), (timer) {
      setState(() {
        offDialog(2);
      });
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    // MainScreen(),
    Driver_first_list(), // 배차 등록 현황
    board(), // 게시판
    third_D(), // 배차 내역
    four(), // 상담문의
  ];

  int _selectedIndex = 0; // 선택된 페이지의 인덱스 넘버 초기화

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      // centerTitle: true,
      elevation: 1,
      title: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(LoginScreen.allName + "님,안녕하세요!"),
      ),
      actions: [
        IconButton(
          tooltip: "회원 정보",
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => Setting())));
          },
          icon: Icon(Icons.person),
        ),
        SizedBox(
          width: 1,
        ),
        IconButton(
          tooltip: "로그아웃",
          onPressed: () {
            offDialog(1);
            // Get.to(() => LoginPage());
          },
          icon: Icon(Icons.power_settings_new),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return offDialog(1);
      },
      child: Scaffold(
        appBar: _appbarWidget(),
        body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
        // bottom navigation 선언
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: '공지사항',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: '배차 내역',
            ),
            BottomNavigationBarItem(
              // icon: Icon(Icons.support_agent),
              icon: Icon(Icons.chat),
              label: '상담 문의',
            ),
          ],
          currentIndex: _selectedIndex, // 지정 인덱스로 이동
          selectedItemColor: Colors.lightGreen,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          onTap: _onItemTapped, // 선언했던 onItemTapped
          type: BottomNavigationBarType.shifting,
        ),
      ),
    );
  }

  Future<bool> offDialog(flag) async {
    BuildContext dialogContext;
    return await showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text(flag == 1 ? "로그아웃" : "시간 초과"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  flag == 1
                      ? "로그아웃 하시겠습니까?"
                      : "접속하신 지 한시간이 지났습니다.\n 로그아웃 하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("취소"),
                onPressed: () {
                  setState(() {
                    if (flag == 2) {
                      _start();
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  LogOut();
                },
              ),
            ],
          );
        });
  }

  void LogOut() {
    LoginUpdate.LoginflagChange(LoginScreen.allID, 'N');
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
