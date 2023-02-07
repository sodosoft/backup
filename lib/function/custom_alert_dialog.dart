// import 'package:bangtong/function/UpdateData.dart';
// import 'package:bangtong/login/loginScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../login/login.dart';
// import 'dart:async';

// class CustomAlertDialog extends StatefulWidget {
//   const CustomAlertDialog({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.orderIndex,
//     required this.orderTel,
//   }) : super(key: key);

//   final String title, description, orderIndex, orderTel;

//   @override
//   _CustomAlertDialogState createState() => _CustomAlertDialogState();
// }

// class _CustomAlertDialogState extends State<CustomAlertDialog> {

//   int _seconds = 0;
//   int _10Minutes = 9;
//   int _remainSecond = 60;
//   int _10MinutesSecond = 600;
//   String countTime = '';
//   String remainTime = '';
//   final f = new DateFormat('mm:ss');

//   bool _isRunning = false;
//   Timer? _timer;

//   void _start() {
//     _isRunning = true;
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         _seconds++;
//         _10MinutesSecond--;

//         if(_10MinutesSecond < 0)
//         {
//           offDialog2();
//           _stopTimer();
//           _resetTimer();
//           Future.delayed(const Duration(milliseconds: 500), () {
//             Navigator.pop(context);
//           });
//         }
//       });
//     });
//   }

//   void _stopTimer() {
//     _isRunning = false;
//     _timer?.cancel();
//   }

//   void _resetTimer() {
//     setState(() {
//       _seconds = 0;
//       _10MinutesSecond = 600;
//     });
//   }

//   _callNumber(telnum) async{
//     bool? res = await FlutterPhoneDirectCaller.callNumber(telnum);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _start();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       elevation: 0,
//       backgroundColor: Color(0xffffffff),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           SizedBox(height: 15),
//           Text('남은 시간 : $_10MinutesSecond 초',
//             style: TextStyle(
//               fontSize: 18.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 15),
//           Text("${widget.description}"),
//           SizedBox(height: 20),
//           Divider(
//             height: 1,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: 50,
//             child: InkWell(
//               highlightColor: Colors.grey[200],
//               onTap: () {
//                 // 화주한테 전화 걸기
//                 _callNumber(widget.orderTel);

//                 _resetTimer();
//                 _stopTimer();

//                 Future.delayed(const Duration(milliseconds: 500), () {
//                   Navigator.pop(context);
//                 });
//               },
//               child: Center(
//                 child: Text(
//                   "전화 걸기",
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Divider(
//             height: 1,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: 50,
//             child: InkWell(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(15.0),
//                 bottomRight: Radius.circular(15.0),
//               ),
//               highlightColor: Colors.grey[200],
//               onTap: () async {
//                 // 취소
//                 // // orderYN N으로 업데이트
//                 UpdateData.orederYNChange(widget.orderIndex, 'N');
//                 // // 캔슬 횟수 추가(캔슬 횟수 하루에 3번 제한)

//                 offDialog(LoginScreen.cancelCount + 1);

//                 _resetTimer();
//                 _stopTimer();
//                 // 화면 닫음
//                 Future.delayed(const Duration(milliseconds: 500), () {
//                   Navigator.pop(context);
//                 });
//               },
//               child: Center(
//                 child: Text(
//                   "오더 취소",
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.red,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<bool> offDialog(int cancelcount) async {
//     return await showDialog(
//         context: context,
//         //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0)),
//             //Dialog Main Title
//             title: Column(
//               children: <Widget>[
//                 new Text("오더 취소",
//                   style: TextStyle(color: Colors.red)),
//               ],
//             ),
//             //
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                     '오더 잡기를 취소하셨습니다.' + '\n' +
//                     '하루에 3번 이상 취소 하실 수 없습니다.'
//                 ),
//                 Text('(현재 취소 횟수: $cancelcount 회 입니다.)',
//                     style: TextStyle(color: Colors.red)),
//               ],
//             ),
//             actions: <Widget>[
//               new TextButton(
//                 child: new Text("확인"),
//                 onPressed: () {
//                   // 캔슬 카운트 상승

//                   UpdateData.calcelCountChange(LoginScreen.allID, cancelcount);

//                   Future.delayed(const Duration(milliseconds: 500), () {
//                           Navigator.pop(context);
//                   });
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   Future<bool> offDialog2() async {
//     return await showDialog(
//         context: context,
//         //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0)),
//             //Dialog Main Title
//             title: Column(
//               children: <Widget>[
//                 new Text("시간 초과",
//                     style: TextStyle(color: Colors.red)),
//               ],
//             ),
//             //
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                     '제한 시간을 초과하여' + '\n' +
//                     '오더 잡기에 실패하셨습니다.' + '\n' +
//                     '제한 시간 내에 다시 시도 부탁 드립니다.'
//                 ),
//               ],
//             ),
//             actions: <Widget>[
//               new TextButton(
//                 child: new Text("확인"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }
// }

