import 'dart:convert';

import 'package:bangtong/pages/weightDataScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bangtong/model/orderboard.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  bool _isAll = false;
  bool _is1Month = false;
  bool _is3Month = false;
  bool _isDirect = false;
  final _isSelected = <bool>[false, false, false, false];
  String selectedFlag = '';
  String selectedSearch = '';
  String _selectedDate1 = '';
  String _selectedDate2 = '';

  Future<List<OrderData_driver>?> _getPost() async {
    try {
      var respone = await http.post(Uri.parse(API.order_D_HISTORY), body: {
        'userCarNo': LoginScreen.allCarNo,
        'searchFlag': selectedFlag
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
    selectedSearch = '전체';

    _selectedDate1 = '시작일';
    _selectedDate2 = '마지막일';
    refresh();
  }

  final myController = TextEditingController();

  Future refresh() async {
    try {
      setState(() {
        if (!boardList.isEmpty) {
          boardList.clear();
        }
      });
      var respone = await http.post(Uri.parse(API.order_D_HISTORY), body: {
        'userCarNo': LoginScreen.allCarNo,
        'searchFlag': selectedFlag,
        'startDateTime': _selectedDate1,
        'endDateTime': _selectedDate2
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
        }

        itmCnt = boardList.length.toString();
        subTotal = CostAdd(boardList);
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
          // Container(
          //   height: 40,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       IconButton(
          //         onPressed: () async {
          //           showAdaptiveActionSheet(
          //             context: context,
          //             title: const Text('조회기간'),
          //             androidBorderRadius: 30,
          //             actions: <BottomSheetAction>[
          //               BottomSheetAction(
          //                   title: const Text('1개월'),
          //                   onPressed: (context) {
          //                     //1개월
          //                     serchController.text = "1개월";
          //                     selectedFlag = "1";
          //                     refresh();
          //                   }),
          //               BottomSheetAction(
          //                   title: const Text('3개월'),
          //                   onPressed: (context) {
          //                     //3개월
          //                     serchController.text = "3개월";
          //                     selectedFlag = "2";
          //                     refresh();
          //                   }),
          //               BottomSheetAction(
          //                   title: const Text('직접입력'),
          //                   onPressed: (context) {
          //                     //직접입력
          //                     serchController.text = "직접입력";
          //                     selectedFlag = "3";
          //                     //조회기간 띄우는 다이알로그
          //                     //refresh();
          //                   }),
          //               BottomSheetAction(
          //                   title: const Text('전체'),
          //                   onPressed: (context) {
          //                     //직접입력
          //                     serchController.text = "전체";
          //                     selectedFlag = "0";
          //                     refresh();
          //                   }),
          //             ],
          //             cancelAction: CancelAction(
          //                 title: const Text(
          //                     '취소')), // onPressed parameter is optional by default will dismiss the ActionSheet
          //           );
          //         },
          //         icon: Icon(Icons.search),
          //         tooltip: '검색',
          //       ),
          //       SizedBox(
          //         width: 15,
          //       ),
          //       TextField(
          //           enabled: false,
          //           style: TextStyle(color: Colors.black, fontSize: 18),
          //           controller: serchController),
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
                        onPressed: (index) {
                          // Respond to button selection
                          setState(() {
                            _isSelected[index] = !_isSelected[index];

                            if (_isSelected[0]) {
                              selectedFlag = '0';
                              _isSelected[0] = false;
                              refresh();
                            } else if (_isSelected[1]) {
                              selectedFlag = '1';
                              _isSelected[1] = false;

                              refresh();
                            } else if (_isSelected[2]) {
                              selectedFlag = '2';
                              _isSelected[2] = false;
                              //_isSelected[3] = false;
                              refresh();
                            } else if (_isSelected[3]) {
                              selectedFlag = '3';
                              _isSelected[3] = false;
                              showAdaptiveActionSheet(
                                context: context,
                                title: const Text('조회기간'),
                                androidBorderRadius: 30,
                                actions: <BottomSheetAction>[
                                  BottomSheetAction(
                                    title: Text('$_selectedDate1'),
                                    onPressed: (context) {
                                      Future<DateTime?> selectedDate =
                                          showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2018),
                                        lastDate: DateTime(2030),
                                      );
                                      selectedDate.then((DateTime) {
                                        setState(() {
                                          _selectedDate1 =
                                              '${DateTime?.year}-${DateTime?.month}-${DateTime?.day}';
                                        });
                                      });
                                    },
                                  ),
                                  BottomSheetAction(
                                    title: Text('$_selectedDate2'),
                                    onPressed: (context) {
                                      Future<DateTime?> selectedDate =
                                          showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2018),
                                        lastDate: DateTime(2030),
                                      );
                                      selectedDate.then((DateTime) {
                                        setState(() {
                                          if (_selectedDate1 == '시작일' ||
                                              _selectedDate1.contains("null")) {
                                            Fluttertoast.showToast(
                                                msg: '시작일을 입력해주세요!');
                                            return;
                                          } else {
                                            _selectedDate2 =
                                                '${DateTime?.year}-${DateTime?.month}-${DateTime?.day}';
                                            if (_selectedDate2 == '마지막일' ||
                                                _selectedDate2
                                                    .contains("null")) {
                                              Fluttertoast.showToast(
                                                  msg: '마지막일을 입력해주세요!');
                                              return;
                                            } else {
                                              refresh();
                                              Navigator.pop(context);
                                            }
                                          }
                                        });
                                      });
                                    },
                                  ),
                                ],
                                cancelAction: CancelAction(
                                    title: const Text(
                                        '취소')), // onPressed parameter is optional by default will dismiss the ActionSheet
                              );
                            }
                          });
                        },
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('전체'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('1개월'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('3개월'),
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
                // SizedBox(
                //   height: 5,
                // ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextButton(
                //       style: TextButton.styleFrom(
                //         textStyle: const TextStyle(fontSize: 16),
                //       ),
                //       onPressed: () {},
                //       child: const Text('검색조건1'),
                //     ),
                //     TextButton(
                //       style: TextButton.styleFrom(
                //         textStyle: const TextStyle(fontSize: 16),
                //       ),
                //       onPressed: () {},
                //       child: const Text(' ~ '),
                //     ),
                //     TextButton(
                //       style: TextButton.styleFrom(
                //         textStyle: const TextStyle(fontSize: 16),
                //       ),
                //       onPressed: () {},
                //       child: const Text('검색조건2'),
                //     ),
                //   ],
                // ),
              ],
            ),
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         textStyle: const TextStyle(fontSize: 18),
            //       ),
            //       onPressed: () {},
            //       child: const Text('검색조건1'),
            //     ),
            //     SizedBox(width: 10),
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         textStyle: const TextStyle(fontSize: 18),
            //       ),
            //       onPressed: () {},
            //       child: const Text('검색조건2'),
            //     ),
            //   ],
            // ),
          ),
          Expanded(
            child: boardList.isEmpty
                ? const Center(child: CircularProgressIndicator())
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
