import 'package:flutter/material.dart';

class MyPainter extends CustomPainter{
  // 実際の描画処理を行うメソッド
  Paint painter = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    // ここに描画の処理を書く
    painter.color = Colors.red;
    canvas.drawCircle(Offset(100,35), 20, painter);
  }

  // 再描画のタイミングで呼ばれるメソッド
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}