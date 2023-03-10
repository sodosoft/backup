import 'dart:io';

import 'package:bangtong/model/articles.dart';
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

  late TextEditingController _DataTimeEditingController;
  late TextEditingController _EstimatedEditingController;

  late TextEditingController _StartTimeEditingController;

  DateTime? tempPickedDate;

  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _pickerImgList = [];

  String startArea = '';
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

    startArea= widget.postData.startArea;

    _startTextEditingController = TextEditingController();
    _startTextEditingController.text = startArea;
    _endTextEditingController = TextEditingController();
    _gradeTextEditingController = TextEditingController();
    _titleTextEditingController = TextEditingController();
    _priceTextEditingController = TextEditingController();
    _contentTextEditingController = TextEditingController();

    _startDetailTextEditingController = TextEditingController();
    _endDetailTextEditingController = TextEditingController();

    _DataTimeEditingController = TextEditingController();
    _EstimatedEditingController = TextEditingController();

    _StartTimeEditingController =  TextEditingController();
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
        '?????? ?????? ??????',
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        PopupMenuButton(
          // add icon, by default "3 dot" icon
          // icon: Icon(Icons.book)
            itemBuilder: (context){
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("??????"),
                ),

                PopupMenuItem<int>(
                  value: 1,
                  child: Text("??????"),
                ),
              ];
            },
            onSelected:(value){
              if(value == 0){
                print("?????? ??????");
                // ?????? ?????? ????????????
                // ????????? ?????? ???
                //confirmYN Y
                //???????????? ?????? ?????? ???????????????
              }else if(value == 1){
                print("?????? ??????");
              }
            }
        ),
      ],
    );
  }

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // ???????????? ????????? ??????
  _addArticle() async {
    if (_pickerImgList.length <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("?????? ????????? 1??? ?????? ??????????????????."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 10,
              left: 10),
        ),
      );

      return;
    }
    if (_pickerImgList.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("????????? ?????? 5??? ?????? ?????? ???????????????."),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: Duration(
            milliseconds: 2000,
          ),
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 10,
              left: 10),
        ),
      );

      return;
    }

    // ???????????? ???????????? ?????? ?????????
    final List<MultipartFile> uploadImages = [];

    // ????????? ????????? ?????? ???????????? ???????????? MultipartFile ?????? ??????
    for (int i = 0; i < _pickerImgList.length; i++) {
      File imageFile = File(_pickerImgList[i].path);
      var stream = _pickerImgList[i].openRead();
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile("articlesImages", stream, length,
          filename: _pickerImgList[i].name,
          contentType: MediaType('image', 'jpg'));
      uploadImages.add(multipartFile);
    }

    // ????????? ???????????? ????????? ??????
    // Articles article = Articles(
    //     photoList: [],
    //     profile: _serviceProvider.profile!,
    //     profile: _titleTextEditingController,
    //     content: _contentTextEditingController.text,
    //     town: _serviceProvider.currentTown!,
    //     price: _priceTextEditingController.text == ''
    //         ? 0
    //         : num.parse(_priceTextEditingController.text),
    //     likeCnt: 7,
    //     readCnt: 0,
    //     category: _selectedCategory);

    try {
      // // ????????? ????????? ??????
      // _serviceProvider.dataFetching();
      //
      // // ????????? ???????????? ????????? ??????
      // bool result = await _serviceProvider.addArticle(uploadImages, article);
      bool result = false;
      if (result) {
        Fluttertoast.showToast(
            msg: "????????? ????????? ?????????????????????.",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.redAccent,
            fontSize: 20,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);

        // ????????? ?????? ??? AddArticle ??????
        Navigator.pop<bool>(context, result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("?????? ?????? ?????? ????????? ?????????????????????."),
              duration: Duration(
                milliseconds: 1000,
              )),
        );
      }
    } catch (ex) {
      print("error: $ex");
      Fluttertoast.showToast(
          msg: ex.toString(),
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.redAccent,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  // ????????? ???????????? ?????? ??????
  Future<void> _pickImg() async {
    final List<XFile>? images = await _imagePicker.pickMultiImage();
    if (images == null) return;

    setState(() {
      _pickerImgList = images;
    });
  }

  // ????????? ?????? ????????????
  Widget _photoPreviewWidget() {
    if (_pickerImgList.length <= 0) return Container();

    return GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.all(2),
        crossAxisCount: 5, // ?????? 5???
        mainAxisSpacing: 1,
        crossAxisSpacing: 5,
        children: List.generate(_pickerImgList.length, (index) {
          //return Container();
          // ???????????? ?????? ???????????? ?????? ????????? ????????? ????????????.
          return DottedBorder(
              child: Container(
                  child: Container(
                    child: Stack(
                      children: [
                        Image.file(
                          File(_pickerImgList[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                padding: EdgeInsets.only(left: 20, bottom: 30),
                                onPressed: () {
                                  setState(() {
                                    _pickerImgList.removeAt(index);
                                  });
                                },
                                icon: SvgPicture.asset(
                                  "assets/svg/close-circle.svg",
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3))),
              dashPattern: [5, 3],
              borderType: BorderType.RRect,
              radius: Radius.circular(3));
        }).toList());
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
                                padding: EdgeInsetsDirectional.fromSTEB(4,4,4,4),
                                child: TextField(
                                    controller: _startDetailTextEditingController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '?????? ????????? ???????????????.',
                                    )
                                )
                              ),
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
                                    hintText: '?????? ????????? ???????????????.',
                                  )
                              )
                          ),
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
                          hintText: '??? ????????????',
                          // border: OutlineInputBorder(),
                          labelText: '????????????',
                          contentPadding: EdgeInsets.only(left: 10,top: 2.0),
                        )
                    )
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
                              '????????????',
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
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    dense: true,
                                    value: 0,
                                    groupValue: _methodValue,
                                    title: Text("?????????", overflow: TextOverflow.ellipsis),
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
                                    title: Text("????????????"),
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
                                    title: Text("?????????"),
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
                              '??????',
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
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: 0,
                                    groupValue: _carKindValue,
                                    title: Text("?????????"),
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
                                    title: Text("?????????"),
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
                                    title: Text("????????????"),
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
                                    title: Text("??????"),
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
                              '??????',
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
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    dense: true,
                                    value: 0,
                                    groupValue: _productValue,
                                    title: Text("??????", overflow: TextOverflow.ellipsis),
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
                                    title: Text("??????"),
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
                                        hintText: '????????????',
                                        // border: OutlineInputBorder(),
                                        labelText: '????????????',
                                        contentPadding: EdgeInsets.only(left: 5,top: 2.0,right: 2.0),
                                      )
                                  )
                                ),
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
                        //             title: Text("??????", overflow: TextOverflow.ellipsis),
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
                        //             title: Text("????????????"),
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
                        //             title: Text("???(??????)"),
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
                        //             title: Text("??????"),
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
                        //             title: Text("?????????"),
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
                        //             title: Text("??????"),
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
                              '????????????',
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
                            children:
                            <Widget>[
                              ElevatedButton(
                                style:ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                ),
                                child: Text('????????????'),
                                onPressed: () {
                                  Future<DateTime?> selectedDate = showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(), firstDate: DateTime(2018),lastDate: DateTime(2030),
                                  );
                                  selectedDate.then((DateTime){
                                    setState(() {
                                      _selectedDate1 = '${DateTime?.year}-${DateTime?.month}-${DateTime?.day}';
                                    });
                                  });
                                },
                              ),
                              Text(
                                  '$_selectedDate1'
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 2, 5, 2),
                          child: Column(
                              children:
                              <Widget>[
                                ElevatedButton(
                                  style:ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    onPrimary: Colors.white,
                                  ),
                                  child: Text('????????????'),
                                  onPressed: () {
                                    Future<TimeOfDay?> selectedTime = showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    );
                                    selectedTime.then((timeOfDay){
                                      setState(() {
                                        _selectedTime1 = '${timeOfDay?.hour}:${timeOfDay?.minute}';
                                      });
                                    });
                                  },
                                ),
                                Text(
                                  '$_selectedTime1'
                                ),
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
                                  '????????????',
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
                                children:
                                <Widget>[
                                  ElevatedButton(
                                    style:ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      onPrimary: Colors.white,
                                    ),
                                    child: Text('????????????'),
                                    onPressed: () {
                                      Future<DateTime?> selectedDate = showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(), firstDate: DateTime(2018),lastDate: DateTime(2030),
                                      );
                                      selectedDate.then((DateTime){
                                        setState(() {
                                          _selectedDate2 = '${DateTime?.year}-${DateTime?.month}-${DateTime?.day}';
                                        });
                                      });
                                    },
                                  ),
                                  Text(
                                      '$_selectedDate2'
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(5, 2, 5, 2),
                              child: Column(
                                children:
                                <Widget>[
                                  ElevatedButton(
                                    style:ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      onPrimary: Colors.white,
                                    ),
                                    child: Text('????????????'),
                                    onPressed: () {
                                      Future<TimeOfDay?> selectedTime = showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now()
                                      );
                                      selectedTime.then((timeOfDay){
                                        setState(() {
                                          _selectedTime2 = '${timeOfDay?.hour}:${timeOfDay?.minute}';
                                        });
                                      });
                                    },
                                  ),
                                  Text(
                                      '$_selectedTime2'
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                //   child: Container(
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       border: Border.all(
                //         color: Colors.green,
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       children: [
                //         Align(
                //           alignment: AlignmentDirectional(-1, 0),
                //           child: Padding(
                //             padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 2),
                //             child: Text(
                //               '????????????',
                //               style: TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.normal,
                //                   color: Colors.black),
                //             ),
                //           ),
                //         ),
                //         Align(
                //           alignment: AlignmentDirectional(-1, 0),
                //           child: Padding(
                //             padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 5),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 Expanded(
                //                   flex: 1,
                //                   child: RadioListTile(
                //                     contentPadding: EdgeInsets.all(0),
                //                     dense: true,
                //                     value: 0,
                //                     groupValue: _costValue,
                //                     title: Text("??????", overflow: TextOverflow.ellipsis),
                //                     onChanged: (newValue) =>
                //                         setState(() => _costValue = newValue!),
                //                     activeColor: Colors.lightBlue[900],
                //                     selected: true,
                //                   ),
                //                 ),
                //                 Expanded(
                //                   flex: 1,
                //                   child: RadioListTile(
                //                     contentPadding: EdgeInsets.all(0),
                //                     dense: true,
                //                     value: 1,
                //                     groupValue: _costValue,
                //                     title: Text("?????? ??????"),
                //                     onChanged: (newValue) =>
                //                         setState(() => _costValue = newValue!),
                //                     activeColor: Colors.lightBlue[900],
                //                     selected: false,
                //                   ),
                //                 ),
                //                 Expanded(
                //                   flex: 1,
                //                   child: RadioListTile(
                //                     contentPadding: EdgeInsets.all(0),
                //                     dense: true,
                //                     value: 2,
                //                     groupValue: _costValue,
                //                     title: Text("??????"),
                //                     onChanged: (newValue) =>
                //                         setState(() => _costValue = newValue!),
                //                     activeColor: Colors.lightBlue[900],
                //                     selected: false,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // ?????? ?????? ?????? ????????????
                // DropdownButton(
                //     hint: Text('?????? ??????'),
                //     isExpanded: true,
                //     items: ['??????', '????????????', '???(??????)', '??????', '?????????', '??????']
                //         .map((item) => DropdownMenuItem(
                //               child: Text(item),
                //               value: item,
                //             ))
                //         .toList(),
                //     value: _selectedCategory_grade,
                //     onChanged: (value) {
                //       setState(() {
                //         _selectedCategory_grade = value.toString();
                //       });
                //     }),
                // SizedBox(
                //   height: 5,
                // ),
                // // ?????? ?????? ??????
                // Container(
                //   height: 200,
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //     width: 1,
                //     color: Colors.grey,
                //   )),
                //   constraints: BoxConstraints(maxHeight: 50),
                //   child: Scrollbar(
                //     child: TextField(
                //       controller: _contentTextEditingController,
                //       style: TextStyle(fontSize: 17),
                //       keyboardType: TextInputType.multiline,
                //       maxLength: null,
                //       maxLines: null,
                //       decoration: InputDecoration(
                //           border: InputBorder.none,
                //           filled: true,
                //           fillColor: Colors.transparent,
                //           hintMaxLines: 3,
                //           hintText: '?????? ?????? ??????',
                //           hintStyle: TextStyle(
                //               fontSize: 17, overflow: TextOverflow.clip)),
                //     ),
                //   ),
                // )
          // Consumer<ServiceProvider>(builder: ((context, value, child) {
          //   // ???????????? ????????? ???????????? ?????? ?????? ?????? ??????
          //   if (value.isDataFetching) {
          //     return const Center(
          //         child: CircularProgressIndicator(
          //             color: Color.fromARGB(255, 252, 113, 49)));
          //   } else {
          //     return Container(height: 0, width: 0);
          //   }
          // }))
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
                              '????????????',
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
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: 0,
                                    groupValue: _highmethodValue,
                                    title: Text('????????????'),
                                    onChanged: (newValue) =>
                                        setState(() => _highmethodValue = newValue!),
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
                                    title: Text('?????????'),
                                    onChanged: (newValue) =>
                                        setState(() => _highmethodValue = newValue!),
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
                                    title: Text('?????????'),
                                    onChanged: (newValue) =>
                                        setState(() => _highmethodValue = newValue!),
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
                                    title: Text('????????????'),
                                    onChanged: (newValue) =>
                                        setState(() => _highmethodValue = newValue!),
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
                              '??????',
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
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    value: 0,
                                    groupValue: _bottomKindValue,
                                    title: Text("??????", overflow: TextOverflow.ellipsis),
                                    onChanged: (newValue) =>
                                        setState(() => _bottomKindValue = newValue!),
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
                                    title: Text("?????????"),
                                    onChanged: (newValue) =>
                                        setState(() => _bottomKindValue = newValue!),
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
      ) ,
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

  Widget DateText(int flag) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _selectDataCalendar_Expecteddate_visit(context);
      },
      child: AbsorbPointer(
        child: Container(
        width: MediaQuery.of(context).size.width,
        padding:
          const EdgeInsets.only(right: 10, left: 10, top: 10),
          child: TextFormField(
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(
          vertical: 10.0, horizontal: 10.0),
          isDense: true,
          hintText: "?????? ??????",
          enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            ),
          ),
          controller: _DataTimeEditingController,
          ),
        ),
      ),
    );
  }

  Widget AddressText() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(_startTextEditingController); // ????????? ?????? API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('?????????', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
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
        _addressAPI(_endTextEditingController); // ????????? ?????? API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('?????????', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
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
    KopoModel model = await Navigator.push(context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    result.text =
    '${model.address!} ${model.buildingName!}';
    // '${model.zonecode!} ${model.address!} ${model.buildingName!}';
  }

  void _selectDataCalendar_Expecteddate_visit(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 550,
                  child: SfDateRangePicker(
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat: 'EEE',
                    ),
                    monthFormat: 'MMM',
                    showNavigationArrow: true,
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(fontSize: 25, color: Colors.blueAccent),
                    ),
                    headerHeight: 80,
                    view: DateRangePickerView.month,
                    allowViewNavigation: false,
                    backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                    initialSelectedDate: DateTime.now(),
                    minDate: DateTime.now(),
                    // ??????????????? tempPickedDate??? ???????????? ?????? ???????????? ????????? ????????? ????????? ??? ??????
                    //minDate: tempPickedDate,
                    maxDate: DateTime.now().add(new Duration(days: 365)),
                    // ?????? ????????? ???????????????????????? 2??????????????? ?????? ????????? ??????
                    //maxDate: tempPickedDate!.add(new Duration(days: 14)),
                    selectionMode: DateRangePickerSelectionMode.single,
                    confirmText: '??????',
                    cancelText: '??????',
                    onSubmit: (args) => {
                      setState(() {
                        _EstimatedEditingController.clear();
                        //tempPickedDate = args as DateTime?;
                        _DataTimeEditingController.text = args.toString();
                        convertDateTimeDisplay(
                            _DataTimeEditingController.text, '????????????');
                        Navigator.of(context).pop();
                      }),
                    },
                    onCancel: () => Navigator.of(context).pop(),
                    showActionButtons: true,
                  ),
                ),
              ));
        });
  }

  String convertDateTimeDisplay(String date, String text) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    if (text == '????????????') {
      _EstimatedEditingController.clear();
      return _DataTimeEditingController.text =
          serverFormater.format(displayDate);
    } else
      return _EstimatedEditingController.text =
          serverFormater.format(displayDate);
  }

  Widget hourMinute12H(){
    return new TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinuteSecond(){
    return new TimePickerSpinner(
      isShowSeconds: true,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
  Widget hourMinute15Interval(){
    return new TimePickerSpinner(
      spacing: 40,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
          _StartTimeEditingController.text += ' ' + _dateTime.toString();
        });
      },
    );
  }
  Widget hourMinute12HCustomStyle(){
    return new TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.deepOrange
      ),
      highlightedTextStyle: TextStyle(
          fontSize: 24,
          color: Colors.yellow
      ),
      spacing: 50,
      itemHeight: 80,
      isForce2Digits: true,
      minutesInterval: 15,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}


