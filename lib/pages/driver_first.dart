import 'package:bangtong/login/loginScreen.dart';
import 'package:bangtong/pages/end.dart';
import 'package:bangtong/pages/start.dart';
import 'package:bangtong/pages/steel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Driver_first extends StatefulWidget {
  const Driver_first({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Driver_first> {
  String strDday = '';
  String strNextDday = '';

  @override
  void initState() {
    super.initState();

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
            width: double.infinity,
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
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  child: Image.asset('assets/images/1.png', height: 175),
                  onTap: () {
                    //상차지 기준
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => startArea()));
                  })),
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  child: Image.asset('assets/images/3.png', height: 175),
                  onTap: () {
                    // 하차지 기준
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => endArea()));
                  })),
          SizedBox(
              width: double.infinity,
              child: InkWell(
                  child: Image.asset('assets/images/2.png', height: 175),
                  onTap: () {
                    //제강사 기준
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => steeltArea()));
                  })),
        ],
      ),
    );
  }
}
