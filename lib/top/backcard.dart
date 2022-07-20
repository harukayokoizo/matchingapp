import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackCard extends StatelessWidget{

  @override

  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Stack(
        children: [
          Container(
            width: 350,
            height: 550,
            decoration: BoxDecoration(
              ///boxの角の丸みを指定する
              borderRadius: BorderRadius.circular(25),
              color: Colors.green,
            ),

          ),
          Positioned(
            left: 30,
            bottom: 100,
            child: Text(
                "名前",
                style: TextStyle(
                  color: Colors.white,
                  ///文字の色を白にする
                  fontWeight: FontWeight.bold,
                  ///文字を太字する
                  fontSize: 30.0,
                )
            ),
          ),
          Positioned(
            left: 100,
            bottom: 100,
            child: Text(
                "23",
                style: TextStyle(
                  color: Colors.white,
                  ///文字の色を白にする
                  fontWeight: FontWeight.bold,
                  ///文字を太字する
                  fontSize: 30.0,
                )
            ),
          ),
          Positioned(
            left: 30,
            bottom: 30,
            child: Container(
              width: 300,
              child: Text(
                  "あいさつあいさつあいさつあいさつあいさつあいさつあいさつ",
                  style: TextStyle(
                    color: Colors.white,
                    ///文字の色を白にする
                    fontWeight: FontWeight.bold,
                    ///文字を太字する
                    fontSize: 20.0,
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}