import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:matching_app/test.dart';
import 'package:matching_app/user_set/user_hobby.dart';
import 'package:matching_app/user_set/user_image.dart';
import 'package:matching_app/user_set/user_sex.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';

class GreetSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _greet;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final model = Provider.of<InitSetProvider>(context, listen: false);

    return Scaffold(
      //キーボードを同じレイヤーではなく上端のレイヤーに乗せる設定する
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          //キーボード外の画面タップでキーボードを閉じる
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
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
                            onPressed: (){
                              Navigator.pop(
                                context,
                                true,
                              );
                            }
                        ),
                      ),
                      Positioned(
                        left: deviceWidth/2 - 60,
                        top: 85,
                        child: Text(
                            "あいさつ",
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
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20.0, right: 20.0, bottom:90.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          maxLength: 50,
                          maxLines: 4,
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            //フォーカス前のフィールドのデザイン
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 5,
                              ),
                            ),
                            //フォーカス後のフィールドのデザイン
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 5,
                              ),
                            ),
                          ),
                          //onChangeは都度入力される
                          onChanged: (value){
                            _greet = value;
                            model.inputGreetData(_greet);
                            print(_greet);
                          },
                        ),
                      ],
                    ),
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
                        print(model.name);
                        print(model.age);
                        print(model.sex);
                        print(model.list);
                        print(model.greet);

                        if(model.greet != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ImageSetting();
                              },
                            ),
                          );
                        }
                      },

                      ///ボタンの配置場所を決める
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 100.0, right: 100.0,bottom: 70),
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
