import 'dart:convert';
import 'dart:io';

import 'package:bangtong/login/login.dart';
import 'package:bangtong/model/articles.dart';
import 'package:bangtong/model/orderboard.dart';
import 'package:bangtong/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:app/provider/service_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../api/api.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddAppState createState() => _AddAppState();
}

class _AddAppState extends State<AddScreen> {
  // late ServiceProvider _serviceProvider;
  late TextEditingController _titleTextEditingController;
  late TextEditingController _priceTextEditingController;
  late TextEditingController _contentTextEditingController;
  late TextEditingController _startTextEditingController;
  late TextEditingController _endTextEditingController;
  late TextEditingController _startDetailTextEditingController;
  late TextEditingController _endDetailTextEditingController;
  late TextEditingController _gradeTextEditingController;

  late TextEditingController _DataTimeEditingController;
  late TextEditingController _EstimatedEditingController;

  late TextEditingController _StartTimeEditingController;

  DateTime? tempPickedDate;

  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _pickerImgList = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startTextEditingController = TextEditingController();
    _endTextEditingController = TextEditingController();
    _gradeTextEditingController = TextEditingController();
    _titleTextEditingController = TextEditingController();
    _priceTextEditingController = TextEditingController();
    _contentTextEditingController = TextEditingController();

    _startDetailTextEditingController = TextEditingController();
    _endDetailTextEditingController = TextEditingController();

    _DataTimeEditingController = TextEditingController();
    _EstimatedEditingController = TextEditingController();

