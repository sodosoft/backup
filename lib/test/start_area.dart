import 'dart:convert';

import 'package:bangtong/api/api.dart';
import 'package:bangtong/pages/DetailDriver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../function/displaystring.dart';
import '../model/orderboard.dart';
import 'package:http/http.dart' as http;

class start_area extends StatefulWidget {
  const start_area({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<start_area> {

  List<OrderData> boardList = [];
  String startArea = '';
  String url = '';

  _requset() async {

    if(startArea == '') {
      url = API.DriverOrder_all; //"http://am1009n.dothome.co.kr/DriverOrder_all.php";
    }
    else {
      url = API.StartArea; //"; //http://am1009n.dothome.co.kr/DriverOrder_StartArea.php"
    }

    var response = await http.post(Uri.parse(url));
    var statusCode = response.statusCode;

    List<OrderData> list = [];
    if (statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      list = jsonDecode(responseBody);
    }

    setState(() {
      boardList = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _requset();
  }

  @override
  Widget build(BuildContext context) {

    var _navigationTextStyle = TextStyle(color: CupertinoColors.white, fontFamily: 'GyeonggiMedium');
    var _listTextStyle = TextStyle(color: CupertinoColors.black, fontFamily: 'GyeonggiLight');

    var _navigationBar = CupertinoNavigationBar(
        leading: IconButton(icon: Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => {
              Scaffold.of(context).openEndDrawer()
            }),
            middle: Text("안녕", style: _navigationTextStyle),
            backgroundColor: CupertinoColors.systemGreen,
            trailing: Align(
                widthFactor: 1.0,
                alignment: Alignment.center,
                child: CupertinoButton(child: Text("닫기",style: TextStyle(color: Colors.white)),
                onPressed: () => {
                                    Navigator.pop(context)
                })
    ),);

    var _listView = ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: boardList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(DisplayString.displayArea(
                boardList[index].startArea) +
                " >> " +
                DisplayString.displayArea(
                    boardList[index].endArea)),
            subtitle: Text('상차일시: ' +
                DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                    DateTime.parse(
                        boardList[index].startDateTime)) +
                '\n' +
                '하차일시: ' +
                DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                    DateTime.parse(
                        boardList[index].endDateTime)) +
                '\n' +
                '운반비: ￦' +
                boardList[index].cost +
                "원"),
            isThreeLine: true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPageDriver(boardList[index])));
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );

    return CupertinoPageScaffold(
      navigationBar: _navigationBar,
      child: _listView,
    );
  }
}



