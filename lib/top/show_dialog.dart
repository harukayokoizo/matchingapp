import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:provider/provider.dart';

import '../provider/myprofile_provider.dart';

class SwitchButton extends StatelessWidget{
  final int value;

  @override
  SwitchButton(this.value);

  Widget build(BuildContext context){
    final profileModel = Provider.of<MyProfileProvider>(context, listen: false);

    return FloatingActionButton(
        //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
        heroTag: "btn"+"$value",
        backgroundColor: Colors.grey,
        foregroundColor: Colors.black,
        onPressed: () async{
          await showDialog(
              context: context,
              builder: (_) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[

                      ///RichTextはテキストの一部だけ色やサイズを変えれる
                      FittedBox(
                        ///GestureDetectorは、ボタン入力をサポートする
                        child: GestureDetector(

                          ///画面遷移ボタン
                          onTap: () async {
                            await profileModel.deleteImageCollection(value);
                            Navigator.pop(context);
                          },
                          ///ボタンの配置場所を決める
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 15),

                            ///paddingで水平方向と垂直方向を指定する
                            padding:
                            EdgeInsets.symmetric(horizontal: 150, vertical: 15),

                            ///コンテナの見た目の装飾
                            decoration: BoxDecoration(

                              ///boxの角の丸みを指定する
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white),

                            ///boxの中にテキストを入れる
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "削除",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
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
                            Navigator.pop(context);
                          },

                          ///ボタンの配置場所を決める
                          child: Container(
                            margin: EdgeInsets.only(top: 15, bottom: 20),

                            ///paddingで水平方向と垂直方向を指定する
                            padding:
                            EdgeInsets.symmetric(horizontal: 120, vertical: 15),

                            ///コンテナの見た目の装飾
                            decoration: BoxDecoration(

                              ///boxの角の丸みを指定する
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white
                            ),

                            ///boxの中にテキストを入れる
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "キャンセル",
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
                );
              }
          );
        },
        child: Icon(Icons.remove),
      );

  }



}


class InitSwitchButton extends StatelessWidget {
  final int value;

  @override
  InitSwitchButton(this.value);

  Widget build(BuildContext context) {
    final model = Provider.of<InitSetProvider>(context, listen: false);

    return FloatingActionButton(
      //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
      heroTag: "btn" + "$value",
      backgroundColor: Colors.grey,
      foregroundColor: Colors.black,
      onPressed: () {
        print('No');
        if(model.userImages[value] != null) {
          print('Yes');
          model.removeImage(value);
        }
      },
      child: Icon(Icons.remove),
    );
  }
}