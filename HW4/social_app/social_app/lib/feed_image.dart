import 'package:flutter/material.dart';

class MyImg extends StatefulWidget{
  MyImg({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyImgState createState() => _MyImgState();
}

class _MyImgState extends State<MyImg> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Color(0xFFf8faf8),
        appBar: AppBar(title: Text(widget.title, style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black,), onPressed:() {Navigator.pop(context);}),
        ),
        body: Center(
            child: Image.asset("images/timg.jpeg"),
        )  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}