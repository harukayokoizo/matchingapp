import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:matching_app/hive/hive_type.dart';

import '../hive/hive_swipe.dart';
import '../model/swipe_user_model.dart';
import '../model/user_hobby.dart';
import '../model/user_image.dart';
import '../model/user_model.dart';
import '../model/user_type.dart';

class UserProvider extends ChangeNotifier {
  //QuerySnapshotは複数のドキュメントのデータを持つスナップショットである。
  // （複数のドキュメント（ユーザー）をリストとして取得している）
  //複数のドキュメントのデータを持つQuerySnapshotから実際にデータを取得する際には、
  // 一つ一つのドキュメントのデータを持つQueryDocumentSnapshotに対して操作を行う。
  List<dynamic> sameTypeUser = [];
  List<dynamic> sameTypeUserUid = [];
  List users = [];
  List<dynamic> localUidList = [];
  int type = 0;



  //fireStoreをインスタンス化
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  DocumentReference myUserReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid);



  //リストのドット表示のクラス
  void dotIndicator(PageController controller, ValueNotifier<int> currentPageNotifier){

      //現在のページの番号をnextに代入
      print(controller.page);
      int next = controller.page.round();

      if (currentPageNotifier.value != next) {
          currentPageNotifier.value = next;
      }
      print(currentPageNotifier.value);
  }












  Future<bool> getUser(String text)async{

    if(text == 'first') {
      await getMyType();
    }
    await getUidList(text);

    //userUid配列に同タイプのユーザーのuidを格納(userUid['E','D',・・・])
    await getUserUid(text);



    //users配列にuserModels（ユーザー情報）を格納（users['userModels','userModels'、・・・]）
    await getUserInfo();

    if(text == 'middle'){
      notifyListeners();
    }


    return true;
  }



  Future<void> getMyType() async{
    var box = await Hive.openBox('record');
    MyType myType = box.get('myTypeData');
    type = myType.type;
    print(type);
  }

  Future<void> getUidList(String text) async{
    List<String> list = [];
    var box = await Hive.openBox('swipeRecord');
    //中身リセットする際に下記コメントアウトを外す
    await box.put('mySwipeData',Swipe(list));
    var data = await box.get('mySwipeData');


    print(data.uidList);

    if(data != null){
      localUidList = data.uidList;
    }else{

    }

    if(data.uidList.contains(firebaseAuth.currentUser.uid)){

    }else{
      localUidList.add(firebaseAuth.currentUser.uid);
    }


    if(text == 'middle'){
      print(sameTypeUserUid);
      for(int i = 0; i < sameTypeUserUid.length; i++){
        localUidList.add(sameTypeUserUid[i]);
      }
    }

    print(data.uidList);

  }




  //同タイプのUserのuidを取得する
  Future<void> getUserUid(String text) async{
    QuerySnapshot userdata;
    UserTypeModel userTypeModels;
    sameTypeUser = [];
    sameTypeUserUid = [];

    //QuerySnapshotの型のデータを取得する
    userdata = await getSameTypeUser(text);


    //変数userDocumentはQueryDocumentSnapshotの型である
     userdata.docs.forEach((userDocument) {
      final Map<String,dynamic> user = userDocument.data();
      userTypeModels = UserTypeModel(
        userReference: user['reference'],
        uid: user['uid'],
      );
      sameTypeUser.add(userTypeModels);
      sameTypeUserUid.add(userTypeModels.uid);
    });

     print(sameTypeUser);
  }



  Future<QuerySnapshot> getSameTypeUser(String text) async{
    QuerySnapshot userdata;

    if(text == 'middle'){
      print(localUidList);
      userdata = await fireStore
          .collection('type')
          .where('type', isEqualTo: type)
          .where('uid', whereNotIn: localUidList)
          .limit(1)
          .get();
    }else{
      userdata = await fireStore
          .collection('type')
          .where('type', isEqualTo: type)
          .where('uid', whereNotIn: localUidList)
          .limit(2)
          .get();
    }


    print(userdata);
    return userdata;
  }









  //配列からユーザーの情報を取得
  Future<void> getUserInfo() async{
    UserModel userModel;
    UserHobbyModel userHobbyModel;
    UserImageModel userImageModel;
    SwipeUserModel swipeUserModel;

    List<UserHobbyModel> hobbies = [];
    List<UserImageModel> images = [];
    DocumentSnapshot userdata;
    QuerySnapshot userHobby;
    QuerySnapshot userImage;



    for(int i = 0; i < sameTypeUser.length;i++){
      hobbies = [];
      images = [];

      userdata = await sameTypeUser[i].userReference.get();

        userModel = UserModel(
          uid: userdata['uid'],
          age: userdata['age'],
          name: userdata['name'],
          sex: userdata['sex'],
          desc1: userdata['greet'],
        );

        userHobby = await getHobby(sameTypeUser[i].uid);

        userHobby.docs.forEach((userDocument) {
          final Map<String, dynamic> user = userDocument.data();
          userHobbyModel = UserHobbyModel(
            hobby: user['hobby'],
          );
          hobbies.add(userHobbyModel);
        });

        userImage = await getImage(sameTypeUser[i].uid);
        userImage.docs.forEach((userDocument) {
          final Map<String, dynamic> user = userDocument.data();
          userImageModel = UserImageModel(
            imagePath: user['imagePath'],
          );
          images.add(userImageModel);
        });

        swipeUserModel = SwipeUserModel(
          userModel: userModel,
          userHobbies: hobbies,
          userImages: images,
        );

        users.add(swipeUserModel);
      }

    print(users);

    }




  Future<QuerySnapshot> getHobby(String uid) async{
    QuerySnapshot getHobby;

    return getHobby = await fireStore
        .collection('user_hobby')
        .where('uid', isEqualTo: uid)
        .get();

  }


  Future<QuerySnapshot> getImage(String uid) async{
    QuerySnapshot getImage;

    return getImage = await fireStore
        .collection('user_image')
        .where('uid', isEqualTo: uid)
        .orderBy('created', descending: true)
        .get();

  }

  //画像をfireStorageからダウンロードする
   List imageDownload(final List list){
    UserImageModel imageUrl;
    List pageList= [];

    for(int i = 0;i < list.length;i++){
        imageUrl = list[i];
        print(imageUrl.imagePath);

        pageList.add(
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
              child: Image(
                image: Image.network(imageUrl.imagePath).image,
                //画像の大きさをWidgetに合わせる
                fit: BoxFit.fill,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    return child;
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.green,),
                      );
                    }
                  }

              ),
            )
        );
    }

    return pageList;

  }


























  //スワイプアクション時の処理実行メソッド
  Future<bool> judgeMatch(int index) async{
    bool judge = false;

    print('start');
    //対象のユーザーとマッチしているかどうかをチェック
    judge = await checkMatching(index);

    return judge;
  }


  Future<bool> checkMatching(int index)async{
    QuerySnapshot matchedUser;
    bool judgeMatching = false;

    matchedUser = await FirebaseFirestore.instance
        .collection('reaction')
        .where('to_user_id', isEqualTo: firebaseAuth.currentUser.uid)
        .where('from_user_id',isEqualTo: users[index].userModel.uid)
        .where('status', isEqualTo: 0)
        .get();

    if(matchedUser.docs.isNotEmpty == true){
      judgeMatching = true;
      updateReaction(matchedUser.docs[0].id);
    }else{
      judgeMatching = false;
    }

    return judgeMatching;
  }

  Future<void> updateReaction(String docId)async{
    var updated = FieldValue.serverTimestamp();

    await fireStore.collection('reaction')
        .doc(docId)
        .update({
          'match': 1,
          'updated': updated,
        });
  }

  //スワイプ時、対象のユーザーとスワイプのデータをFirestoreに保存する
  Future<void> editData(int index,String dire,bool judge)async{
    //reactionテーブルを更新する。
    inputReaction(index, dire, judge);

    //配列の最後のindexを指すWidgetをスワイプした場合のみ以下を実施
    if(index == users.length - 1) {
      print('lastUser');
      await resetArray(0);
    }
  }

  //reactionテーブルを更新する。
  Future<void> inputReaction(int index,String dire, bool judge)async{
    int status;
    int match;
    int chat = 0;
    var updated = FieldValue.serverTimestamp();

    if(dire == 'right'){
      //0: Like
      status = 0;
    }else if(dire == 'left'){
      //1: Nope
      status = 1;
    }

    if(judge == false){
      //0: NotMatch
      match = 0;
    }else if(judge == true){
      //1: Match
      match = 1;
    }


    await fireStore.collection('reaction').add({
      'to_user_id': users[index].userModel.uid,
      'from_user_id': firebaseAuth.currentUser.uid,
      //Firebaseのサーバーのシステム時刻を取得
      'status': status,
      'match': match,
      'chat': chat,
      'updated': updated,
    });
    print('inputReaction');
  }

  //すべての配列内のデータを初期化する。
  Future<void> resetArray(int ref)async{
    sameTypeUser = [];
    sameTypeUserUid = [];
    users = [];

    if(ref == 0) {
      notifyListeners();
    }
  }


  //スワイプ時の対象のユーザーのuidをローカルにリストとして保存する
  Future<void> swipeCompleted(int index) async{
    String uid;
    List<String> _uidList = ['Yamada'];

    var box = await Hive.openBox('swipeRecord');
    //box.put('mySwipeData',Swipe(_uidList));


    uid = users[index].userModel.uid;
    var data = await box.get('mySwipeData');
    //data.delete('mySwipeData');


    print(data.uidList);


    if(data != null){
      data.uidList.add(uid);
      await box.put('mySwipeData', Swipe(data.uidList));
    }else{
      _uidList.add(uid);
      await box.put('mySwipeData', Swipe(_uidList));
    }


  }

}
