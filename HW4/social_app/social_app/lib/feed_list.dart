import 'package:flutter/material.dart';
import 'package:social_app/feed_image.dart';

class myList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemExtent: 430.0,
      itemBuilder: (BuildContext context, int index){
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new AssetImage(
                            "images/dog.jpeg")),
                  ),
                ),
                title: Text("Andrew", style: TextStyle(fontWeight: FontWeight.w700),),
              ),
              InkWell(
                child: Image.asset("images/timg.jpeg"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => MyImg(title:"Andrew")));
                },
              ),
              /*
              Container(
                child: Image.asset("images/timg.jpeg")
              ),
               */
              Container(
                margin: EdgeInsets.only(top:10),
                child: new Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(Icons.favorite_border),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Icon(Icons.crop_3_2),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:16.0),
                child: new Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left:16.0,right: 16),
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage(
                                "images/dog.jpeg")),
                      ),
                    ),
                    Container(
                      child: new  Expanded(child: TextField(decoration: InputDecoration(hintText: "Add a comment...", border: InputBorder.none,))),
                    ),
                  ],
                ),
              ),

            ],
          )
        );
      },
    );
  }
}