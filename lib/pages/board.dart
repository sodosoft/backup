import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; //flutter의 package를 가져오는 코드 반드시 필요
import 'package:http/http.dart' as http;

import '../../api/api.dart';
import '../../model/board.dart';
import 'package:get/get.dart';

class board extends StatefulWidget {
  const board({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<board> {
  Future<List<BoardData>?> _getPost() async {
    try {
      final respone =
          await http.get(Uri.parse('http://am1009n.dothome.co.kr/BOARD.php'));

      if (respone.statusCode == 200) {
        final result = utf8.decode(respone.bodyBytes);
        List<dynamic> json = jsonDecode(result);
        List<BoardData> boardList = [];

        for (var item in json.reversed) {
          BoardData boardData =
              BoardData(item['title'], item['content'], item['date']);
          boardList.add(boardData);
        }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _getPost(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.green[100 * (index % 10)],
                      child: ListTile(
                        textColor: Colors.grey[100 * (index % 10)],
                        title: Text(snapshot.data[index].title),
                        subtitle: Text(snapshot.data[index].date),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(snapshot.data[index])));
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
    );
  }
}

class DetailPage extends StatelessWidget {
  final BoardData postData;

  DetailPage(this.postData); // 생성자를 통해서 입력변수 받기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(postData.title),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Text(postData.content.replaceAll('|', '\n')),
      ),
      //body: Text(postData.content),
    );
  }
}
