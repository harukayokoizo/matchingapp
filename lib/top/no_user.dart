import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/type_provider.dart';
import '../provider/user_provider.dart';
import '../test.dart';

class NoUser extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    final userModel = Provider.of<UserProvider>(context, listen: false);
    final userTypeModel = Provider.of<TypeProvider>(context, listen: false);


    return Scaffold(
      body: Center(
        child: Text(
          'ユーザーがいません',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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