import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matching_app/provider/login_provider.dart';
import 'package:matching_app/provider/user_provider.dart';
import 'package:matching_app/test.dart';
import 'package:matching_app/top/top.dart';
import 'package:matching_app/user_set/user_name.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, model, _) {
      return Column(
        children: <Widget>[

          ///Expandedは他のwidgetとの隙間を埋める
          Expanded(
            flex: 2,

            ///画像のコンテナ
            child: Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Container(

                ///BoxDecorationはContainerの見た目の装飾

              ),
            ),
          ),

          Expanded(
            child: Column(
              children: <Widget>[

                ///RichTextはテキストの一部だけ色やサイズを変えれる
                FittedBox(

                  ///GestureDetectorは、ボタン入力をサポートする
                  child: GestureDetector(

                    ///画面遷移ボタン
                    onTap: () async {
                      bool exit = true;
                      //if文が必要、FireStoreから情報を取得できた場合のコードを記述予定
                      User user = await Authentication.signInWithGoogle();
                      //FireStoreからGoogleAuthのuidに紐づくドキュメントを取得する
                      exit = await model.nextPageJudge();

                      if(exit){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopPage(),
                          ),
                        );
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NameSetting(),
                          ),
                        );
                      }

                    },

                    ///ボタンの配置場所を決める
                    child: Container(
                      margin: EdgeInsets.only(top: 30, bottom: 20),

                      ///paddingで水平方向と垂直方向を指定する
                      padding:
                      EdgeInsets.symmetric(horizontal: 60, vertical: 15),

                      ///コンテナの見た目の装飾
                      decoration: BoxDecoration(

                        ///boxの角の丸みを指定する
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.orange),

                      ///boxの中にテキストを入れる
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Googleでログイン",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///FittedBoxは親widgetにぴったり収めることができる
                FittedBox(

                  ///GestureDetectorは、ボタン入力をサポートする
                  child: GestureDetector(

                    ///画面遷移ボタン
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NameSetting();
                          },
                        ),
                      );
                    },

                    ///ボタンの配置場所を決める
                    child: Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),

                      ///paddingで水平方向と垂直方向を指定する
                      padding:
                      EdgeInsets.symmetric(horizontal: 50, vertical: 15),

                      ///コンテナの見た目の装飾
                      decoration: BoxDecoration(

                        ///boxの角の丸みを指定する
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.orange),

                      ///boxの中にテキストを入れる
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.chat_bubble_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "電話番号でログイン",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    )
    );
  }
}
