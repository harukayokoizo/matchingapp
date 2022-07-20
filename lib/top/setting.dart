import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../loginpage.dart';
import '../utils/authentication.dart';

class Setting extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
            '設定',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 16.0),
              child: InkWell(
                child: Container(
                  height: 60,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      border: Border.all(width: 1)
                  ),
                  child:Center(
                    child:Text(
                        'ログアウト',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: ()async{
                  await Authentication.signOutWithGoogle();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 32.0),
              child: InkWell(
                child: Container(
                  height: 60,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      border: Border.all(width: 1)
                  ),
                  child:Center(
                    child:Text(
                      'アカウントを削除',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: (){
                },
              ),
            ),
          ]
      ),
    );
  }
}