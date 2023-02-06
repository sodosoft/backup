import 'dart:convert';

import 'package:bangtong/pages/weightDataScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/model/orderboard.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../api/api.dart';
import '../function/displaystring.dart';
import '../login/loginScreen.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

class third_D extends StatefulWidget {
  const third_D({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<third_D> {
  String subTotal = '';
  String itmCnt = '';
  var itemCounterController = TextEditingController();
  var serchController = TextEditingController();
  var selectedDateController1 = TextEditingController();
  var selectedDateController2 = TextEditingController();

  List<OrderData_driver> boardList = [];

  // 토글 버튼
  bool _isAll = true;
  bool _isMonth = false;
  bool _isLast = false;
  bool _isDirect = false;
  late List<bool> _isSelected;

  String selectedFlag = '';
  String selectedSearch = '';
  String _selectedDate1 = '';
  String _selectedDate2 = '';
  String monthStart = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, 1)); // 1st
  String monthEnd = DateFormat('yyyy-MM-dd').format(
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0)); // last
  String LastMonthStart = DateFormat('yyyy-MM-dd').format(
      DateTime(DateTime.now().year, DateTime.now().month - 1, 1)); // 1st
  String LastMonthEnd = DateFormat('yyyy-MM-dd')
      .format(DateTime(DateTime.now().year, DateTime.now().month, -1)); // 1st

  Future<List<OrderData_driver>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.order_D_HISTORY), body: {
        'userCarNo': LoginScreen.allCarNo,
        'searchFlag': selectedFlag,
        'monthStart': monthStart,
        'monthEnd': monthEnd,
        'LastMonthStart': LastMonthStart,
        'LastMonthEnd': LastMonthEnd
      });

      if (respone.statusCode == 200) {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);

        if (boardList.isEmpty) {
          for (var item in json.reversed) {
            OrderData_driver boardData = OrderData_driver(
                item['orderID'],
                item['startArea'],
                item['endArea'],
                item['cost'],
                item['startDateTime'],
                item['endDateTime'],
                item['steelCode'],
                item['orderTel'],
                item['userCarNo']);
            boardList.add(boardData);
          }
        }

        itmCnt = boardList.length.toString();
        subTotal = CostAdd(boardList);
        itemCounterController.text = '   총 $itmCnt 건  합계 $subTotal원';

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
    selectedFlag = '0';
    _range = '';
    _isSelected = [_isAll, _isMonth, _isLast, _isDirect];
    refresh();
  }

  Future refresh() async {
    try {
      setState(() {
        if (!boardList.isEmpty) {
          boardList.clear();
          itmCnt = '0';
          subTotal = '0';
        }
      });
      var respone = await http.post(Uri.parse(API.order_D_HISTORY), body: {
        'userCarNo': LoginScreen.allCarNo,
        'searchFlag': selectedFlag,
        'startDateTime': _selectedDate1,
        'endDateTime': _selectedDate2,
        'monthStart': monthStart,
        'monthEnd': monthEnd,
        'LastMonthStart': LastMonthStart,
        'LastMonthEnd': LastMonthEnd
      });

      if (respone.statusCode == 200) {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);
        List<OrderData_driver> boardList = [];

        if (boardList.isEmpty) {
          for (var item in json.reversed) {
            OrderData_driver boardData = OrderData_driver(
                item['orderID'],
                item['startArea'],
                item['endArea'],
                item['cost'],
                item['startDateTime'],
                item['endDateTime'],
                item['steelCode'],
                item['orderTel'],
                item['userCarNo']);
            boardList.add(boardData);
          }

          itmCnt = boardList.length.toString();
          subTotal = CostAdd(boardList);
        }

        itemCounterController.text = '   총 $itmCnt 건  합계 $subTotal원';

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
                            child: Text('이번달'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('지난달'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('직접설정'),
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
            child: boardList.isEmpty
                ? const Center(
                    child: Text("조회된 데이터가 없습니다."),
                  )
                : RefreshIndicator(
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
                                        DateFormat("yyyy년 MM월 dd일 HH시 mm분")
                                            .format(DateTime.parse(snapshot
                                                .data[index].startDateTime)) +
                                        '\n' +
                                        '하차일시: ' +
                                        DateFormat("yyyy년 MM월 dd일 HH시 mm분")
                                            .format(DateTime.parse(snapshot
                                                .data[index].endDateTime)) +
                                        '\n' +
                                        '운반비: ￦' +
                                        snapshot.data[index].cost +
                                        "원"),
                                    isThreeLine: true,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  snapshot.data[index])));
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
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Container(
              // 총 건수 & 총 합
              color: Colors.transparent,
              child: Column(
                children: [
                  TextField(
                      enabled: false,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      controller: itemCounterController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} ~'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
        selectedDateController1.text = _range;
        selectedDateController2.text = _range;
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  void toggleSelect(value) async {
    if (value == 0) {
      _isAll = true;
      _isMonth = false;
      _isLast = false;
      _isDirect = false;
      selectedFlag = '0';
    } else if (value == 1) {
      _isAll = false;
      _isMonth = true;
      _isLast = false;
      _isDirect = false;
      selectedFlag = '1';
    } else if (value == 2) {
      _isAll = false;
      _isMonth = false;
      _isLast = true;
      _isDirect = false;
      selectedFlag = '2';
    } else {
      _isAll = false;
      _isMonth = false;
      _isLast = false;
      _isDirect = true;
      selectedFlag = '3';
      selectedDateController1.text = '';
      selectedDateController2.text = '';

      FlutterDialog();
    }

    setState(() {
      _isSelected = [_isAll, _isMonth, _isLast, _isDirect];

      refresh();
    });
  }

  void FlutterDialog() async {
    showDialog(
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
                new Text("조회 기간", style: TextStyle(color: Colors.red)),
              ],
            ),
            //
            content: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  padding: EdgeInsets.fromLTRB(20, 240, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text('Selected date: $_selectedDate'),
                      TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          textAlign: TextAlign.center,
                          enabled: false,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          controller: selectedDateController2),
                      //Text('Selected ranges count: $_rangeCount')
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    // initialSelectedRange: PickerDateRange(
                    //     DateTime.now().subtract(const Duration(days: 4)),
                    //     DateTime.now().add(const Duration(days: 3))),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

String CostAdd(data) {
  int _add = 0;
  String result = '';
  int trimstr = 0;

  for (int i = 0; i < data.length; i++) {
    trimstr = int.parse(
        data[i].cost.replaceAll(RegExp('[^a-zA-Z0-9가-힣\\s]'), "").trim());
    _add += trimstr;
  }

  var f = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
  result = f.format(_add).toString();

  return result;
}

class DetailPage extends StatelessWidget {
  final OrderData_driver postData;

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
        child: Text('상차지: ' +
            postData.startArea +
            '\n' +
            '하차지: ' +
            postData.endArea +
            '\n' +
            '상차일시: ' +
            DateFormat("yyyy년 MM월 dd일 HH시 mm분")
                .format(DateTime.parse(postData.startDateTime)) +
            '\n' +
            '하차일시: ' +
            DateFormat("yyyy년 MM월 dd일 HH시 mm분")
                .format(DateTime.parse(postData.endDateTime)) +
            '\n' +
            '운반비: ￦' +
            postData.cost +
            "원"),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "계근정보 보내기",
        onPressed: () async {
          final reuslt = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => weightDataScreen(postData.orderTel))));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.wallpaper),
      ),
      //body: Text(postData.content),
    );
  }
}
