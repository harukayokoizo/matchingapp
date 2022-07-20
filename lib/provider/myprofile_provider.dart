import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matching_app/hive/hive_type.dart';
import 'package:matching_app/model/myprofile_model.dart';
import 'package:matching_app/top/top.dart';
import 'package:matching_app/user_set/user_name.dart';

import '../hive/hive_swipe.dart';
import '../model/user_hobby.dart';
import '../model/user_image.dart';
import '../model/user_model.dart';
import '../model/user_type.dart';


class MyProfileProvider extends ChangeNotifier {
  //画像のパスを保存する。
  io.File image1;
  UserImageModel userImageModel;
  UserHobbyModel userHobbyModel;
  MyProfileModel myProfileModel;
  List<dynamic> userHobbies = [];
  List<dynamic> userImages = [];
  List<dynamic> cacheHobbies = [];
  List<dynamic> cacheCacheHobbies = [];
  List<dynamic> queryHobbies = [];
  String errorMessage = "";
  String initialGreet;
  int index = 0;

  //fireStoreをインスタンス化
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //FireStorageをインスタンス化
  final FirebaseStorage storage=FirebaseStorage.instance;
  final myUid = FirebaseAuth.instance.currentUser.uid;

  DocumentReference myUserReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid);


  Future<void> getMyProfile()async{
    UserModel profileModel;
    DocumentSnapshot myProfile;
    QuerySnapshot myImages;

    //自分のプロフィールを取得し、myProfileに代入
    myProfile = await myUserReference.get();
    final Map<String, dynamic> doc = myProfile.data();
    profileModel = UserModel(
      name: doc['name'],
      desc1: doc['greet'],
      age: doc['age'],
      sex: doc['sex'],
    );

    initialGreet = profileModel.desc1;

    myImages = await fireStore
        .collection('user_image')
        .where('uid', isEqualTo: myUid)
        .orderBy('created', descending: false)
        .limit(1).get();

    myImages.docs.forEach((images) {
      final Map<String,dynamic> image = images.data();
      userImageModel = UserImageModel(
        imagePath: image['imagePath'],
      );
    });

    myProfileModel = MyProfileModel(
      myProfile: profileModel,
      mainImagePath: userImageModel.imagePath,
    );


  }


  Future<void> getImagesAndHobby()async{
    QuerySnapshot myImages;
    QuerySnapshot myHobbies;

    //初期化
    userImages = [];
    userHobbies = [];
    queryHobbies = [];

    myImages = await fireStore.collection('user_image')
        .where('uid', isEqualTo: myUid)
        .orderBy('created', descending: false)
        .get();

    myImages.docs.forEach((images) {
      final Map<String,dynamic> image = images.data();
      userImageModel = UserImageModel(
        imagePath: image['imagePath'],
        documentId: images.id,
      );
      userImages.add(userImageModel);
    });

    myHobbies = await fireStore.collection('user_hobby').where('uid', isEqualTo: myUid).get();

    myHobbies.docs.forEach((hobbies) {
      final Map<String,dynamic> hobby = hobbies.data();
      userHobbyModel = UserHobbyModel(
        hobby: hobby['hobby'],
      );
      userHobbies.add(userHobbyModel);
    });

    print(userHobbies);
  }

  Future<void> getHobbies()async{
    QuerySnapshot myHobbies;
    userHobbies = [];
    cacheHobbies = [];
    queryHobbies = [];

    myHobbies = await fireStore.collection('user_hobby').where('uid', isEqualTo: myUid).get();

    myHobbies.docs.forEach((hobbies) {
      final Map<String,dynamic> hobby = hobbies.data();
      userHobbyModel = UserHobbyModel(
        hobby: hobby['hobby'],
      );
      queryHobbies.add(hobbies);
      userHobbies.add(userHobbyModel);
      cacheHobbies.add(userHobbyModel.hobby);
    });


  }








  //画像を挿入したとき、画像設定画面に表示する
  Widget displayImage(int index){
    //画像が挿入されているとき（nullでない時）、画像を表示
    if(index < userImages.length && userImages[index] != null) {
      return Container(
        height:150,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
              userImages[index].imagePath,
              fit: BoxFit.cover,
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
        ),
      );
      //画像が何も挿入されていないとき（null）、白Containerを表示
    }else{
      return Container(
        height:150,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.white,
              width: 4
          ),
        ),
      );
    }
  }



  Future<void> uploadImage()async{
    print(1);
    //画像をアルバムから取得する。
    //その後、FireStorageに画像を保存する。
    await getImage();

    print(2);
    //画像のダウンロードURLを取得する。
    //その後、FireStoreに画像のリモートパスを保存する。
    await getDownloadUrl();
    print(3);

    //FireStoreに保存したドキュメントを取得し、配列に格納する。
    await getLatestImage();
    print(4);
  }




  //画像をアルバムから取得する。
  Future getImage() async {
    final picker = ImagePicker();

    XFile _image1 = await picker.pickImage(source: ImageSource.gallery);
    image1 = io.File(_image1.path);
    await uploadFile(image1);
  }


  //FireStorageに画像を保存する。
  Future<void> uploadFile(io.File image) async{
    io.File imageFile = image;
    Reference ref = storage.ref().child("images");  //保存するフォルダ
    print(imageFile);

    if(imageFile != null) {
      await ref.child(imageFile.toString()).putFile(imageFile);
    }
    print(100);
  }

  //画像のダウンロードURLを取得する。
  Future<void> getDownloadUrl() async{
    print(120);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef;

    imageRef = storage.ref().child('images/' + image1.toString());
    var image1Url = await imageRef.getDownloadURL();

    await inputUserImageData(image1Url);

  }

  //FireStoreに画像のリモートパスを保存する。
  Future inputUserImageData(var imageUrl) async {
    print(121);
    final userId = firebaseAuth.currentUser.uid;
    var created = FieldValue.serverTimestamp();
    var image;

    image = await fireStore.collection('user_image').add({
      'uid': userId,
      'imagePath': imageUrl,
      'created': created,
    });

  }

  Future<void> getLatestImage()async{
    print(1000);
    var query;
    query = await fireStore.collection('user_image')
        .where('uid', isEqualTo: myUid)
        .orderBy('created', descending: true)
        .limit(1)
        .get();

    query.docs.forEach((images) {
      final Map<String,dynamic> image = images.data();
      userImageModel = UserImageModel(
        imagePath: image['imagePath'],
        documentId: images.id,
      );
      userImages.add(userImageModel);
      print(userImageModel.imagePath);
    });

    print(userImages);

    notifyListeners();
  }

  Future<void> deleteImageCollection(int value)async{
    String documentId;

    documentId = userImages[value].documentId;

    if(userImages.length == 1){
      errorMessage = '※画像は1つ以上選んでください';
    }

    print(userImages);
    if(userImages.length != 1) {
      await fireStore.collection('user_image').doc('$documentId').delete();
      userImages.removeAt(value);
    }

    notifyListeners();

  }

  Future<void> updateProfile(String value)async{
    await fireStore
        .collection('users')
        .doc('$myUid')
        .update(
        {
          'greet': value,
        }
        );


    notifyListeners();
  }

  Future<void> updateHobby()async {
    List<int> remoteHobbies = [];

    for (int i = 0; i < userHobbies.length; i++) {
      remoteHobbies.add(userHobbies[i].hobby);
    }

    //remoteHobbiesは、保存中のHobby
    //cacheHobbiesは、選択中のHobby
    print(cacheHobbies);//[1,2,4,5]
    print(remoteHobbies);//[1,2,3,4,5]
    for (int i = 0; i < cacheHobbies.length; i++) {
      if (remoteHobbies.contains(cacheHobbies[i])) {
        //fireStoreに保存しない
      } else {
        await fireStore.collection('user_hobby').add({
          'uid': myUid,
          'hobby': cacheHobbies[i],
        });
      }
    }

    for (int i = 0; i < remoteHobbies.length; i++) {
      if (cacheHobbies.contains(remoteHobbies[i])) {
        //fireStoreに保存しない
      } else {
        await fireStore.collection('user_hobby')
            .doc('${queryHobbies[i].id}')
            .delete();
      }
    }

    await getHobbies();

    notifyListeners();

  }

}