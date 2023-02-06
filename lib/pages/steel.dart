import 'dart:convert';

import 'package:bangtong/api/api.dart';
import 'package:bangtong/pages/DetailDriver.dart';
import 'package:bangtong/pages/editScreen.dart';
import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';

import '../function/displaystring.dart';
import '../model/orderboard.dart';
import 'package:http/http.dart' as http;

class steeltArea extends StatefulWidget {
  const steeltArea({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<steeltArea> {
  List<OrderData> boardList = [];
  String endArea = '';
  String endArea2 = '';
  String endArea3 = '';
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
    if (endArea == '') {
      url = API
          .DriverOrder_all; //"http://am1009n.dothome.co.kr/DriverOrder_all.php";
    } else {
      url =
          API.Steel; //"; //http://am1009n.dothome.co.kr/DriverOrder_Steel.php"
    }

    var response = await http.post(Uri.parse(url), body: {
      'endArea': endArea,
      'endArea1': endArea2,
      'endArea2': endArea3,
      'selectedFlag': selectedFlag
    });

    var statusCode = response.statusCode;

    List<OrderData> list = [];
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
    _isSelected = [
      _isAll,
      _isTodayStart,
      _isTomorrowStart,
      _isNextTomorrow,
      _isEtc
    ];
    _request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '제강사 기준 배차 오더',
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
      drawer: Container(
        // width: 50,
        // height: double.infinity,
        child: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey[850],
                ),
                title: Text('제강사 목록'),
              ),
              ListTile(
                title: Text('전체'),
                onTap: () {
                  Fluttertoast.showToast(msg: '전체 제강사');
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('동국제강(인천)'),
                onTap: () {
                  Fluttertoast.showToast(msg: '동국제강(인천)');
                  Navigator.pop(context);
                  endArea = '동국';
                  endArea2 = '중봉대로 15';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('현대제철(인천)'),
                onTap: () {
                  Fluttertoast.showToast(msg: '현대제철(인천)');
                  Navigator.pop(context);
                  endArea = '현대';
                  endArea2 = '중봉대로 63';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('세아베스틸'),
                onTap: () {
                  Fluttertoast.showToast(msg: '세아베스틸');
                  Navigator.pop(context);
                  endArea = '세아';
                  endArea2 = '외할로 522';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('환영철강'),
                onTap: () {
                  Fluttertoast.showToast(msg: '환영철강');
                  Navigator.pop(context);
                  endArea = '환영';
                  endArea2 = '보덕포로 587';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('한국특수형강'),
                onTap: () {
                  Fluttertoast.showToast(msg: '한국특수형강');
                  Navigator.pop(context);
                  endArea = '한국';
                  //공단동길 98
                  endArea2 = '공단동길 98';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('대한제강'),
                onTap: () {
                  Fluttertoast.showToast(msg: '대한제강');
                  Navigator.pop(context);
                  endArea = '대한';
                  endArea2 = '평택항로268번길';
                  endArea3 = '녹산산업북로 333';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('포스코'),
                onTap: () {
                  Fluttertoast.showToast(msg: '포스코');
                  Navigator.pop(context);
                  endArea = '포스코';
                  endArea2 = 'POSCO';
                  endArea3 = '동해안로 6213번길';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                title: Text('YK스틸'),
                onTap: () {
                  Fluttertoast.showToast(msg: 'YK스틸');
                  Navigator.pop(context);
                  endArea = 'YK';
                  endArea2 = '을숙도대로 760';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
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
                            refresh();
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
