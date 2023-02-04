import 'dart:async';

import 'package:bangtong/function/UpdateData.dart';
import 'package:bangtong/pages/driver_first.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:direct_sms/direct_sms.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../function/displaystring.dart';
import '../login/loginScreen.dart';
import '../model/orderboard.dart';
import '../widgets/round-button.dart';

class DetailPageDriver extends StatefulWidget {
  final OrderData postData;
  DetailPageDriver(this.postData, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(postData);
}

class _MyAppState extends State<DetailPageDriver>
    with TickerProviderStateMixin {
  late AnimationController controller;
  final OrderData postData;
  _MyAppState(@required this.postData);

  bool isPlaying = false;
  bool isSending = false;
  bool isConfirm = false;
  bool _isButtonDisabled = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '00:00') {
      offDialog2();
      _isButtonDisabled = false;
      FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  void initState() {
    _isButtonDisabled = false;

    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(minutes: 10));

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
  }

  var directSms = DirectSms();
  List<String> people = [];

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
        height: double.maxFinite,
        child: Column(
          children: [
            Text('상차지: ' +
                postData.startArea.toString() +
                '\n' +
                '하차지: ' +
                postData.endArea.toString() +
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
                "원" +
                '\n' +
                '지불방식: ' +
                postData.payMethod.toString() +
                '\n' +
                '차종: ' +
                postData.carKind.toString() +
                '\n' +
                '품목: ' +
                postData.product.toString() +
                '\n' +
                '등급: ' +
                postData.grade.toString() +
                '\n' +
                '상차방법: ' +
                postData.startMethod.toString() +
                '\n'),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0.0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (LoginScreen.cancelCount > 3) {
                        Fluttertoast.showToast(
                            msg: '취소 제한 횟수 3회를 초과하셨습니다.' +
                                '\n' +
                                '익일 자정 이후 초기화 됩니다.');
                        return;
                      } else {
                        // 화주한테 차번호 SMS 보내기
                        _sendSms(
                          message: '오더 번호: ' +
                              postData.orderIndex +
                              '\n\n' +
                              '차량 번호: ' +
                              LoginScreen.allCarNo +
                              '\n' +
                              '바로 전화 드릴테니 배차 등록 부탁드립니다.',
                          number: postData.orderTel,
                        );
                        // orderYN Y로 업데이트
                        UpdateData.orederYNChange(postData.orderIndex, 'Y');
                        _isButtonDisabled = true;
                      }
                      controller.reverse(
                          from: controller.value == 0 ? 1.0 : controller.value);

                      setState(() {
                        isSending = true;
                        isPlaying = true;
                      });
                      // 화주한테 SMS 보내기
                    },
                    child: RoundButton(
                      icon: Icons.mail,
                      tooltip: Tooltip(message: '문자 보내기'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_isButtonDisabled) {
                        setState(() => isSending = true);

                        // 화주한테 전화 걸기
                        _callNumber(postData.orderTel);

                        offDialog3(postData.orderIndex);

                        if (isConfirm) {
                          Fluttertoast.showToast(
                              msg:
                                  '배차가 완료되었습니다. \n 해당 배차는 배차 내역에 가셔서 확인 가능합니다.');
                          isPlaying = false;
                          isSending = false;
                          _isButtonDisabled = false;
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: '배차가 취소되었습니다. \n 다른 오더를 이용해주시기 바랍니다.');
                          isPlaying = false;
                          isSending = false;
                          _isButtonDisabled = false;

                          Future.delayed(const Duration(milliseconds: 500),
                              () async {
                            final reuslt = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Driver_first())));
                          });
                        }
                      } else {
                        Fluttertoast.showToast(msg: '화주에게 문자 보낸 후 가능합니다.');
                      }
                    },
                    child: RoundButton(
                      icon: Icons.phone,
                      tooltip: Tooltip(message: '전화걸기'),
                    ),
                  ),
                  // CupertinoButton(
                  //   minSize: 20,
                  //   padding: const EdgeInsets.all(0), // remove button padding
                  //   color: CupertinoColors.white.withOpacity(
                  //       0), // use this to make default color to transparent
                  //   child: Container(
                  //     // wrap the text/widget using container
                  //     padding: const EdgeInsets.all(10), // add padding
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: const Color.fromARGB(255, 211, 15, 69),
                  //         width: 1,
                  //       ),
                  //       borderRadius: const BorderRadius.all(
                  //           Radius.circular(10)), // radius as you wish
                  //     ),
                  //     child: Wrap(
                  //       children: const [
                  //         Icon(
                  //           CupertinoIcons.videocam_circle_fill,
                  //           color: CupertinoColors.systemPink,
                  //         ),
                  //         Text(
                  //           " Upload video",
                  //           style: TextStyle(color: CupertinoColors.systemPink),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     // on press action
                  //   },
                  // ),

                  GestureDetector(
                    onTap: () {
                      if (_isButtonDisabled) {
                        setState(() => isSending = true);
                        controller.reset();

                        setState(() {
                          isPlaying = false;
                          isSending = false;
                          _isButtonDisabled = false;
                        });
                        // orderYN N으로 업데이트
                        UpdateData.orederYNChange(postData.orderIndex, 'N');
                        // // 캔슬 횟수 추가(캔슬 횟수 하루에 3번 제한)
                        offDialog(LoginScreen.cancelCount + 1);

                        Future.delayed(const Duration(milliseconds: 500),
                            () async {
                          final reuslt = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Driver_first())));
                        });
                      } else {
                        Fluttertoast.showToast(msg: '화주에게 문자 보낸 후 가능합니다.');
                      }
                    },
                    child: RoundButton(
                      icon: Icons.close,
                      tooltip: Tooltip(message: '취소하기'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    width: 150,
                    height: 70,
                    child: LinearProgressIndicator(
                      color: Colors.red,
                      backgroundColor: Colors.grey.shade300,
                      value: progress,
                      //strokeWidth: 6,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.isDismissed) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: 100,
                            child: CupertinoTimerPicker(
                              initialTimerDuration: controller.duration!,
                              onTimerDurationChanged: (time) {
                                setState(() {
                                  controller.duration = time;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) => Text(
                        countText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   height: 50,
            //   child: ElevatedButton(
            //       child: Text('오더 잡기'),
            //       onPressed: () {
            //         if (LoginScreen.cancelCount > 3) {
            //           Fluttertoast.showToast(
            //               msg: '취소 제한 횟수 3회를 초과하셨습니다.' +
            //                   '\n' +
            //                   '익일 자정 이후 초기화 됩니다.');
            //           return;
            //         } else {
            //           // 화주한테 차번호 SMS 보내기
            //           _sendSms(
            //             message: '오더 번호: ' +
            //                 postData.orderIndex +
            //                 '\n\n' +
            //                 '차량 번호: ' +
            //                 LoginScreen.allCarNo +
            //                 '\n' +
            //                 '바로 전화 드릴테니 배차 등록 부탁드립니다.',
            //             number: postData.orderTel,
            //           );
            //           // orderYN Y로 업데이트
            //           UpdateData.orederYNChange(postData.orderIndex, 'Y');

            //           showDialog(
            //             barrierColor: Colors.black26,
            //             barrierDismissible: false, // 바깥 영역 터치시 닫을지 여부
            //             context: context,
            //             builder: (context) {
            //               return CustomAlertDialog(
            //                 title: '오더 잡기',
            //                 description: '오더 번호: ' +
            //                     postData.orderIndex +
            //                     '\n' +
            //                     '상차지: ' +
            //                     postData.startArea.toString() +
            //                     '\n' +
            //                     '하차지: ' +
            //                     postData.endArea.toString() +
            //                     '\n' +
            //                     '상차일시: ' +
            //                     DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
            //                         DateTime.parse(postData.startDateTime)) +
            //                     '\n' +
            //                     '하차일시: ' +
            //                     DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(
            //                         DateTime.parse(postData.endDateTime)) +
            //                     '\n' +
            //                     '운반비: ￦' +
            //                     postData.cost,
            //                 orderIndex: postData.orderIndex,
            //                 orderTel: postData.orderTel,
            //               );
            //             },
            //           );
            //         }
            //       }),
            // ),
          ],
        ),
      ),
      //body: Text(postData.content),
    );
  }

  Future<bool> offDialog(int cancelcount) async {
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
                new Text("오더 취소", style: TextStyle(color: Colors.red)),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('오더 잡기를 취소하셨습니다.' + '\n' + '하루에 3번 이상 취소 하실 수 없습니다.'),
                Text('(현재 취소 횟수: $cancelcount 회 입니다.)',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  // 캔슬 카운트 상승

                  UpdateData.calcelCountChange(LoginScreen.allID, cancelcount);

                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<bool> offDialog2() async {
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
                new Text("시간 초과", style: TextStyle(color: Colors.red)),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('제한 시간을 초과하여' +
                    '\n' +
                    '오더 잡기에 실패하셨습니다.' +
                    '\n' +
                    '제한 시간 내에 다시 시도 부탁 드립니다.'),
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

  Future<bool> offDialog3(orderIndex) async {
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
                new Text("통화 결과"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "화주와의 통화로 배차 완료 하셨습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("예"),
                onPressed: () {
                  isConfirm = true;
                  Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text("아니요"),
                onPressed: () {
                  // orderYN N으로 업데이트
                  UpdateData.orederYNChange(orderIndex, 'N');
                  isConfirm = false;
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _callNumber(telnum) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(telnum);
  }

  _sendSms({required String number, required String message}) async {
    final permission = Permission.sms.request();
    if (await permission.isGranted) {
      directSms.sendSms(message: message, phone: number);
    }
  }
}
