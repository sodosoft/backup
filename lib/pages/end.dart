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

class endArea extends StatefulWidget {
  const endArea({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<endArea> {
  List<OrderData> boardList = [];
  String endArea = '';
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
      url = API
          .EndArea; //"; //http://am1009n.dothome.co.kr/DriverOrder_EndArea.php"
    }

    var response = await http.post(Uri.parse(url),
        body: {'endArea': endArea, 'selectedFlag': selectedFlag});

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
          '하차지 기준 배차 오더',
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
                dense: true,
                leading: Icon(
                  Icons.download_outlined,
                  color: Colors.grey[850],
                ),
                title: Text('하차지 목록'),
              ),
              ListTile(
                dense: true,
                title: Text('전체'),
                onTap: () {
                  Fluttertoast.showToast(msg: '전체 지역');
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('서울'),
                onTap: () {
                  Fluttertoast.showToast(msg: '서울 지역');
                  Navigator.pop(context);
                  endArea = '서울';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('인천'),
                onTap: () {
                  Fluttertoast.showToast(msg: '인천 지역');
                  Navigator.pop(context);
                  endArea = '인천';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('경기'),
                onTap: () {
                  Fluttertoast.showToast(msg: '경기 지역');
                  Navigator.pop(context);
                  endArea = '경기';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('강원'),
                onTap: () {
                  Fluttertoast.showToast(msg: '강원 지역');
                  Navigator.pop(context);
                  endArea = '강원';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('대전'),
                onTap: () {
                  Fluttertoast.showToast(msg: '대전 지역');
                  endArea = '대전';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('충남'),
                onTap: () {
                  Fluttertoast.showToast(msg: '충남 지역');
                  Navigator.pop(context);
                  endArea = '충남';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('충북'),
                onTap: () {
                  Fluttertoast.showToast(msg: '충북 지역');
                  Navigator.pop(context);
                  endArea = '충북';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('광주'),
                onTap: () {
                  Fluttertoast.showToast(msg: '광주 지역');
                  Navigator.pop(context);
                  endArea = '광주';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('전남'),
                onTap: () {
                  Fluttertoast.showToast(msg: '전남 지역');
                  Navigator.pop(context);
                  endArea = '전남';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('전북'),
                onTap: () {
                  Fluttertoast.showToast(msg: '전북 지역');
                  Navigator.pop(context);
                  endArea = '전북';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('부산'),
                onTap: () {
                  Fluttertoast.showToast(msg: '부산 지역');
                  Navigator.pop(context);
                  endArea = '부산';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('경남'),
                onTap: () {
                  Fluttertoast.showToast(msg: '경남 지역');
                  Navigator.pop(context);
                  endArea = '경남';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('대구'),
                onTap: () {
                  Fluttertoast.showToast(msg: '대구 지역');
                  Navigator.pop(context);
                  endArea = '대구';
                  Future.delayed(const Duration(milliseconds: 500), () {
                    refresh();
                  });
                },
              ),
              ListTile(
                dense: true,
                title: Text('경북'),
                onTap: () {
                  Fluttertoast.showToast(msg: '경북 지역');
                  Navigator.pop(context);
                  endArea = '경북';
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
