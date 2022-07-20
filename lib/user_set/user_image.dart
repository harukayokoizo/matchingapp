import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matching_app/custompainter/custompaint.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:matching_app/test.dart';
import 'package:matching_app/top/top.dart';
import 'package:matching_app/user_set/input_user_data.dart';
import 'package:matching_app/user_set/user_greet.dart';
import 'package:matching_app/user_set/user_hobby.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:matching_app/user_set/user_sex.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';

import '../provider/myprofile_provider.dart';
import '../top/show_dialog.dart';

class ImageSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    //final imageModel = Provider.of<InitSetProvider>(context, listen: false);
    // インスタンス生成
    //final picker = ImagePicker();

// カメラから読み込み
    //final pickedFile = await picker.getImage(source: ImageSource.camera);

// アルバムから読み込み
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);

    return Scaffold(
        body: Consumer<InitSetProvider>(
         builder: (context, imageModel, _) {
           //imageModel.userImages = [];
           //imageModel.imageList = [];
           return Column(
             children: [
               Container(
                 height: 170,
                 width: deviceWidth,
                 child: Stack(
                     children: [
                       Container(
                         height: 170,
                         width: deviceWidth,
                       ),
                       Positioned(
                         top: 30,
                         left: 0,
                         child: IconButton(
                             icon: Icon(
                               Icons.chevron_left,
                               size: 50,
                             ),
                             onPressed: () {
                               Navigator.pop(
                                 context,
                                 true,
                               );
                             }
                         ),
                       ),
                       Positioned(
                         left: deviceWidth / 2 - 30,
                         top: 85,
                         child: Text(
                             "画像",
                             style: TextStyle(
                               color: Colors.white,

                               ///文字の色を白にする
                               fontWeight: FontWeight.bold,

                               ///文字を太字する
                               fontSize: 30.0,

                               ///文字のサイズを調整する
                             )),
                       ),
                     ]),
               ),
               Container(
                 height: 400,
                 width: deviceWidth,
                 child: Padding(
                   padding: const EdgeInsets.only(left: 21),
                   child: Column(
                     children: [
                       Row(
                         children: [
                           Stack(
                               children: <Widget>[
                                 Container(
                                   height: 180,
                                   width: 125,
                                 ),
                                 Positioned(
                                   top: 30,
                                   child: imageModel.displayImage(0),
                                 ),
                                 if(0 < imageModel.imageList.length && imageModel.imageList[0] != null)
                                   Positioned(
                                     top: 5,
                                     left: 75,
                                     //プラスボタンのフォーマット
                                     child: Container(
                                         width: 40.0,
                                         child: InitSwitchButton(0)
                                     ),
                                   ),
                                 if(0 >= imageModel.imageList.length)
                                   Positioned(
                                     top: 5,
                                     left: 75,
                                     //プラスボタンのフォーマット
                                     child: Container(
                                       width: 40.0,
                                       child: FloatingActionButton(
                                         //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                         heroTag: "btn"+"7",
                                         backgroundColor: Colors.orange,
                                         foregroundColor: Colors.black,
                                         onPressed: () async{
                                           await imageModel.uploadImage();
                                         },
                                         child: Icon(Icons.add),
                                       ),
                                     ),
                                   ),

                               ]
                           ),
                           Stack(
                               children: <Widget>[
                                 Container(
                                   height: 180,
                                   width: 125,
                                 ),
                                 Positioned(
                                   top: 30,
                                   child: imageModel.displayImage(1),
                                 ),
                                 if(1 < imageModel.imageList.length && imageModel.imageList[1]!= null)
                                   Positioned(
                                       top: 5,
                                       left: 75,
                                       child: Container(
                                         width: 40.0,
                                         child: InitSwitchButton(1),
                                       )
                                   ),
                                 if(1 >= imageModel.imageList.length)
                                   Positioned(
                                     top: 5,
                                     left: 75,
                                     //プラスボタンのフォーマット
                                     child: Container(
                                       width: 40.0,
                                       child: FloatingActionButton(
                                         //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                         heroTag: "btn"+"8",
                                         backgroundColor: Colors.orange,
                                         foregroundColor: Colors.black,
                                         onPressed: () async{
                                           await imageModel.uploadImage();
                                         },
                                         child: Icon(Icons.add),
                                       ),
                                     ),
                                   ),
                               ]
                           ),
                           Stack(
                               children: <Widget>[
                                 Container(
                                   height: 180,
                                   width: 121,
                                 ),
                                 Positioned(
                                   top: 30,
                                   child: imageModel.displayImage(2),
                                 ),
                                 if(2 < imageModel.imageList.length && imageModel.imageList[2]!= null)
                                   Positioned(
                                       top: 5,
                                       left: 75,
                                       child: Container(
                                         width: 40.0,
                                         child: InitSwitchButton(2),
                                       )
                                   ),
                                 if(2 >= imageModel.imageList.length)
                                   Positioned(
                                     top: 5,
                                     left: 75,
                                     //プラスボタンのフォーマット
                                     child: Container(
                                       width: 40.0,
                                       child: FloatingActionButton(
                                         //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                         heroTag: "btn"+"9",
                                         backgroundColor: Colors.orange,
                                         foregroundColor: Colors.black,
                                         onPressed: () async{
                                           await imageModel.uploadImage();
                                         },
                                         child: Icon(Icons.add),
                                       ),
                                     ),
                                   ),
                               ]
                           ),
                         ],
                       ),
                       Row(
                         children: [
                           Stack(
                               children: <Widget>[
                                 Container(
                                   height: 180,
                                   width: 125,
                                 ),
                                 Positioned(
                                   top: 30,
                                   child: imageModel.displayImage(3),
                                 ),
                                 if(3 < imageModel.imageList.length && imageModel.imageList[3]!= null)
                                   Positioned(
                                       top: 5,
                                       left: 75,
                                       child: Container(
                                         width: 40.0,
                                         child: InitSwitchButton(3),
                                       )
                                   ),
                                 if(3 >= imageModel.imageList.length)
                                   Positioned(
                                     top: 5,
                                     left: 75,
                                     //プラスボタンのフォーマット
                                     child: Container(
                                       width: 40.0,
                                       child: FloatingActionButton(
                                         //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                         heroTag: "btn"+"10",
                                         backgroundColor: Colors.orange,
                                         foregroundColor: Colors.black,
                                         onPressed: () async{
                                           await imageModel.uploadImage();
                                         },
                                         child: Icon(Icons.add),
                                       ),
                                     ),
                                   ),
                               ]
                           ),
                           Stack(
                               children: <Widget>[
                                 Container(
                                   height: 180,
                                   width: 125,
                                 ),
                                 Positioned(
                                   top: 30,
                                   child: imageModel.displayImage(4),
                                 ),
                                 if(4 < imageModel.imageList.length && imageModel.imageList[4]!= null)
                                   Positioned(
                                       top: 5,
                                       left: 75,
                                       child: Container(
                                         width: 40.0,
                                         child: InitSwitchButton(4),
                                       )
                                   ),
                                 if(4 >= imageModel.imageList.length)
                                   Positioned(
                                     top: 5,
                                     left: 75,
                                     //プラスボタンのフォーマット
                                     child: Container(
                                       width: 40.0,
                                       child: FloatingActionButton(
                                         //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                         heroTag: "btn"+"11",
                                         backgroundColor: Colors.orange,
                                         foregroundColor: Colors.black,
                                         onPressed: () async{
                                           await imageModel.uploadImage();
                                         },
                                         child: Icon(Icons.add),
                                       ),
                                     ),
                                   ),
                               ]
                           ),
                           Stack(
                               children: <Widget>[
                                 Container(
                                   height: 180,
                                   width: 121,
                                 ),
                                 Positioned(
                                   top: 30,
                                   child: imageModel.displayImage(5),
                                 ),
                                 if(5 < imageModel.imageList.length && imageModel.imageList[5]!= null)
                                   Positioned(
                                       top: 5,
                                       left: 75,
                                       child: Container(
                                         width: 40.0,
                                         child: InitSwitchButton(5),
                                       )
                                   ),
                                 if(5 >= imageModel.imageList.length)
                                   Positioned(
                                     top: 5,
                                     left: 75,
                                     //プラスボタンのフォーマット
                                     child: Container(
                                       width: 40.0,
                                       child: FloatingActionButton(
                                         //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                         heroTag: "btn"+"12",
                                         backgroundColor: Colors.orange,
                                         foregroundColor: Colors.black,
                                         onPressed: () async{
                                           await imageModel.uploadImage();
                                         },
                                         child: Icon(Icons.add),
                                       ),
                                     ),
                                   ),
                               ]
                           ),
                         ],
                       ),

                     ],
                   ),
                 ),
               ),
               Expanded(
                 child: Container(
                   height: 300,
                   width: deviceWidth,
                   child: FittedBox(
                     child: GestureDetector(

                       ///画面遷移ボタン
                       onTap: () {
                         print(imageModel.userImages);

                         if(imageModel.userImages.length != 0) {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) {
                                 return InputData();
                               },
                             ),
                           );
                         }
                       },

                       ///ボタンの配置場所を決める
                       child: Padding(
                         padding: const EdgeInsets.only(
                             top: 10.0, left: 100.0, right: 100.0, bottom: 70),
                         child: Container(
                           margin: EdgeInsets.only(top: 20, bottom: 20),

                           ///paddingで水平方向と垂直方向を指定する
                           padding: EdgeInsets.symmetric(
                               horizontal: 100, vertical: 6),

                           ///コンテナの見た目の装飾
                           decoration: BoxDecoration(

                             ///boxの角の丸みを指定する
                               borderRadius: BorderRadius.circular(25),
                               color: Colors.orange),

                           ///boxの中にテキストを入れる
                           child: Text(
                             "スタート",
                             style: TextStyle(
                               fontSize: 40,
                               color: Colors.black,
                               fontWeight: FontWeight.w900,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
             ],
           );
         }
        )
    );
  }
}
