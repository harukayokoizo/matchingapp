//import 'dart:html';

import 'package:matching_app/user_set/user_sex.dart';

class UserModel{
  String uid;
  String name;
  //あいさつ文保存用
  String desc1;
  //自己紹介文保存用
  String desc2;
  List hobby;
  int sex;
  //一旦、誕生日ではなく年齢を入力してもらう
  String age;


  UserModel({
    this.uid,
    this.name,
    this.desc1,
    this.desc2,
    this.hobby,
    this.sex,
    this.age,
  });
}