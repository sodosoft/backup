import 'dart:convert';

import 'package:bangtong/login/loginScreen.dart';
import 'package:bangtong/pages/end.dart';
import 'package:bangtong/pages/start.dart';
import 'package:bangtong/pages/steel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../model/orderboard.dart';

class Driver_first_Demo extends StatefulWidget {
  const Driver_first_Demo({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Driver_first_Demo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Generate List"),
      // ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 30,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('데모 화면입니다.')
                // Text('다음 결제일: $strNextDday'),
                // SizedBox(width: 5),
                // Text('D$strDday'),
              ],
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  child: Image.asset('assets/images/1.png', height: 175),
                  onTap: () {
                    //상차지 기준
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => startArea()));
                  })),
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  child: Image.asset('assets/images/3.png', height: 175),
                  onTap: () {
                    // 하차지 기준
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => endArea()));
                  })),
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  child: Image.asset('assets/images/2.png', height: 175),
                  onTap: () {
                    //제강사 기준
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => steeltArea()));
                  })),
        ],
      ),
    );
  }
}
