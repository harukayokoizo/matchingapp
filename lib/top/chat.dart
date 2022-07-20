import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


import '../provider/chat_provider.dart';
import 'chat_profile.dart';

class Chat extends StatefulWidget {
  //　変数定義すると、UIのところから"widget.変数名" で呼ぶことができる。
  final int index;
  final List<dynamic> snapshots;

  const Chat(this.index,this.snapshots);

  // createState()　で"State"（Stateを継承したクラス）を返す
  @override
  ChatDetail createState() => ChatDetail();
}

class ChatDetail extends State<Chat> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  bool initial = true;
  ScrollController controller = ScrollController();
  List<dynamic> messageList = [];
  TextEditingController textController = TextEditingController();



  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatProvider>(context, listen: false);
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    final chatDocumentId = chatModel.chatDocuments[widget.index].id;


    if(initial) {
      messageList = List.from(widget.snapshots.reversed);
    }

    //addPostFrameCallback()は中身がウィジェットのビルドが完了した時に、実行される.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('llllllllllllllll');
        initial = false;
        print(controller.position.maxScrollExtent);
        controller.jumpTo(controller.position.maxScrollExtent);
      });


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            chatModel.newChat = [];
            Navigator.of(context).pop();
          },
        ),
        title: DisplayImage(widget.index),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              //「=>」は、メソッドや関数が「return文」だけの時に使います。
              onRefresh: () async{
                List<dynamic> messages;
                messages = await chatModel.refresh(widget.index,messageList[0]);
                messageList.insertAll(0, messages);
                setState(() {

                });
              },

              child: SingleChildScrollView(
                controller: controller,
                //常にスクロールを有効にする。
                //リストがない場合（スクロールできるほどない場合）でもスクロール可能にする
                physics: AlwaysScrollableScrollPhysics(),
                //reverse: true,
                child: Column(
                  children : [
                    if(messageList.isEmpty)
                      Container(),

                    if(messageList.isNotEmpty)
                          ListView.builder(
                          //リストのスクロールを無効にしている
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: messageList.length,
                              itemBuilder: (context,index) {
                              if (messageList[index]['sender'] == chatModel.myUserReference) {
                                  return Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(width: deviceWidth / 2),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .circular(20)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 15.0,
                                                    right: 15.0),
                                                child: Text(
                                                  messageList[index]['message'],
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right:8.0),
                                            child: DisplayImage(widget.index),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .circular(20)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 15.0,
                                                    right: 15.0),
                                                child: Text(
                                                  messageList[index]['message'],
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(width: deviceWidth / 2),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                            ),
                    StreamBuilder(
                      stream: fireStore.collection('chat')
                          .doc('$chatDocumentId')
                          .collection('message').orderBy('created', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context,snapshots){
                        if (snapshots.hasError) {
                          return const Text('Something went wrong');
                        }
                        //print('実行されているのか');
                        if (snapshots.connectionState == ConnectionState.waiting) {
                          return Container();
                        }

                        if (snapshots.data.metadata.hasPendingWrites) {
                          print('hasPendingWrites');
                          return Container();
                        }else{
                          print('hasPendingWrites,false');
                          if (snapshots.data.docs.length == 0) {
                            print('check');
                            return Container();
                          }
                          else if (messageList.isNotEmpty && messageList.last['created'] ==
                              snapshots.data.docs[0]['created']) {
                            print('a');
                            return ChatList();
                          } else if (chatModel.newChat.isEmpty) {
                            chatModel.newChat.add(snapshots.data.docs[0]);
                            print('b');
                            return ChatList();
                          } else if (chatModel.newChat.last['created'] !=
                              snapshots.data.docs[0]['created']) {
                            chatModel.newChat.add(snapshots.data.docs[0]);
                            print('c');
                            return ChatList();
                          } else {
                            print('d');
                            return ChatList();
                          }
                        }

                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: bottomSpace),
            child: Container(
              height: 80,
              width: deviceWidth,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt_outlined),
                    iconSize: 28,
                    color: Colors.white,
                    onPressed: (){

                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_outlined),
                    iconSize: 28,
                    color: Colors.white,
                    onPressed: (){

                    },
                  ),
                  Expanded(
                    child: Container(
                        height: 40,
                        //width: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: TextField(
                            controller: textController,
                            cursorHeight: 25,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                          ),
                          //autofocus: true,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                            onChanged: (value){
                            print(value);
                            chatModel.changeButton(value);
                            },
                      ),
                        )
                    ),
                  ),
                  Consumer<ChatProvider>(
                      builder: (context, model, _) {
                        print(model.change);
                        if(model.change == true) {
                          return IconButton(
                            icon: Icon(Icons.mic),
                            iconSize: 33,
                            color: Colors.white,
                            onPressed: () {

                            },
                          );
                        }else{
                          return IconButton(
                            icon: Icon(Icons.play_arrow),
                            iconSize: 33,
                            color: Colors.white,
                            onPressed: () {
                              print(textController.text);
                              chatModel.submitMessage(chatDocumentId);
                              textController.text = '';
                            },
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void useEffect(Null Function() Function() param0, List list) {}
}

class ChatList extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final chatModel = Provider.of<ChatProvider>(context, listen: false);
    final double deviceWidth = MediaQuery.of(context).size.width;


    return  ListView.builder(
          //リストのスクロールを無効にしている
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: chatModel.newChat.length,
            itemBuilder: (context,index) {
              if (chatModel.newChat[index]['sender'] == chatModel.myUserReference) {
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(width: deviceWidth / 2),
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius
                                    .circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: Text(
                                chatModel.newChat[index]['message'],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .start,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius
                                    .circular(20)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 15.0,
                                  right: 15.0),
                              child: Text(
                                chatModel.newChat[index]['message'],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(width: deviceWidth / 2),
                      ],
                    ),
                  ),
                );
              }
            }
        );

  }
}

class DisplayImage extends StatelessWidget{
  final int index;

  DisplayImage(this.index);
  @override


  Widget build(BuildContext context){
    final chatModel = Provider.of<ChatProvider>(context, listen: false);
    final chatDocumentId = chatModel.chatDocuments[index].id;
    final profile = chatModel.userProfile[index].profile;
    final userUid = chatModel.userProfile[index].documentId;
    var hobbies;
    var images;

    return InkWell(
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
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: Image.network(
                    chatModel.userProfile[index].imagePath,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      );
                      // You can use LinearProgressIndicator, CircularProgressIndicator, or a GIF instead
                    },
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.white,),
                  ).image
              )
          )
      ),
    );
  }

}