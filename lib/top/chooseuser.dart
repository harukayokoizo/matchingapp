import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/provider/type_provider.dart';
import 'package:matching_app/provider/user_provider.dart';
import 'package:matching_app/top/swipeuser.dart';
import 'package:provider/provider.dart';

import '../provider/initset_provider.dart';

class ChooseUser extends StatelessWidget {
  @override

  Widget build(BuildContext context){
    final typeModel = Provider.of<TypeProvider>(context, listen: false);

    return Consumer<TypeProvider>(
        builder: (context, model, _) {
          print(typeModel.exitTypeFlag);
          if (typeModel.exitTypeFlag) {
            return SwipeUser();

          } else if(typeModel.confirmationFlag) {
            return ChooseType();

          }else{
            return Choose();
          }
        }
    );
  }
}

//ChooseUserはタイプを選択しているかのチェックをするクラス
class Choose extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final typeModel = Provider.of<TypeProvider>(context, listen: false);

    print('consumer');

      return FutureBuilder(
                future: typeModel.exitMyType(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // スプラッシュ画面(ロード中のくるくる画面)
                    return Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          color: Colors.green,
                        )
                    );
                  }
                  if (snapshot.data == true) {
                    return SwipeUser();
                  } else {
                    return ChooseType();
                  }
                }
            );

    }


}

class ChooseType extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    int type;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    final userModel = Provider.of<TypeProvider>(context, listen: false);

    return Scaffold(
        body: Consumer<InitSetProvider>(
          builder: (context, model, _){
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
                          left: 60,
                          top: 85,
                          child: Text(
                              "どのように仲良くなる？",
                              style: TextStyle(
                                color: Colors.white,
                                ///文字の色を白にする
                                fontWeight: FontWeight.bold,
                                ///文字を太字する
                                fontSize: 25.0,
                                ///文字のサイズを調整する
                              )),
                        ),
                      ]),
                ),
                Container(
                  height: 400,
                  width: deviceWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            shadowColor: Colors.white,
                            minimumSize: Size(250, 70), //(横、高さ)
                            side: BorderSide(color: Colors.white, width: 2),
                            backgroundColor: model.isPressed1 ? Colors.black : Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "コツコツとメッセージで",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            type = 0;
                            userModel.inputTypeData(type);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shadowColor: Colors.white,
                            minimumSize: Size(308, 70), //(横、高さ)
                            side: BorderSide(
                                color: model.isPressed1 ? Colors.white : Colors.white,
                                width: 2
                            ),
                            backgroundColor: model.isPressed2 ? Colors.black : Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "電話で",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            type = 1;
                            userModel.inputTypeData(type);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shadowColor: Colors.white,
                            minimumSize: Size(308, 70), //(横、高さ)
                            side: BorderSide(
                                color: model.isPressed1 ? Colors.white : Colors.white,
                                width: 2
                            ),
                            backgroundColor: model.isPressed2 ? Colors.black : Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "実際に会って",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            type = 2;
                            userModel.inputTypeData(type);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        )
    );
  }
}