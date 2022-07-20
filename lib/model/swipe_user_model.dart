//import 'dart:html';

import 'package:matching_app/model/user_hobby.dart';
import 'package:matching_app/model/user_image.dart';
import 'package:matching_app/model/user_model.dart';
import 'package:matching_app/user_set/user_sex.dart';

class SwipeUserModel{
  UserModel userModel;
  List<UserHobbyModel> userHobbies;
  List<UserImageModel> userImages;


  SwipeUserModel({
    this.userModel,
    this.userHobbies,
    this.userImages,
  });
}