import 'package:bangtong/function/UpdateData.dart';
import 'package:bangtong/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../login/login.dart';
import 'dart:async';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.orderIndex,
    required this.orderTel,
  }) : super(key: key);

  final String title, description, orderIndex, orderTel;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {

  int _seconds = 0;
  int _10Minutes = 9;
  int _remainSecond = 60;
  int _10MinutesSecond = 600;
  String countTime = '';
  String remainTime = '';
  final f = new DateFormat('mm:ss');

  bool _isRunning = false;
  Timer? _timer;

  void _start() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _10MinutesSecond--;

        if(_10MinutesSecond < 0)
        {
          offDialog2();
          _stopTimer();
          _resetTimer();
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
          });
        }
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _seconds = 0;
      _10MinutesSecond = 600;
    });
  }

  _callNumber(telnum) async{
    bool? res = await FlutterPhoneDirectCaller.callNumber(telnum);
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 15),
          Text('?????? ?????? : $_10MinutesSecond ???',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Text("${widget.description}"),
          SizedBox(height: 20),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () {
                // ???????????? ?????? ??????
                _callNumber(widget.orderTel);

                _resetTimer();
                _stopTimer();

                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Text(
                  "?????? ??????",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () async {
                // ??????
                // // orderYN N?????? ????????????
                UpdateData.orederYNChange(widget.orderIndex, 'N');
                // // ?????? ?????? ??????(?????? ?????? ????????? 3??? ??????)

                offDialog(LoginScreen.cancelCount + 1);

                _resetTimer();
                _stopTimer();
                // ?????? ??????
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                });
              },
              child: Center(
                child: Text(
                  "?????? ??????",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> offDialog(int cancelcount) async {
    return await showDialog(
        context: context,
        //barrierDismissible - Dialog??? ????????? ?????? ?????? ?????? x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog ?????? ????????? ????????? ??????
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("?????? ??????",
                  style: TextStyle(color: Colors.red)),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '?????? ????????? ?????????????????????.' + '\n' +
                    '????????? 3??? ?????? ?????? ?????? ??? ????????????.'
                ),
                Text('(?????? ?????? ??????: $cancelcount ??? ?????????.)',
                    style: TextStyle(color: Colors.red)),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("??????"),
                onPressed: () {
                  // ?????? ????????? ??????

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
        //barrierDismissible - Dialog??? ????????? ?????? ?????? ?????? x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog ?????? ????????? ????????? ??????
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("?????? ??????",
                    style: TextStyle(color: Colors.red)),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    '?????? ????????? ????????????' + '\n' +
                    '?????? ????????? ?????????????????????.' + '\n' +
                    '?????? ?????? ?????? ?????? ?????? ?????? ????????????.'
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("??????"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}

