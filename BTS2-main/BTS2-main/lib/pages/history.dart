import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/model/orderboard.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../function/displaystring.dart';
import '../login/loginScreen.dart';

class third extends StatefulWidget {
  const third({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<third> {
  int _itemCnt = 0;
  int _subTotal = 0;
  String itmCnt = '';

  Future<List<OrderData>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.order_HISTORY), body: {
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

  @override
  void initState() {
    super.initState();

    _getPost();
  }

  final myController = TextEditingController();

  Future refresh() async {
    _getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text('건'),
      //   foregroundColor: Colors.green,
      //   backgroundColor: Colors.white,
      //   shadowColor: Colors.white,
      //   actions: [
      //     IconButton(
      //         tooltip: "검색",
      //         onPressed: () {
      //           //검색 조건 창 띄움
      //         },
      //         icon: Icon(Icons.search))
      //   ],
      // ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  child: const Text('검색조건1'),
                ),
                SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                  child: const Text('검색조건2'),
                ),
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
                    _subTotal = CostAdd(snapshot.data);
                    itmCnt = snapshot.data.length.toString();

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
                              subtitle: Text('상차일시: ' + DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(DateTime.parse(snapshot.data[index].startDateTime)) +
                                  '\n' +
                                  '하차일시: ' + DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(DateTime.parse(snapshot.data[index].endDateTime)) +
                                  '\n' +
                                  '운반비: ￦' + snapshot.data[index].cost + "원"),
                              isThreeLine: true,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(snapshot.data[index])));
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
          Container(
            // 총 건수 & 총 합
            color: Colors.green,
            height: 50,
          ),
        ],
      ),
    );
  }
}

int CostAdd(data) {
  int _add = 0;

  for (int i = 0; i > data.length; i++) {
    _add += int.parse(data[i].cost);
  }

  return _add;
}

class DetailPage extends StatelessWidget {
  final OrderData postData;

  DetailPage(this.postData); // 생성자를 통해서 입력변수 받기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(DisplayString.displayArea(postData.startArea) +
            " >> " +
            DisplayString.displayArea(postData.endArea)),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child:
            Text('상차지: ' + postData.startArea.toString()  + '\n' +
                 '하차지: ' + postData.endArea.toString()  + '\n' +
                 '상차일시: ' + DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(DateTime.parse(postData.startDateTime)) + '\n' +
                 '하차일시: ' + DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(DateTime.parse(postData.endDateTime)) + '\n' +
                 '운반비: ￦' + postData.cost + "원"  + '\n' +
                 '지불방식: ' + postData.payMethod.toString()  + '\n' +
                 '차종: ' + postData.carKind.toString()  + '\n' +
                 '품목: ' + postData.product.toString()  + '\n' +
                 '등급: ' + postData.grade.toString()  + '\n' +
                 '상차방법: ' + postData.startMethod.toString()  + '\n' +
                 '차량번호: ' + postData.userCarNo.toString()
            ),
      ),
      //body: Text(postData.content),
    );
  }
}
