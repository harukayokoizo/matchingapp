import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/chat_provider.dart';
import '../provider/user_provider.dart';
import 'chat_profile.dart';

class PreChat extends StatelessWidget{
  final int index;
  final doc;

  PreChat(this.index,this.doc);

  @override
  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatProvider>(context, listen: false);
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final userUid = chatModel.userInMatch[index].documentId;
    final profile = chatModel.userInMatch[index].profile;
    var hobbies;
    var images;


    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: deviceHeight,
            width: deviceWidth,

            decoration: BoxDecoration(
              color: Colors.orange,
            ),
          ),
          Positioned(
            top: 150,
            child: Text(
              'マッチおめでとうございます！',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                decorationColor: Colors.orange,
              ),
            ),
          ),
          Positioned(
            top: 200,
            child: InkWell(
              onTap: () async{
                hobbies = await chatModel.getHobby(userUid);
                images = await chatModel.getAllImage(userUid);
                print(images);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatProfile(index, hobbies, images, profile),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                      )
                  ),
                  Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: Image.network(chatModel.userInMatch[index].imagePath).image
                          )
                      )
                  ),
                ]
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: GestureDetector(
              ///画面遷移ボタン
              onTap: () async{
                await chatModel.chatStart(doc);
                await chatModel.chatCreate(doc);
                Navigator.of(context).pop();
              },

              ///ボタンの配置場所を決める
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),

                ///paddingで水平方向と垂直方向を指定する
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 6),

                ///コンテナの見た目の装飾
                decoration: BoxDecoration(

                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  ///boxの角の丸みを指定する
                  borderRadius: BorderRadius.circular(25),

                ),

                ///boxの中にテキストを入れる
                child: Text(
                  "チャットを始める",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    decorationColor: Colors.orange,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

  }
}