import 'package:flutter/material.dart';
import 'feed_list.dart';

class MyBodyPage extends StatefulWidget {
  MyBodyPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyBodyPageState createState() => _MyBodyPageState();
}

class _MyBodyPageState extends State<MyBodyPage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(title: Text(widget.title, style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xFFf8faf8),
          leading: new Container(
            child: new Icon(Icons.camera_alt, color: Colors.black,),
            margin: const EdgeInsets.only(left: 12),
          ),
          actions: <Widget>[
            new Container(
              child: new Icon(Icons.battery_unknown, color: Colors.black,),
              margin: const EdgeInsets.only(right: 12),
            )
          ],
        ),
        body: myList()  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}