import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/loginpage.dart';
import 'package:matching_app/top/popup_widget.dart';
import 'package:matching_app/top/start_match.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../provider/chat_provider.dart';
import 'chat.dart';

class ChatList extends StatelessWidget{
  @override

  // ignore: must_call_super
  Widget build(BuildContext context){
    final chatModel = Provider.of<ChatProvider>(context, listen: false);
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    print(chatModel.myUserReference);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: deviceWidth,
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,top: 10.0),
                child: Text(
                  'マッチ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height: 130,
              child: StreamBuilder(
                  stream: fireStore.collection('reaction')
                      .where('from_user_id',isEqualTo: chatModel.myUserReference)
                      .where('match',isEqualTo: 1)
                      .where('chat', isEqualTo: 0)
                      .snapshots(),
                  builder: (context, snapshots) {
                    chatModel.userInMatch = [];
                    if (snapshots.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshots.connectionState == ConnectionState.waiting) {
                      if(chatModel.userInMatchCache.isEmpty){
                        return Container();
                      }else {
                        return Cache();
                      }
                    }

                    List<dynamic> docs = snapshots.data.docs;


                    return SizedBox(
                      height: 120,
                      width: deviceWidth,
                      child: FutureBuilder(
                          future: chatModel.getImageFlow(docs),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              if (chatModel.userInMatchCache.isEmpty) {
                                return Container();
                              } else {
                                return Cache();
                              }
                            } else {

                              if(chatModel.userInMatch.length == 0){
                                return Container();
                              }else{
                                return ListView.builder(
                                  //横スクロールに変更
                                  scrollDirection: Axis.horizontal,
                                  itemCount: docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 15.0),
                                          child: Stack(
                                              children: [
                                                Container(
                                                    width: 91,
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    )
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PreChat(index,
                                                                docs[index]),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                      width: 90,
                                                      height: 90,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape
                                                              .circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: Image
                                                                  .network(
                                                                chatModel
                                                                    .userInMatch[index]
                                                                    .imagePath,
                                                                loadingBuilder: (
                                                                    context,
                                                                    child,
                                                                    loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;
                                                                  return SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child: CircularProgressIndicator(
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  );
                                                                  // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                                                },
                                                                errorBuilder: (
                                                                    context,
                                                                    error,
                                                                    stackTrace) =>
                                                                    Container(
                                                                      color: Colors
                                                                          .white,),
                                                              )
                                                                  .image
                                                          )
                                                      )
                                                  ),
                                                ),

                                              ]
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 15.0),
                                          child: Text(
                                            chatModel.userInMatch[index].profile
                                                .name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          }
                      ),
                    );

                    if(chatModel.userInMatch.length == 0){
                      return Container();
                    }else {
                      return SizedBox(
                        height: 120,
                        width: deviceWidth,
                        child: FutureBuilder(
                            future: chatModel.getImageFlow(docs),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                if (chatModel.userInMatchCache.isEmpty) {
                                  return Container();
                                } else {
                                  return Cache();
                                }
                              } else {
                                return ListView.builder(
                                  //横スクロールに変更
                                  scrollDirection: Axis.horizontal,
                                  itemCount: docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 15.0),
                                          child: Stack(
                                              children: [
                                                Container(
                                                    width: 90,
                                                    height: 90,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    )
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PreChat(index,
                                                                docs[index]),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                      width: 90,
                                                      height: 90,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape: BoxShape
                                                              .circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: Image
                                                                  .network(
                                                                chatModel
                                                                    .userInMatch[index]
                                                                    .imagePath,
                                                                loadingBuilder: (
                                                                    context,
                                                                    child,
                                                                    loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;
                                                                  return SizedBox(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child: CircularProgressIndicator(
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  );
                                                                  // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                                                },
                                                                errorBuilder: (
                                                                    context,
                                                                    error,
                                                                    stackTrace) =>
                                                                    Container(
                                                                      color: Colors
                                                                          .white,),
                                                              )
                                                                  .image
                                                          )
                                                      )
                                                  ),
                                                ),

                                              ]
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 15.0),
                                          child: Text(
                                            chatModel.userInMatch[index].profile
                                                .name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                        ),
                      );
                    }
                  }
              ),
            ),

            Container(
              width: deviceWidth,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,top: 10.0),
                child: Text(
                    'メッセージ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),















            ///chat一覧の部分
            ///chatルームを取得する
            StreamBuilder(
                stream: fireStore.collection('chat')
                    .where('users', arrayContains: chatModel.myUserReference)
                    .orderBy('updated',descending: true)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshots.connectionState == ConnectionState.waiting) {
                    if(chatModel.chatDocuments == null){
                      print('here');
                      return Container();
                    }else {
                      return ChatFirstCache();
                    }
                  }

                  if (snapshots.data.metadata.hasPendingWrites) {
                    print('hasPendingWrites');
                    return ChatFirstCache();
                  }else {
                    //matchUserをリセット（StreamBuilderがlistenされるときにリセットをする）
                    chatModel.matchUser = [];
                    //chatModel.chatImages = [];

                    //取得したチャットルームをchatDocumentsに保存する。
                    chatModel.chatDocuments = snapshots.data.docs;

                    //各チャットルームから相手ユーザーのリファレンスを取得する
                    chatModel.getReference();

                    return FutureBuilder(
                      //userProfile,userProfileCacheに各ユーザー情報を保存する。
                        future: chatModel.getUserDocumentAndImage(),
                        builder: (context, snapshots) {
                          if (snapshots.connectionState != ConnectionState.done) {
                            if (chatModel.userProfileCache.isEmpty) {
                              return Container();
                            } else {
                              if (chatModel.userProfileCache.length <= chatModel.userProfileCache.length) {
                                return ChatFirstCache();
                              } else {
                                return ChatSecondCache();
                              }
                            }
                          }

                          chatModel.userProfileCache = chatModel.userProfile;

                          if(chatModel.userProfile.length == 0){
                            return Container();
                          }else {
                            return SizedBox(
                              height: deviceHeight,
                              width: deviceWidth,
                              child: SlidableAutoCloseBehavior(
                                closeWhenOpened: true,
                                closeWhenTapped: true,
                                child: ListView.builder(
                                    itemCount: chatModel.chatDocuments.length,
                                    itemBuilder: (context, index) {
                                      return Slidable(
                                        closeOnScroll: false,
                                        //endActionPaneは、左へのスワイプアクションの設定
                                        endActionPane: ActionPane(
                                          motion: DrawerMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: (value) async {
                                                await showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return AlertDialog(
                                                        backgroundColor: Colors
                                                            .orange,
                                                        title: Text(
                                                            '${chatModel
                                                                .userProfile[index]
                                                                .profile
                                                                .name}とのマッチを解除してもよろしいですか？',
                                                            textAlign: TextAlign
                                                                .center),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    right: 8.0,
                                                                    bottom: 15.0),
                                                                child: FlatButton(
                                                                  onPressed: () {
                                                                    chatModel
                                                                        .chatDelete(
                                                                        chatModel
                                                                            .chatDocuments[index]
                                                                            .id);
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    '解除します',
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left: 8.0,
                                                                    right: 8.0,
                                                                    bottom: 15.0),
                                                                child: FlatButton(
                                                                  onPressed: () {
                                                                    //×だった時の処理を記載
                                                                    Navigator
                                                                        .pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    'キャンセル',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
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
                                              backgroundColor: Colors.red,
                                              icon: Icons.delete,
                                              label: 'ブロック',
                                            ),
                                          ],
                                        ),
                                        child: Container(
                                          height: 80,
                                          child: ListTile(
                                              leading: Container(
                                                height: 50,
                                                width: 50,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .circular(25),
                                                    child: Image(
                                                      fit: BoxFit.fill,
                                                      image: Image
                                                          .network(
                                                          chatModel
                                                              .userProfile[index]
                                                              .imagePath
                                                      )
                                                          .image,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null)
                                                          return child;
                                                        return SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: CircularProgressIndicator(
                                                            color: Colors.green,
                                                          ),
                                                        );
                                                        // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                                      },
                                                      errorBuilder: (context,
                                                          error,
                                                          stackTrace) =>
                                                          Container(
                                                            color: Colors
                                                                .white,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0, bottom: 6.0),
                                                child: Text(
                                                  chatModel.userProfile[index]
                                                      .profile.name,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              subtitle: Text(
                                                chatModel
                                                    .chatDocuments[index]['latestmessage'],
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                              onTap: () async {
                                                var snapshots;
                                                snapshots =
                                                await chatModel.getMessageNew(
                                                    chatModel
                                                        .chatDocuments[index]
                                                        .id);

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Chat(index, snapshots),
                                                  ),
                                                );
                                              }
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),
                            );
                          }
                        }
                    );
                  }
                }
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}





class Cache extends StatelessWidget{

  @override

  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final chatModel = Provider.of<ChatProvider>(context, listen: false);

    return Container(
      height: 120,
      child: SizedBox(
        height: 120,
        width: deviceWidth,
        child: ListView.builder(
          //横スクロールに変更
          scrollDirection: Axis.horizontal,
          itemCount: chatModel.userInMatchCache.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                  child: Stack(
                      children: [
                        Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            )
                        ),
                        Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: Image.network(
                                        chatModel.userInMatchCache[index].imagePath
                                    ).image
                                )
                            )
                        ),
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 15.0),
                  child: Text(
                    chatModel.userInMatchCache[index].profile.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}

class ChatFirstCache extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final chatModel = Provider.of<ChatProvider>(context, listen: false);

    return SizedBox(
        height: deviceHeight,
        width: deviceWidth,
      child: ListView.builder(
          itemCount: chatModel.userProfileCache.length,
          itemBuilder: (context, index) {
            print(index);
            return Container(
              height: 80,
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image(
                                fit: BoxFit.fill,
                                image: Image.network(
                                    chatModel.userProfileCache[index].imagePath
                                ).image,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    ),
                                  );
                                  // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                                },
                                errorBuilder: (context, error, stackTrace) => Container(color: Colors.white,),
                              )
                              ),
                            ),
                ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 6.0,bottom: 6.0),
                    child: Text(
                      chatModel.userProfileCache[index].profile.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    chatModel.chatDocuments[index]['latestmessage'],
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
              ),
            );
          }
          )
      );
  }

}

class ChatSecondCache extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final chatModel = Provider.of<ChatProvider>(context, listen: false);

    return SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: ListView.builder(
            itemCount: chatModel.userProfileCache.length,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                child: ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child:  SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                ),

                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 6.0,bottom: 6.0),
                      child: Text(
                        chatModel.userProfileCache[index].profile.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      chatModel.chatDocuments[index]['latestmessage'],
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                ),
              );
            }
        )
    );
  }

}
