import 'dart:convert';

import 'package:bangtong/api/api.dart';
import 'package:bangtong/function/displaystring.dart';
import 'package:bangtong/login/loginScreen.dart';
import 'package:bangtong/model/orderboard.dart';
import 'package:bangtong/pages/DetailDriver.dart';
import 'package:bangtong/pages/end.dart';
import 'package:bangtong/pages/start.dart';
import 'package:bangtong/pages/steel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Driver_order extends StatefulWidget {
  const Driver_order({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Driver_order> {
  String strDday = '';
  String strNextDday = '';

  List<OrderData> boardList = [];
  String startArea = '';
  String url = '';
  // 토글 버튼
  bool _isAll = true;
  bool _isTodayStart = false;
  bool _isTomorrowStart = false;
  bool _isNextTomorrow = false;
  bool _isEtc = false;
  late List<bool> _isSelected;
  String selectedFlag = '';

  _request() async {
    if (startArea == '') {
      url = API
          .DriverOrder_all; //"http://am1009n.dothome.co.kr/DriverOrder_all.php";
    } else {
      url = API
          .StartArea; //"; //http://am1009n.dothome.co.kr/DriverOrder_StartArea.php"
    }

    var response = await http.post(Uri.parse(url),
        body: {'startArea': startArea, 'selectedFlag': selectedFlag});

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> json = jsonDecode(responseBody);

      if (json.length > 0) {
        for (var item in json.reversed) {
          OrderData boardData = OrderData(
              item['orderID'],
              item['orderIndex'],
              item['startArea'],
              item['endArea'],
              item['cost'],
              item['payMethod'],
              item['carKind'],
              item['product'],
              item['grade'],
              item['startDateTime'],
              item['endDateTime'],
              item['end1'],
              item['bottom'],
              item['startMethod'],
              item['steelCode'],
              item['orderYN'],
              item['confirmYN'],
              item['orderTel'],
              item['companyName'],
              item['userCarNo']);
          boardList.add(boardData);
        }
      } else {
        Fluttertoast.showToast(msg: '조회된 데이터가 없습니다.');
        return null;
      }

      setState(() {
        json = boardList;
      });

      return boardList;
    } else {
      Fluttertoast.showToast(msg: '데이터 로딩 실패!');
      return null;
    }
  }

  Future refresh() async {
    try {
      setState(() {
        if (!boardList.isEmpty) {
          boardList.clear();
        }
      });

      _request();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    // if (LoginScreen.paymentDay == null) {
    // } else {
    //   var dtToday = DateTime.now();
    //   DateTime dtPayDay = DateTime.parse(LoginScreen.paymentDay);
    //   DateTime dtNextPayDay = dtPayDay.add(Duration(days: 30));
    //   strNextDday = DateFormat("yyyy년 MM월 dd일").format(dtNextPayDay).toString();

    //   String date = DateFormat("yyyyMMdd").format(dtNextPayDay).toString();
    //   int difference =
    //       int.parse(dtToday.difference(DateTime.parse(date)).inDays.toString());
    //   strDday = difference.toString();
    // }

    startArea = '';
    _request();
    _isSelected = [
      _isAll,
      _isTodayStart,
      _isTomorrowStart,
      _isNextTomorrow,
      _isEtc
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '배차 오더',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
        ],
      ),
      body: Column(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: 30,
          //   color: Colors.white,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text('다음 결제일: $strNextDday'),
          //       SizedBox(width: 5),
          //       Text('D$strDday'),
          //     ],
          //   ),
          // ),
          Container(
            height: 60,
            child: Column(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButtons(
                        color: Colors.black.withOpacity(0.60),
                        selectedColor: Color(0xFF6200EE),
                        selectedBorderColor: Color(0xFF6200EE),
                        fillColor: Color(0xFF6200EE).withOpacity(0.08),
                        splashColor: Color(0xFF6200EE).withOpacity(0.12),
                        hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                        borderRadius: BorderRadius.circular(4.0),
                        constraints: BoxConstraints(minHeight: 36.0),
                        isSelected: _isSelected,
                        onPressed: toggleSelect,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('전체'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('오늘'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('내일'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('모래'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('기타'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    itemCount: boardList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(DisplayString.displayArea(
                                  boardList[index].startArea) +
                              " >> " +
                              DisplayString.displayArea(
                                  boardList[index].endArea)),
                          subtitle: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: '상차일시:',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                  DateTime.parse(
                                      boardList[index].startDateTime)),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '\n하차일시:',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                  DateTime.parse(boardList[index].endDateTime)),
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '\n운반비:',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            TextSpan(
                              text: boardList[index].cost,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ])),
                          isThreeLine: true,
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPageDriver(boardList[index])));
                            //refresh();
                          },
                        ),
                      );
                    })),
          ),
        ],
      ),
    );
  }

  void toggleSelect(value) async {
    if (value == 0) {
      _isAll = true;
      _isTodayStart = false;
      _isTomorrowStart = false;
      _isNextTomorrow = false;
      _isEtc = false;
      selectedFlag = '0';
    } else if (value == 1) {
      _isAll = false;
      _isTodayStart = true;
      _isTomorrowStart = false;
      _isNextTomorrow = false;
      _isEtc = false;
      selectedFlag = '1';
    } else if (value == 2) {
      _isAll = false;
      _isTodayStart = false;
      _isTomorrowStart = true;
      _isNextTomorrow = false;
      _isEtc = false;
      selectedFlag = '2';
    } else if (value == 3) {
      _isAll = false;
      _isTodayStart = false;
      _isTomorrowStart = false;
      _isNextTomorrow = true;
      _isEtc = false;
      selectedFlag = '3';
    } else {
      _isAll = false;
      _isTodayStart = false;
      _isTomorrowStart = false;
      _isNextTomorrow = false;
      _isEtc = true;
      selectedFlag = '4';
    }

    setState(() {
      _isSelected = [
        _isAll,
        _isTodayStart,
        _isTomorrowStart,
        _isNextTomorrow,
        _isEtc
      ];

      refresh();
    });
  }
}
