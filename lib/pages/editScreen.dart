import 'dart:convert';
import 'package:bangtong/pages/first.dart';
import 'package:bangtong/pages/main_screen.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../api/api.dart';
import '../login/loginScreen.dart';
import '../model/orderboard.dart';

class EditScreen extends StatefulWidget {
  final OrderData postData;
  const EditScreen(this.postData, {Key? key}) : super(key: key);

  @override
  _EditScreen createState() => _EditScreen();
}

class _EditScreen extends State<EditScreen> {
  late TextEditingController _titleTextEditingController;
  late TextEditingController _priceTextEditingController;
  late TextEditingController _contentTextEditingController;
  late TextEditingController _startTextEditingController;
  late TextEditingController _endTextEditingController;
  late TextEditingController _startDetailTextEditingController;
  late TextEditingController _endDetailTextEditingController;
  late TextEditingController _gradeTextEditingController;

  DateTime? tempPickedDate;

  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _pickerImgList = [];

  String _startArea = '';
  String _endArea = '';
  String _cost = '';
  String _payMethod = '';
  String _carKind = '';
  String _product = '';
  String _grade = '';
  String _startDateTime = '';
  String _endDateTime = '';
  String _end1 = '';
  String _startMethod = '';
  String _bottom = '';

  String postCode = '-';
  String address = '-';
  String latitude = '-';
  String longitude = '-';
  String kakaoLatitude = '-';
  String kakaoLongitude = '-';

  String strText = '';

  int _methodValue = 0;
  int _carKindValue = 0;
  int _productValue = 0;
  int _bichulValue = 0;
  int _highmethodValue = 0;
  int _bottomKindValue = 0;

  DateTime _dateTime = DateTime.now();
  String _selectedDate1 = '';
  String _selectedTime1 = '';
  String _selectedDate2 = '';
  String _selectedTime2 = '';

  TimeOfDay _time =
      TimeOfDay.now().replacing(hour: DateTime.now().hour, minute: 00);

  // 지불방식
  List<String> dropdownList1 = ['후불', '별도합의', '선불'];
  String selectedDropdown1 = '후불';

  // 차종
  List<String> dropdownList2 = ['방통차', '집게차', '반방통차', '카고'];
  String selectedDropdown2 = '방통차';

  // 품목
  List<String> dropdownList3 = ['고철', '비철'];
  String selectedDropdown3 = '고철';

  // 비철
  List<String> dropdownList4 = ['스텐', '알루미늄', '동(구리)', '피선', '작업철', '기타'];
  String selectedDropdown4 = '스텐';

  // 하차
  List<String> dropdownList5 = ['일반(입석)', '자유제'];
  String selectedDropdown5 = '일반(입석)';

  // 상차방법
  List<String> dropdownList6 = ['포크레인', '집게차', '지게차', '호이스트'];
  String selectedDropdown6 = '포크레인';

  // 바닥
  List<String> dropdownList7 = ['가능', '불가능'];
  String selectedDropdown7 = '가능';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startArea = widget.postData.startArea;
    _endArea = widget.postData.endArea;
    _cost = widget.postData.cost;

    selectedDropdown1 = widget.postData.payMethod;
    selectedDropdown2 = widget.postData.carKind;
    selectedDropdown3 = widget.postData.product;

    selectedDropdown6 = widget.postData.startMethod;
    selectedDropdown7 = widget.postData.bottom;
    _startTextEditingController = TextEditingController();
    _startTextEditingController.text = _startArea;

    _endTextEditingController = TextEditingController();
    _endTextEditingController.text = _endArea;

    _startDetailTextEditingController = TextEditingController();
    _endDetailTextEditingController = TextEditingController();

    _priceTextEditingController = TextEditingController();
    _priceTextEditingController.text = _cost;

    _gradeTextEditingController = TextEditingController();

    if (widget.postData.product == '고철') {
      _grade = widget.postData.grade;
      _gradeTextEditingController.text = _grade;
    } else if (widget.postData.product == '비철') {
      selectedDropdown4 = widget.postData.grade;
    }

