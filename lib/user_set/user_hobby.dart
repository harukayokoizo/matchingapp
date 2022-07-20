import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matching_app/code/code_list.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:matching_app/test.dart';
import 'package:matching_app/user_set/user_greet.dart';
import 'package:matching_app/user_set/user_name.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';

import '../provider/myprofile_provider.dart';

class HobbySetting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<InitSetProvider>(context, listen: false);
    ///画面いっぱいの高さ、幅にしたい場合
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    HobbyCode code = new HobbyCode();

    return Scaffold(
        body: Consumer<InitSetProvider>(
        builder: (context, hobbyModel, _) {
          int index = 1;
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
                            "趣味",
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

                ///スクロールできるようになった
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for(int i = 0; i < 10;i++)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 16.0, right: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              for(int j = 1; j < 4; j++)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shadowColor: Colors.white,
                                      minimumSize: Size(100, 40),
                                      backgroundColor: hobbyModel.cacheHobbies.contains(index) ? Colors.orange : Theme.of(context).scaffoldBackgroundColor,//(横、高さ)
                                      side: BorderSide(
                                          color: Colors.white, width: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "${code.hobbyList[index++]}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: hobbyModel.cacheHobbies.contains(index) ? Colors.white : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      int number = (i * 3) + j;
                                      hobbyModel.addOrRemoveHobbyData(number);
                                      print(hobbyModel.cacheHobbies);
                                    },
                                  ),
                                ),
                            ],
                          ),
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
                        print(model.cacheHobbies);
                        if(model.cacheHobbies.length != 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return GreetSetting();
                              },
                            ),
                          );
                        }
                      },

                      ///ボタンの配置場所を決める
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 100.0, right: 100.0, bottom: 70
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),

                          ///paddingで水平方向と垂直方向を指定する
                          padding: EdgeInsets.symmetric(
                              horizontal: 130, vertical: 6),

                          ///コンテナの見た目の装飾
                          decoration: BoxDecoration(

                            ///boxの角の丸みを指定する
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.orange),

                          ///boxの中にテキストを入れる
                          child: Text(
                            "次へ",
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
        ));
    }
  }
