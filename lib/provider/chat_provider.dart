import 'dart:async';


import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/model/chat_model.dart';
import 'package:matching_app/model/user_model.dart';


class ChatProvider extends ChangeNotifier {
  //マッチ下のユーザー
  List<dynamic> userInMatch = [];//マッチ中の相手ユーザーのプロフィールを保存

  //マッチ下のユーザーのメモリキャッシュ
  List<dynamic> userInMatchCache = [];



  //メッセージ下のユーザー
  List<dynamic> chatDocuments = [];
  List<dynamic> matchUser = [];//各chatルームの相手ユーザーのリファレンス先を配列に保存
  List<dynamic> userProfile = [];//各chatルームの相手ユーザーのプロフィールを配列に保存


  //メッセージ下のユーザーのメモリキャッシュ
  List<dynamic> chatDocumentsCache = [];
  List<dynamic> matchUserCache = [];
  List<dynamic> userProfileCache = [];



  //メッセージ内
  List<dynamic> newChat = [];





  bool judge = true;
  bool change = true;
  String message;


  //fireStoreをインスタンス化
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AsyncMemoizer memoizer= AsyncMemoizer();

  DocumentReference myUserReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid);
  DocumentReference matchUserReference;



  //取得したマッチ中のユーザーのユーザープロフィールをリファレンスを取得
  Future<void> getImageFlow(List<dynamic> docs) async{
    UserModelInChat userModelInChat;
    UserModel userModel;
    var partnerReference;


    for(int index = 0; index < docs.length; index++) {
      partnerReference = docs[index]['to_user_id'];
      print(docs[index]['to_user_id']);
      var doc = await partnerReference.get();
      userModel = UserModel(
          uid: doc['uid'],
          name: doc['name'],
          sex: doc['sex'],
          age: doc['age'],
          desc1: doc['greet']
      );

      var mainImage = await fireStore.collection('user_image').where('uid',isEqualTo: doc.id).limit(1).get();

      userModelInChat = UserModelInChat(
          profile: userModel,
          imagePath: mainImage.docs[0]['imagePath'],
          documentId: doc.id
      );

      userInMatch.add(userModelInChat);
    }

    userInMatchCache = userInMatch;


  }





  //各チャットルームから相手ユーザーのリファレンスを取得する
  //matchUser,matchUserCacheに各ユーザーのリファレンスを保存する。
  void getReference(){
    List<dynamic> list = [];
    for(int i = 0; i < chatDocuments.length; i++){
      list = chatDocuments[i]['users'];
      list.remove(myUserReference);
      matchUserReference = list.removeLast();
      matchUser.add(matchUserReference);
    }
    matchUserCache = matchUser;
  }


  //相手ユーザーのリファレンスからプロフィールとImageドキュメントを取得する。
  Future<void> getUserDocumentAndImage() async{
    UserModelInChat userModelInChat;
    UserModel userModel;
    QuerySnapshot mainImage;
    bool now;
    judge = !judge;
    userProfile = [];
    now = judge;

    for(int index = 0; index < matchUser.length; index++){
      if(now != judge) {
        userProfile = [];
        break;
      }else{
        //各ユーザーのプロフィールを取得する。
        var doc = await matchUser[index].get();
        userModel = UserModel(
          uid: doc['uid'],
          name: doc['name'],
          sex: doc['sex'],
          age: doc['age'],
          desc1: doc['greet']
        );

        mainImage = await fireStore
            .collection('user_image')
            .where('uid', isEqualTo: doc.id)
            .limit(1)
            .get();


        userModelInChat = UserModelInChat(
          profile: userModel,
          imagePath: mainImage.docs[0]['imagePath'],
          documentId: doc.id
        );

        userProfile.add(userModelInChat);
      }
    }
  }








  //該当するルームのメッセージを20件取得する
  Future<List<dynamic>> getMessageNew(var chatDocumentId)async{
    var snapshots;
    List<dynamic> messageDocuments = [];
    snapshots = await fireStore.collection('chat')
          .doc('$chatDocumentId')
          .collection('message').orderBy('created', descending: true)
          .limit(2).get();

    snapshots.docs.forEach((chatDocument) {
      final Map<String,dynamic> user = chatDocument.data();
      messageDocuments.add(user);
    });

    print(snapshots);

    return messageDocuments;
  }


  //該当するルームの相手の趣味を取得する。
  Future<List<dynamic>> getHobby(var uid)async{
    List<dynamic> userHobbies = [];
    var userHobby;
    print(uid);

    userHobby = await fireStore.collection('user_hobby').where('uid',isEqualTo: uid).get();
    print(userHobby);

    userHobby.docs.forEach((hobbies){
      final Map<String,dynamic> hobby = hobbies.data();
      userHobbies.add(hobby);
    });
    print(userHobbies);
    return userHobbies;
  }



  //該当するルームの相手の画像をすべて取得する。
  Future<List<dynamic>> getAllImage(var uid)async{
    List<dynamic> userImages = [];
    var userImage;
    print(uid);

    userImage = await fireStore.collection('user_image').where('uid',isEqualTo: uid).get();
    print(userImage);

    userImage.docs.forEach((images){
      final Map<String,dynamic> image = images.data();
      userImages.add(image);
    });
    print(userImages);
    return userImages;
  }



  //マッチ下のユーザーの「チャットを始める」ボタン押下時の処理
  //reactionコレクションを更新する。
  Future<void> chatStart(var doc)async{
    var updated = FieldValue.serverTimestamp();
    var reaction = await fireStore.collection('reaction')
        .where('from_user_id',isEqualTo: doc['to_user_id'])
        .where('to_user_id',isEqualTo: doc['from_user_id']).get();

    var docId = reaction.docs[0];

    await fireStore
        .collection('reaction')
        .doc('${doc.id}')
        .update({'chat': 1, 'updated': updated,});

    await fireStore
        .collection('reaction')
        .doc('${docId.id}')
        .update({'chat': 1, 'updated': updated,});
  }



  //chatルームを作成する。
  Future<void> chatCreate(var doc)async{
    var updated = FieldValue.serverTimestamp();

    await fireStore
        .collection('chat')
        .add(
        {
          'latestmessage': "",
          'updated': updated,
          'users' :[
            doc['from_user_id'],
            doc['to_user_id']
          ],
        }
        );

  }


  //送信ボタンに表示切替をする。
  void changeButton(var value){
    if(value == ""){
      change = true;
      message = value;
      notifyListeners();
    }else{
      change = false;
      message = value;
      notifyListeners();
    }
  }


  //送信ボタン押下時の処理
  Future<void> submitMessage(String chatDocumentId) async{
    await updateChatCollection(chatDocumentId);
    await updateMessageCollection(chatDocumentId);
  }


  //chatコレクションを更新する。
  Future<void> updateChatCollection(String chatDocumentId)async{
    var updated = FieldValue.serverTimestamp();

    await fireStore
        .collection('chat')
        .doc('$chatDocumentId')
        .update(
        {
          'latestmessage': message,
          'updated': updated,
        }
    );
  }


  //メッセージコレクションを更新する。
  Future<void> updateMessageCollection(String chatDocumentId)async{
    var createdAt = FieldValue.serverTimestamp();
    var messageCollection = fireStore..collection('chat').doc('$chatDocumentId').collection('message');

    fireStore
        .collection('chat')
        .doc('$chatDocumentId')
        .collection('message')
        .add(
        {
          'message': message,
          'created': createdAt,// DateTime.now(),
          'sender': myUserReference,
        }
        );
  }




  //該当するリストを削除する。
  Future<void> chatDelete(var deleteDocument)async{
    await fireStore.collection('chat').doc('$deleteDocument').delete();
  }



  //スクロールで過去メッセージ取得
  Future<List<dynamic>> refresh(int chatDocumentIndex ,var oldestDocument)async{
    var created = oldestDocument['created'];
    var chatDocumentId = chatDocuments[chatDocumentIndex].id;
    List<dynamic> messageDocuments = [];
    var snapshots;

    snapshots = await fireStore.collection('chat')
        .doc('$chatDocumentId')
        .collection('message')
        .where('created', isLessThan: created)
        .orderBy('created', descending: true)
        .limit(2).get();


    snapshots.docs.forEach((messageDocument) {
    final Map<String,dynamic> message = messageDocument.data();
    messageDocuments.add(message);
    });

    messageDocuments = List.from(messageDocuments.reversed);
    print(messageDocuments);

    return messageDocuments;
  }
}