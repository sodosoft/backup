import 'package:flutter/material.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class four extends StatefulWidget {
  const four({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<four> {
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text("third slide"), // second third 다름
      // ),
      // body: Center(child:
      // Text('상담 문의',style: TextStyle(fontSize: 40)),
      // ) //second third 다름
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            IconButton(
              color: Colors.blueAccent,
              icon: const Icon(Icons.chat),
              iconSize: 50.0,
              onPressed: () {
                setState(() {});
              },
            ),
            Text('채팅으로 문의하기'),
            SizedBox(
              height: 100,
            ),
            IconButton(
              color: Colors.blueAccent,
              icon: const Icon(Icons.mail),
              iconSize: 50.0,
              onPressed: () {
                _sendEmail();
              },
            ),
            Text('E-mail로 문의하기'),
          ],
        ),
      ),
    );
  }
}

void _sendEmail() async {
  String body = ' ';
  // await _getEmailBody();

  final Email email = Email(
    body: body,
    subject: '[방통 배차 등록 서비스 문의]',
    recipients: ['master@sodosoft.net'],
    cc: [],
    bcc: [],
    attachmentPaths: [],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    String message =
        "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 신속하게 답변해드리겠습니다 :)\n\nmaster@sodosoft.net";

    Fluttertoast.showToast(msg: message);
  }
}