    List<String> list1 = DateTimeSplit(widget.postData.startDateTime);
    _selectedDate1 = list1[0];
    _selectedTime1 = list1[1].substring(0, 5);

    List<String> list2 = DateTimeSplit(widget.postData.endDateTime);
    _selectedDate2 = list2[0];
    _selectedTime2 = list2[1].substring(0, 5);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _startTextEditingController.dispose();
    _endTextEditingController.dispose();
    _gradeTextEditingController.dispose();
    _titleTextEditingController.dispose();
    _priceTextEditingController.dispose();
    _contentTextEditingController.dispose();

    super.dispose();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
          onPressed: (() => Navigator.pop(context))),
      backgroundColor: Colors.green,
      elevation: 1,
      title: const Text(
        '배차 등록 수정',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Text("수정"),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: Text("삭제"),
            ),
          ];
        }, onSelected: (value) {
          if (value == 0) {
            print("배차 수정");
            _editOrder();
          } else if (value == 1) {
            deleteDalog();
            print("배차 삭제");
          }
        }),
      ],
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  _editOrder() async {
    String _orderIndex = '';
    _orderIndex = widget.postData.orderIndex;

    String _startArea = '';
    _startArea = _startTextEditingController.text +
        _startDetailTextEditingController.text;
    String _endArea = '';
    _endArea =
        _endTextEditingController.text + _endDetailTextEditingController.text;
    String _cost = '';
    _cost = _priceTextEditingController.text;

    String _payMethod = '';
    _payMethod = selectedDropdown1;

    String _carKind = '';
    _carKind = selectedDropdown2;

    String _product = '';
    _product = selectedDropdown3;

    String _grade = '';
    if (_product == '고철') {
      _grade = _gradeTextEditingController.text;
    } else if (_product == '비철') {
      _grade = selectedDropdown4;
    }

    String _startDateTime = '';

    if (_selectedDate1 == '' ||
        _selectedTime1 == '' ||
        _selectedDate1 == null ||
        _selectedTime1 == null) {
      Fluttertoast.showToast(msg: '상차일시를 입력해주세요!');
      return;
    } else {
      _startDateTime = _selectedDate1 + ' ' + _selectedTime1;
    }

    String _endDateTime = '';

    if (_selectedDate2 == '' ||
        _selectedTime2 == '' ||
        _selectedDate2 == null ||
        _selectedTime2 == null) {
      Fluttertoast.showToast(msg: '하차일시를 입력해주세요!');
      return;
    } else {
      _endDateTime = _selectedDate2 + ' ' + _selectedTime2;
    }

    String _end1 = ''; // 질문 사항?

    String _startMethod = '';
    _startMethod = selectedDropdown6;

    String _bottom = '';
    _bottom = selectedDropdown7;

    String _orderTel = LoginScreen.allTel;
    String _companyName = LoginScreen.allComName;

    OrderData editOrder = OrderData(
        LoginScreen.allID,
        _orderIndex,
        _startArea,
        _endArea,
        _cost,
        _payMethod,
        _carKind,
        _product,
        _grade,
        _startDateTime,
        _endDateTime,
        _end1,
        _bottom,
        _startMethod,
        '', //steelCOde
        'N', //orderYN
        'N', //confirmYN
        _orderTel,
        _companyName,
        '' //carNo
        );
    try {
      var res =
          await http.post(Uri.parse(API.updateOrder), body: editOrder.toJson());

      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: '오더 수정 성공');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          ).then((value) => setState(() {}));
        } else {
          Fluttertoast.showToast(msg: '오더 수정 실패, 확인 후 다시 시도해주세요.');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _deleteOrder() async {
    String _orderIndex = '';
    _orderIndex = widget.postData.orderIndex;

    try {
      var res = await http
          .post(Uri.parse(API.deleteOrder), body: {'orderIndex': _orderIndex});

      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: '오더 삭제 성공');

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          ).then((value) => setState(() {}));
        } else {
          Fluttertoast.showToast(msg: '오더 삭제 실패, 확인 후 다시 시도해주세요.');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget _bodyWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 5),
                        child: AddressText(),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                          child: TextField(
                              controller: _startDetailTextEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '상세 주소를 입력하세요.',
                              ))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 5),
                        child: AddressText2(),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                          child: TextField(
                              controller: _endDetailTextEditingController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '상세 주소를 입력하세요.',
                              ))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.green,
                    ),
                  ),
                  child: TextFormField(
                      validator: (val) => val == "" ? "차주운임을 입력하세요!" : null,
                      controller: _priceTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '￦ 차주운임',
                        // border: OutlineInputBorder(),
                        labelText: '차주운임',
                        contentPadding: EdgeInsets.only(left: 10, top: 2.0),
                      ))),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 6, 12, 5),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 10, 0, 2),
                            child: Text(
                              '지불방식',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 52,
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(5, 10, 0, 2),
                            child: Text(
                              '차종',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(5, 10, 0, 2),
                            child: Text(
                              '품목',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                value: selectedDropdown1,
                                items: dropdownList1.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: Text('$item'),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    selectedDropdown1 = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                value: selectedDropdown2,
                                items: dropdownList2.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: Text('$item'),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    selectedDropdown2 = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                value: selectedDropdown3,
                                items: dropdownList3.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: Text('$item'),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    selectedDropdown3 = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 6, 12, 5),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 2),
                        child: Text(
                          '등급',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 100,
                              child: TextFormField(
                                  validator: (val) =>
                                      val == "" ? "등급을 입력하세요!" : null,
                                  enabled: selectedDropdown3 == '고철',
                                  controller: _gradeTextEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: '등급',
                                    // border: OutlineInputBorder(),
                                    labelText: '등급',
                                    contentPadding: EdgeInsets.only(
                                        left: 5, top: 2.0, right: 2.0),
                                  )),
                            ),
                            SizedBox(
                              width: 45,
                            ),
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                value: selectedDropdown4,
                                items: dropdownList4.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: Text('$item'),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: selectedDropdown3 == '비철'
                                    ? (dynamic value) {
                                        setState(() {
                                          selectedDropdown4 = value;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 5, 10, 2),
                            child: Text(
                              '상차일시',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 2, 5, 2),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                ),
                                child: Text('상차날짜'),
                                onPressed: () {
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
                              Text('$_selectedDate1'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 2, 5, 2),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                ),
                                child: Text('상차시간'),
                                onPressed: () {
                                  Navigator.of(context).push(showPicker(
                                      value: _time,
                                      onChange: (TimeOfDay time) {
                                        setState(() {
                                          _time = time;
                                          _selectedTime1 =
                                              _time.hour.toString() +
                                                  ':' +
                                                  _time.minute.toString();
                                        });
                                        print(_time);
                                      },
                                      onChangeDateTime: (DateTime dateTime) {},
                                      is24HrFormat: false,
                                      iosStylePicker: false,
                                      disableHour: false,
                                      minuteInterval: MinuteInterval.FIFTEEN,
                                      sunAsset:
                                          Image.asset("assets/images/sun.png"),
                                      moonAsset:
                                          Image.asset("assets/images/moon.png"),
                                      displayHeader: true));
                                  // Future<TimeOfDay?> selectedTime =
                                  //     showTimePicker(
                                  //         context: context,
                                  //         initialEntryMode:
                                  //             TimePickerEntryMode.input,
                                  //         initialTime: TimeOfDay.now());
                                  // selectedTime.then((timeOfDay) {
                                  //   setState(() {
                                  //     _selectedTime1 =
                                  //         '${timeOfDay?.hour}:${timeOfDay?.minute}';
                                  //   });
                                  // });
                                },
                              ),
                              Text('$_selectedTime1'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 5, 10, 2),
                            child: Text(
                              '하차일시',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 2, 5, 2),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                ),
                                child: Text('하차날짜'),
                                onPressed: () {
                                  Future<DateTime?> selectedDate =
                                      showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2018),
                                    lastDate: DateTime(2030),
                                  );
                                  selectedDate.then((DateTime) {
                                    setState(() {
                                      _selectedDate2 =
                                          '${DateTime?.year}-${DateTime?.month}-${DateTime?.day}';
                                    });
                                  });
                                },
                              ),
                              Text('$_selectedDate2'),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                        //   child: DropdownButton(
                        //     value: selectedDropdown5,
                        //     items: dropdownList5.map((String item) {
                        //       return DropdownMenuItem<String>(
                        //         child: Text('$item'),
                        //         value: item,
                        //       );
                        //     }).toList(),
                        //     onChanged: (dynamic value) {
                        //       setState(() {
                        //         selectedDropdown5 = value;
                        //       });
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 2, 5, 2),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                ),
                                child: Text('하차시간'),
                                onPressed: () {
                                  Navigator.of(context).push(showPicker(
                                      value: _time,
                                      onChange: (TimeOfDay time) {
                                        setState(() {
                                          _time = time;
                                          _selectedTime2 =
                                              _time.hour.toString() +
                                                  ':' +
                                                  _time.minute.toString();
                                        });
                                        print(_time);
                                      },
                                      onChangeDateTime: (DateTime dateTime) {},
                                      is24HrFormat: false,
                                      iosStylePicker: false,
                                      disableHour: false,
                                      minuteInterval: MinuteInterval.FIFTEEN,
                                      sunAsset:
                                          Image.asset("assets/images/sun.png"),
                                      moonAsset:
                                          Image.asset("assets/images/moon.png"),
                                      displayHeader: true));
                                  // Future<TimeOfDay?> selectedTime =
                                  //     showTimePicker(
                                  //         context: context,
                                  //         initialEntryMode:
                                  //             TimePickerEntryMode.input,
                                  //         initialTime: TimeOfDay.now());
                                  // selectedTime.then((timeOfDay) {
                                  //   setState(() {
                                  //     _selectedTime2 =
                                  //         '${timeOfDay?.hour}:${timeOfDay?.minute}';
                                  //   });
                                  // });
                                },
                              ),
                              Text('$_selectedTime2'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 5),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.green,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 10, 0, 2),
                            child: Text(
                              '상차방법',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 95,
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(5, 10, 0, 2),
                            child: Text(
                              '바닥쓸기',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                value: selectedDropdown6,
                                items: dropdownList6.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: Text('$item'),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    selectedDropdown6 = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                value: selectedDropdown7,
                                items: dropdownList7.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: Text('$item'),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (dynamic value) {
                                  setState(() {
                                    selectedDropdown7 = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }

  Widget AddressText() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(_startTextEditingController); // 카카오 주소 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상차지', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              isDense: false,
            ),
            controller: _startTextEditingController,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget AddressText2() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(_endTextEditingController); // 카카오 주소 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('하차지', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              isDense: false,
            ),
            controller: _endTextEditingController,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  _addressAPI(TextEditingController result) async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    result.text = '${model.address!} ${model.buildingName!}';
    // '${model.zonecode!} ${model.address!} ${model.buildingName!}';
  }

  List<String> DateTimeSplit(String startDateTime) {
    List<String> list = [];

    list = startDateTime.split(' ');

    return list;
  }

  Future<bool> deleteDalog() async {
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
                new Text("오더 삭제"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('오더를 삭제하시겠습니까?'),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  _deleteOrder();
                  Fluttertoast.showToast(msg: '오더가 삭제 되었습니다.');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
              ),
              new TextButton(
                child: new Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
// Widget DateText(int flag) {
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.mediumImpact();
//         _selectDataCalendar_Expecteddate_visit(context);
//       },
//       child: AbsorbPointer(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
//           child: TextFormField(
//             style: TextStyle(fontSize: 16),
//             decoration: InputDecoration(
//               contentPadding:
//                   new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//               isDense: true,
//               hintText: "상차 날짜",
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: Colors.grey),
//               ),
//               focusedBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: Colors.red),
//               ),
//             ),
//             controller: _DataTimeEditingController,
//           ),
//         ),
//       ),
//     );
//   }

  // void _selectDataCalendar_Expecteddate_visit(BuildContext context) {
  //   showCupertinoDialog(
  //       context: context,
  //       builder: (context) {
  //         return SafeArea(
  //             child: Center(
  //           child: Container(
  //             width: MediaQuery.of(context).size.width / 1.1,
  //             height: 550,
  //             child: SfDateRangePicker(
  //               monthViewSettings: DateRangePickerMonthViewSettings(
  //                 dayFormat: 'EEE',
  //               ),
  //               monthFormat: 'MMM',
  //               showNavigationArrow: true,
  //               headerStyle: DateRangePickerHeaderStyle(
  //                 textAlign: TextAlign.center,
  //                 textStyle: TextStyle(fontSize: 25, color: Colors.blueAccent),
  //               ),
  //               headerHeight: 80,
  //               view: DateRangePickerView.month,
  //               allowViewNavigation: false,
  //               backgroundColor: ThemeData.light().scaffoldBackgroundColor,
  //               initialSelectedDate: DateTime.now(),
  //               minDate: DateTime.now(),
  //               // 아래코드는 tempPickedDate를 전역으로 받아 시작일을 선택한 날자로 시작할 수 있음
  //               //minDate: tempPickedDate,
  //               maxDate: DateTime.now().add(new Duration(days: 365)),
  //               // 아래 코드는 선택시작일로부터 2주까지밖에 날자 선택이 안됌
  //               //maxDate: tempPickedDate!.add(new Duration(days: 14)),
  //               selectionMode: DateRangePickerSelectionMode.single,
  //               confirmText: '완료',
  //               cancelText: '취소',
  //               onSubmit: (args) => {
  //                 setState(() {
  //                   _EstimatedEditingController.clear();
  //                   //tempPickedDate = args as DateTime?;
  //                   _DataTimeEditingController.text = args.toString();
  //                   convertDateTimeDisplay(
  //                       _DataTimeEditingController.text, '상차시간');
  //                   Navigator.of(context).pop();
  //                 }),
  //               },
  //               onCancel: () => Navigator.of(context).pop(),
  //               showActionButtons: true,
  //             ),
  //           ),
  //         ));
  //       });
  // }

  // String convertDateTimeDisplay(String date, String text) {
  //   final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  //   final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  //   final DateTime displayDate = displayFormater.parse(date);
  //   if (text == '상차날짜') {
  //     _EstimatedEditingController.clear();
  //     return _DataTimeEditingController.text =
  //         serverFormater.format(displayDate);
  //   } else
  //     return _EstimatedEditingController.text =
  //         serverFormater.format(displayDate);
  // }

  // Widget hourMinute12H() {
  //   return new TimePickerSpinner(
  //     is24HourMode: false,
  //     onTimeChange: (time) {
  //       setState(() {
  //         _dateTime = time;
  //       });
  //     },
  //   );
  // }

  // Widget hourMinuteSecond() {
  //   return new TimePickerSpinner(
  //     isShowSeconds: true,
  //     onTimeChange: (time) {
  //       setState(() {
  //         _dateTime = time;
  //       });
  //     },
  //   );
  // }

  // Widget hourMinute15Interval() {
  //   return new TimePickerSpinner(
  //     spacing: 40,
  //     minutesInterval: 15,
  //     onTimeChange: (time) {
  //       setState(() {
  //         _dateTime = time;
  //         _StartTimeEditingController.text += ' ' + _dateTime.toString();
  //       });
  //     },
  //   );
  // }

  // Widget hourMinute12HCustomStyle() {
  //   return new TimePickerSpinner(
  //     is24HourMode: false,
  //     normalTextStyle: TextStyle(fontSize: 24, color: Colors.deepOrange),
  //     highlightedTextStyle: TextStyle(fontSize: 24, color: Colors.yellow),
  //     spacing: 50,
  //     itemHeight: 80,
  //     isForce2Digits: true,
  //     minutesInterval: 15,
  //     onTimeChange: (time) {
  //       setState(() {
  //         _dateTime = time;
  //       });
  //     },
  //   );
  // }
}
