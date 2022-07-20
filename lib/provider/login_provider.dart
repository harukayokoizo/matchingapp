import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginProvider extends ChangeNotifier {
  //fireStoreをインスタンス化
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  DocumentSnapshot myProfile;
  bool exit = true;



  //自分のユーザー情報を取得するメソッド
  Future<void> getMyUser() async{
    print(4.5);
    //firebaseAuth.currentUser.uid
    myProfile = await fireStore.collection('users').doc(firebaseAuth.currentUser.uid).get();

    if(myProfile.exists){
      exit = true;
    }else{
      exit = false;
    }
    notifyListeners();
  }

  Future<bool> nextPageJudge() async{
    bool exit = true;
    myProfile = await fireStore.collection('users').doc('n').get();

    if(myProfile.exists){
      exit = true;
    }else{
      exit = false;
    }

    return exit;
  }
}