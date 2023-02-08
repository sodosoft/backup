import 'package:flutter/material.dart';

class orderINGDemo extends StatefulWidget {
  const orderINGDemo({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<orderINGDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("Generate List"),
        // ),
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ' 데모 화면입니다. \n 차주가 요청한 오더가\n 이곳에 표시 됩니다.',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
              ),
            )
          ]),
    ));
  }
}
