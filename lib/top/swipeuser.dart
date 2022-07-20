import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/top/backcard.dart';
import 'package:matching_app/top/fowordcard.dart';
import 'package:matching_app/top/popup_widget.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../provider/type_provider.dart';
import '../provider/user_provider.dart';
import '../test.dart';
import 'no_user.dart';

class SwipeUser extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, model, _) {
          if (model.sameTypeUser.length == 0) {
            return Restart();
          } else {
            return CardList();
          }
        }
    );
  }

}

class Restart extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    final userModel = Provider.of<UserProvider>(context, listen: false);
    return FutureBuilder(
        future: userModel.getUser('first'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.green,
                )
            );
          } else {
            if(userModel.users.length == 0){
              return NoUser();
            }else{
              return CardList();
            }
          }
        }
    );
  }
}





class CardList extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    final userModel = Provider.of<UserProvider>(context, listen: false);
    final userTypeModel = Provider.of<TypeProvider>(context, listen: false);


    return Scaffold(
            body: SwipableStack(
              itemCount: userModel.users.length,
              builder: (context, properties) {
                return ForwardCard(properties.index);
                },
              overlayBuilder: (context, properties) {
                final opacity = min(properties.swipeProgress, 1.0);
                final isRight = properties.direction == SwipeDirection.right;

                  return Opacity(
                    opacity: isRight ? opacity : opacity ,
                    child: isRight ? CardLabel.right() : CardLabel.left(),
                  );

              },
              onSwipeCompleted: (index, direction) async{
                String dire;
                bool judge = false;
                if(direction == SwipeDirection.right){
                  //右にスワイプしたときの機能を記述
                  dire = 'right';

                  //マッチングしているか検索する
                  judge = await userModel.judgeMatch(index);
                  if(judge == true){
                    //マッチしたときのWidgetを表示するアクションを記載
                    print('matching');
                    // ダイアログを表示------------------------------------
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PopUpWidget(index);
                        },
                      ),
                    );
                    print('back');
                  }
                  //スワイプしたユーザーのuidをローカルに保存する。
                  await userModel.swipeCompleted(index);

                  //reactionテーブルを更新する。
                  userModel.editData(index,dire,judge);

                  userModel.users.removeAt(index);

                  userModel.getUser('middle');

                }else if(direction == SwipeDirection.left){
                  dire = 'left';
                  bool judge = false;
                  await userModel.swipeCompleted(index);
                  //左にスワイプしたときの機能を記述
                  userModel.editData(index, dire, judge);

                  userModel.users.removeAt(index);

                  userModel.getUser('middle');
                }

              },
              onWillMoveNext: (index, direction) {
                final allowedActions = [
                  SwipeDirection.right,
                  SwipeDirection.left,
                ];
                return allowedActions.contains(direction);
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            floatingActionButton: Positioned(
              top: 30,
              child: Container(
                height: 50,
                width: 50,
                child: FloatingActionButton(
                  backgroundColor: kBackgroundColor,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.orange, //枠線の色
                    ),
                  ),
                  onPressed: () async{
                    await showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            backgroundColor: Colors.orange,
                            title: Text(
                                'タイプを変更しますか?',
                                textAlign: TextAlign.center),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right:8.0, bottom: 15.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        //○だった時の処理を記載
                                        userTypeModel.deleteFunction();
                                        userModel.resetArray(1);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right:8.0, bottom: 15.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        //×だった時の処理を記載
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                    );
                  },
                  child: Icon(
                      Icons.arrow_back,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          );

  }
}

class CardLabel {
  static Widget right(){
    return Stack(
      children : [
        Positioned(
          top: 90,
          left: 40,
          child: Container(
            height: 40,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 3),
              ///boxの角の丸みを指定する
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Like',
              style: TextStyle(
                fontSize: 30,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }
  static Widget left(){
    return Stack(
      children : [
        Positioned(
          top: 90,
          right: 40,
          child: Container(
            height: 40,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 3),
              ///boxの角の丸みを指定する
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Nope',
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
