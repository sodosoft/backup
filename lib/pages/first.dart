import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../model/orderboard.dart';
import '../function/displaystring.dart';
import '../login/loginScreen.dart';
import 'addScreen.dart';
import 'editScreen.dart'; //flutter의 package를 가져오는 코드 반드시 필요

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<first> {
  List<OrderData> boardList = [];

  Future<List<OrderData>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.orderBoard), body: {
        'orderID': LoginScreen.allID,
      });

      if (respone.statusCode == 200) {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);
        List<OrderData> boardList = [];

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

        return boardList;
      } else {
        Fluttertoast.showToast(msg: '데이터 로딩 실패!');
        return null;
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future refresh() async {
    try {
      setState(() {
        if (!boardList.isEmpty) {
          boardList.clear();
        }
      });
      var respone = await http.post(Uri.parse(API.orderBoard), body: {
        'orderID': LoginScreen.allID,
      });

      if (respone.statusCode == 200) {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);
        List<OrderData> boardList = [];

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

        final data = boardList;

        setState(() {
          this.boardList = data;
        });

        return boardList;
      } else {
        Fluttertoast.showToast(msg: '데이터 로딩 실패!');
        return null;
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  String strDday = '';
  String strNextDday = '';

  @override
  void initState() {
    if (LoginScreen.paymentDay == null) {
    } else {
      var dtToday = DateTime.now();
      DateTime dtPayDay = DateTime.parse(LoginScreen.paymentDay);
      DateTime dtNextPayDay = dtPayDay.add(Duration(days: 30));
      strNextDday = DateFormat("yyyy년 MM월 dd일").format(dtNextPayDay).toString();

      String date = DateFormat("yyyyMMdd").format(dtNextPayDay).toString();
      int difference =
          int.parse(dtToday.difference(DateTime.parse(date)).inDays.toString());
      strDday = difference.toString();
    }
    refresh();
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
            height: 30,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('다음 결제일: $strNextDday'),
                SizedBox(width: 5),
                Text('D$strDday'),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: FutureBuilder(
                future: _getPost(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(DisplayString.displayArea(
                                      snapshot.data[index].startArea) +
                                  " >> " +
                                  DisplayString.displayArea(
                                      snapshot.data[index].endArea)),
                              subtitle: Text('상차일시: ' +
                                  DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                      DateTime.parse(
                                          snapshot.data[index].startDateTime)) +
                                  '\n' +
                                  '하차일시: ' +
                                  DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
                                      DateTime.parse(
                                          snapshot.data[index].endDateTime)) +
                                  '\n' +
                                  '운반비: ￦' +
                                  snapshot.data[index].cost +
                                  "원"),
                              isThreeLine: true,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditScreen(snapshot.data[index])));
                              },
                            ),
                          );
                        });
                  } else {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "배차 등록",
        onPressed: () async {
          final reuslt = await Navigator.push(
              context, MaterialPageRoute(builder: ((context) => AddScreen())));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
