import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:matching_app/hive/hive_type.dart';
import 'package:matching_app/provider/user_provider.dart';


class TypeProvider extends ChangeNotifier {
  int type = 0;
  String documentId;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool exitTypeFlag = false;
  bool confirmationFlag = false;

  DocumentReference myUserReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid);

  Future<void> inputTypeData(int typeLocal) async {
    type = typeLocal;
    var box = await Hive.openBox('record');

    await selectType();
    await box.put('myTypeData', MyType(type));

    confirmationFlag = false;

    notifyListeners();
  }

//出会う方法のタイプをfireStoreに登録するメソッド
  Future<void> selectType() async {
    var updated = FieldValue.serverTimestamp();

    await fireStore.collection('type').doc('${firebaseAuth.currentUser.uid}').set({
      'reference': myUserReference,
      'uid': firebaseAuth.currentUser.uid,
      'type': type,
      //Firebaseのサーバーのシステム時刻を取得
      'updated': updated,
    });
  }

  //自分が選択したタイプ情報が存在するかどうかの判定の結果を反映するメソッド
  Future<bool> exitMyType() async {
    DocumentSnapshot userMyType;
    bool exitType = true;

    userMyType = await FirebaseFirestore.instance
        .collection('type')
        .doc('${firebaseAuth.currentUser.uid}').get();

    print(userMyType.exists);

    if(userMyType.exists){
      exitTypeFlag = true;
    }else{
      exitTypeFlag = false;
    }

    confirmationFlag = true;

    exitType = userMyType.exists;
    return exitType;
  }



  Future<void> deleteFunction() async{
    var box = await Hive.openBox('record');
    var data = box.get('myTypeData');

    deleteMyType();

    box.delete('myTypeData');


    var boxs = await Hive.openBox('swipeRecord');
    var datas = await boxs.get('mySwipeData');
    boxs.delete('mySwipeData');
    //print(datas.uidList);



    exitTypeFlag = false;

    print('notifyListeners');
    notifyListeners();
  }



  //取得したタイプを削除する。
  Future<void> deleteMyType()async{
    print(documentId);
    await FirebaseFirestore.instance.collection('type').doc('${firebaseAuth.currentUser.uid}').delete();
  }
}