    _StartTimeEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // _serviceProvider = Provider.of<ServiceProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _startTextEditingController.dispose();
    _startDetailTextEditingController.dispose();
    _endTextEditingController.dispose();
    _endDetailTextEditingController.dispose();

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
        '배차 등록',
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        Container(
            height: 15,
            child: IconButton(
              icon: new Icon(Icons.add),
              tooltip: '등록',
              onPressed: () {
                _addOrder();
              },
            )),
      ],
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  _addOrder() async {
    String _orderIndex = '';
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
    String _orderTel = LoginPage_test.allTel;
    String _companyName = LoginPage_test.allComName;

    OrderData addOrder = OrderData(
        LoginPage_test.allID,
        _orderIndex = DateTime.now().toString(),
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
          await http.post(Uri.parse(API.addOrder), body: addOrder.toJson());

      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: '오더 등록 성공');
          setState(() {
            _startTextEditingController.clear();
            _startDetailTextEditingController.clear();
            _endTextEditingController.clear();
            _endDetailTextEditingController.clear();
            _gradeTextEditingController.clear();
            _titleTextEditingController.clear();
            _priceTextEditingController.clear();
            _contentTextEditingController.clear();

            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: '오더 등록 실패, 확인 후 다시 시도해주세요.');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // 중고물품 데이터 등록
  // _addArticle() async {
  //   if (_pickerImgList.length <= 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("물품 사진을 1장 이상 등록해주세요."),
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         duration: Duration(
  //           milliseconds: 2000,
  //         ),
  //         margin: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).size.height - 100,
  //             right: 10,
  //             left: 10),
  //       ),
  //     );

  //     return;
  //   }
  //   if (_pickerImgList.length > 5) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("사진은 최대 5장 까지 등록 가능합니다."),
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         duration: Duration(
  //           milliseconds: 2000,
  //         ),
  //         margin: EdgeInsets.only(
  //             bottom: MediaQuery.of(context).size.height - 100,
  //             right: 10,
  //             left: 10),
  //       ),
  //     );

  //     return;
  //   }

  //   // 업로드할 중고물품 사진 리스트
  //   final List<MultipartFile> uploadImages = [];

  //   // 선택된 카메라 앨범 사진정보 기준으로 MultipartFile 타입 생성
  //   for (int i = 0; i < _pickerImgList.length; i++) {
  //     File imageFile = File(_pickerImgList[i].path);
  //     var stream = _pickerImgList[i].openRead();
  //     var length = await imageFile.length();
  //     var multipartFile = http.MultipartFile("articlesImages", stream, length,
  //         filename: _pickerImgList[i].name,
  //         contentType: MediaType('image', 'jpg'));
  //     uploadImages.add(multipartFile);
  //   }

  //   // 등록될 중고물품 데이터 정보
  //   // Articles article = Articles(
  //   //     photoList: [],
  //   //     profile: _serviceProvider.profile!,
  //   //     profile: _titleTextEditingController,
  //   //     content: _contentTextEditingController.text,
  //   //     town: _serviceProvider.currentTown!,
  //   //     price: _priceTextEditingController.text == ''
  //   //         ? 0
  //   //         : num.parse(_priceTextEditingController.text),
  //   //     likeCnt: 7,
  //   //     readCnt: 0,
  //   //     category: _selectedCategory);

  //   try {
  //     // // 데이터 등록중 표시
  //     // _serviceProvider.dataFetching();
  //     //
  //     // // 새로운 중고물품 데이터 등록
  //     // bool result = await _serviceProvider.addArticle(uploadImages, article);
  //     bool result = false;
  //     if (result) {
  //       Fluttertoast.showToast(
  //           msg: "새로운 배차를 등록하였습니다.",
  //           gravity: ToastGravity.BOTTOM,
  //           backgroundColor: Colors.redAccent,
  //           fontSize: 20,
  //           textColor: Colors.white,
  //           toastLength: Toast.LENGTH_SHORT);

  //       // 데이터 등록 후 AddArticle 닫기
  //       Navigator.pop<bool>(context, result);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             content: Text("배차 등록 도중 오류가 발생하였습니다."),
  //             duration: Duration(
  //               milliseconds: 1000,
  //             )),
  //       );
  //     }
  //   } catch (ex) {
  //     print("error: $ex");
  //     Fluttertoast.showToast(
  //         msg: ex.toString(),
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.redAccent,
  //         fontSize: 20,
  //         textColor: Colors.white,
  //         toastLength: Toast.LENGTH_LONG);
  //   }
  // }

  // // 카레라 앨범에서 사진 선택
  // Future<void> _pickImg() async {
  //   final List<XFile>? images = await _imagePicker.pickMultiImage();
  //   if (images == null) return;

  //   setState(() {
  //     _pickerImgList = images;
  //   });
  // }

  // // 선택된 사진 미리보기
  // Widget _photoPreviewWidget() {
  //   if (_pickerImgList.length <= 0) return Container();

  //   return GridView.count(
  //       shrinkWrap: true,
  //       padding: EdgeInsets.all(2),
  //       crossAxisCount: 5, // 최대 5개
  //       mainAxisSpacing: 1,
  //       crossAxisSpacing: 5,
  //       children: List.generate(_pickerImgList.length, (index) {
  //         //return Container();
  //         // 대시라인 보더 위젯으로 감싸 선택한 사진을 표시한다.
  //         return DottedBorder(
  //             child: Container(
  //                 child: Container(
  //                   child: Stack(
  //                     children: [
  //                       Image.file(
  //                         File(_pickerImgList[index].path),
  //                         width: 100,
  //                         height: 100,
  //                         fit: BoxFit.cover,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           IconButton(
  //                               padding: EdgeInsets.only(left: 20, bottom: 30),
  //                               onPressed: () {
  //                                 setState(() {
  //                                   _pickerImgList.removeAt(index);
  //                                 });
  //                               },
  //                               icon: SvgPicture.asset(
  //                                 "assets/svg/close-circle.svg",
  //                               )),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 decoration:
  //                     BoxDecoration(borderRadius: BorderRadius.circular(3))),
  //             dashPattern: [5, 3],
  //             borderType: BorderType.RRect,
  //             radius: Radius.circular(3));
  //       }).toList());
  // }

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
                  child: TextField(
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
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                        child: Text(
                          '지불방식',
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
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                value: 0,
                                groupValue: _methodValue,
                                title: Text("후불제",
                                    overflow: TextOverflow.ellipsis),
                                onChanged: (newValue) =>
                                    setState(() => _methodValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: true,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                value: 1,
                                groupValue: _methodValue,
                                title: Text("별도합의"),
                                onChanged: (newValue) =>
                                    setState(() => _methodValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                value: 2,
                                groupValue: _methodValue,
                                title: Text("선불제"),
                                onChanged: (newValue) =>
                                    setState(() => _methodValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
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
                height: 100,
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
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                        child: Text(
                          '차종',
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
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 0,
                                groupValue: _carKindValue,
                                title: Text("방통차"),
                                onChanged: (newValue) =>
                                    setState(() => _carKindValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: true,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 1,
                                groupValue: _carKindValue,
                                title: Text("집게차"),
                                onChanged: (newValue) =>
                                    setState(() => _carKindValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 2,
                                groupValue: _carKindValue,
                                title: Text("반방통차"),
                                onChanged: (newValue) =>
                                    setState(() => _carKindValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 3,
                                groupValue: _carKindValue,
                                title: Text("카고"),
                                onChanged: (newValue) =>
                                    setState(() => _carKindValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
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
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                        child: Text(
                          '품목',
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
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                value: 0,
                                groupValue: _productValue,
                                title:
                                    Text("고철", overflow: TextOverflow.ellipsis),
                                onChanged: (newValue) =>
                                    setState(() => _productValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: true,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.all(0),
                                dense: true,
                                value: 1,
                                groupValue: _productValue,
                                title: Text("비철"),
                                onChanged: (newValue) =>
                                    setState(() => _productValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: TextField(
                                    enabled: _productValue == 0,
                                    controller: _gradeTextEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: '고철등급',
                                      // border: OutlineInputBorder(),
                                      labelText: '고철등급',
                                      contentPadding: EdgeInsets.only(
                                          left: 5, top: 2.0, right: 2.0),
                                    ))),
                          ],
                        ),
                      ),
                    ),

                    // Align(
                    //   alignment: AlignmentDirectional(-1, 0),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 5.0),
                    //     child:
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       children: [
                    //         Expanded(
                    //           flex: 1,
                    //           child: RadioListTile(
                    //             contentPadding: EdgeInsets.zero,
                    //             dense: true,
                    //             value: 0,
                    //             groupValue: _bichulValue,
                    //             title: Text("스텐", overflow: TextOverflow.ellipsis),
                    //             onChanged: (newValue) =>
                    //                 setState(() => _bichulValue = newValue!),
                    //             activeColor: Colors.lightBlue[900],
                    //             selected: true,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 1,
                    //           child: RadioListTile(
                    //             contentPadding: EdgeInsets.zero,
                    //             dense: true,
                    //             value: 1,
                    //             groupValue: _bichulValue,
                    //             title: Text("알루미늄"),
                    //             onChanged: (newValue) =>
                    //                 setState(() => _bichulValue = newValue!),
                    //             activeColor: Colors.lightBlue[900],
                    //             selected: false,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 1,
                    //           child: RadioListTile(
                    //             contentPadding: EdgeInsets.zero,
                    //             dense: true,
                    //             value: 2,
                    //             groupValue: _bichulValue,
                    //             title: Text("동(구리)"),
                    //             onChanged: (newValue) =>
                    //                 setState(() => _bichulValue = newValue!),
                    //             activeColor: Colors.lightBlue[900],
                    //             selected: false,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 1,
                    //           child: RadioListTile(
                    //             contentPadding: EdgeInsets.zero,
                    //             dense: true,
                    //             value: 3,
                    //             groupValue: _bichulValue,
                    //             title: Text("피선"),
                    //             onChanged: (newValue) =>
                    //                 setState(() => _bichulValue = newValue!),
                    //             activeColor: Colors.lightBlue[900],
                    //             selected: false,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 1,
                    //           child: RadioListTile(
                    //             contentPadding: EdgeInsets.zero,
                    //             dense: true,
                    //             value: 4,
                    //             groupValue: _bichulValue,
                    //             title: Text("작업철"),
                    //             onChanged: (newValue) =>
                    //                 setState(() => _bichulValue = newValue!),
                    //             activeColor: Colors.lightBlue[900],
                    //             selected: false,
                    //           ),
                    //         ),
                    //         Expanded(
                    //           flex: 1,
                    //           child: RadioListTile(
                    //             contentPadding: EdgeInsets.zero,
                    //             dense: true,
                    //             value: 5,
                    //             groupValue: _bichulValue,
                    //             title: Text("기타"),
                    //             onChanged: (newValue) =>
                    //                 setState(() => _bichulValue = newValue!),
                    //             activeColor: Colors.lightBlue[900],
                    //             selected: false,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
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
                                  Future<TimeOfDay?> selectedTime =
                                      showTimePicker(
                                          context: context,
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          initialTime: TimeOfDay.now());
                                  selectedTime.then((timeOfDay) {
                                    setState(() {
                                      _selectedTime1 =
                                          '${timeOfDay?.hour}:${timeOfDay?.minute}';
                                    });
                                  });
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
                            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
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
                                  Future<TimeOfDay?> selectedTime =
                                      showTimePicker(
                                          context: context,
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          initialTime: TimeOfDay.now());
                                  selectedTime.then((timeOfDay) {
                                    setState(() {
                                      _selectedTime2 =
                                          '${timeOfDay?.hour}:${timeOfDay?.minute}';
                                    });
                                  });
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
                height: 100,
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
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                        child: Text(
                          '상차방법',
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
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 0,
                                groupValue: _highmethodValue,
                                title: Text('포크레인'),
                                onChanged: (newValue) => setState(
                                    () => _highmethodValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: true,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 1,
                                groupValue: _highmethodValue,
                                title: Text('집게차'),
                                onChanged: (newValue) => setState(
                                    () => _highmethodValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 2,
                                groupValue: _highmethodValue,
                                title: Text('지게차'),
                                onChanged: (newValue) => setState(
                                    () => _highmethodValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 3,
                                groupValue: _highmethodValue,
                                title: Text('호이스트'),
                                onChanged: (newValue) => setState(
                                    () => _highmethodValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
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
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                        child: Text(
                          '바닥',
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
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 0,
                                groupValue: _bottomKindValue,
                                title:
                                    Text("가능", overflow: TextOverflow.ellipsis),
                                onChanged: (newValue) => setState(
                                    () => _bottomKindValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: true,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RadioListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                value: 1,
                                groupValue: _bottomKindValue,
                                title: Text("불가능"),
                                onChanged: (newValue) => setState(
                                    () => _bottomKindValue = newValue!),
                                activeColor: Colors.lightBlue[900],
                                selected: false,
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

// Widget DateText(int flag) {
  //   return GestureDetector(
  //     onTap: () {
  //       HapticFeedback.mediumImpact();
  //       _selectDataCalendar_Expecteddate_visit(context);
  //     },
  //     child: AbsorbPointer(
  //       child: Container(
  //         width: MediaQuery.of(context).size.width,
  //         padding: const EdgeInsets.only(right: 10, left: 10, top: 10),
  //         child: TextFormField(
  //           style: TextStyle(fontSize: 16),
  //           decoration: InputDecoration(
  //             contentPadding:
  //                 new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
  //             isDense: true,
  //             hintText: "상차 날짜",
  //             enabledBorder: UnderlineInputBorder(
  //               borderSide: BorderSide(color: Colors.grey),
  //             ),
  //             focusedBorder: UnderlineInputBorder(
  //               borderSide: BorderSide(color: Colors.red),
  //             ),
  //           ),
  //           controller: _DataTimeEditingController,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
}
