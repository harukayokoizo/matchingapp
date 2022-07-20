import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:matching_app/test.dart';
import 'package:matching_app/user_set/user_sex.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';

class NameSetting extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    //ResultProvider内の変数、関数にアクセスすることができる
    //ここでlisten:falseを指定し、Scaffold全体がリビルドされるのを回避する
    final model = Provider.of<InitSetProvider>(context, listen: false);
    String _name;

    return Scaffold(
      //キーボードを同じレイヤーではなく上端のレイヤーに乗せる設定する
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          //キーボード外の画面タップでキーボードを閉じる
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Container(
                //color: Colors.black,
                height: 170,
                width: deviceWidth,
                child: Stack(
                    children: [
                      Container(
                        //color: Colors.black,
                        height: 170,
                        width: deviceWidth,
                      ),
                      Positioned(
                        left: deviceWidth/2 - 30,
                        top: 85,
                        child: Text(
                            "名前",
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
              //color: Colors.black,
              height: 400,
              width: deviceWidth,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 150.0),
                        child: TextFormField(
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 5,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value){
                            _name = value;
                            model.inputNameData(_name);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                //color: Colors.black,
                height: 300,
                width: deviceWidth,
                child: FittedBox(
                  child: GestureDetector(
                    ///画面遷移ボタン
                    onTap: () {
                      print(model.name);

                      if(model.name != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SexSetting();
                            },
                          ),
                        );
                      }
                    },

                    ///ボタンの配置場所を決める
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 100.0, right: 100.0,bottom: 70
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),

                        ///paddingで水平方向と垂直方向を指定する
                        padding: EdgeInsets.symmetric(horizontal: 130, vertical: 6),

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
      ),
        ));
    }
  }
