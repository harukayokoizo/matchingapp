import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../hive/hive_database.dart';
import '../model/user_image.dart';

class InitSetProvider extends ChangeNotifier {
  String name;
  String age;
  String greet;
  int sex;

  //画像のパスを保存する。
  io.File image;
  List imageList = [];
  List<int> list = [];
  UserImageModel userImageModel;
  List<dynamic> userImages = [];
  List<dynamic> cacheHobbies = [];

  bool isPressed1 = true;
  bool isPressed2 = true;

  //FirebaseAuthをインスタンス化する
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //FireStoreをインスタンス化する
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  //FireStorageをインスタンス化
  final FirebaseStorage storage=FirebaseStorage.instance;

  final myUid = FirebaseAuth.instance.currentUser.uid;

  //FirestoreとHiveのDatabaseにデータを保存する。
  Future<void> inputData()async{
    var box = await Hive.openBox('personRecord');
    await inputUserData();
    await inputUserHobbyData();
    await inputUserImageData();

    await box.put('myData', Person(name, age, greet, sex));

    return 0;
  }


  //FireStoreにUserデータを保存する。
  Future inputUserData() async {
    final userId = _firebaseAuth.currentUser.uid;

    await fireStore.collection('users').doc(userId).set({
      'uid' : userId,
      'name' : name,
      'age' : age,
      'greet' : greet,
      'sex' : sex,
    });
    notifyListeners();
  }


  //FireStoreに画像のリモートパスを保存する。
  Future inputUserImageData() async {
    print(121);
    final userId = _firebaseAuth.currentUser.uid;
    var created = FieldValue.serverTimestamp();
    var image;
    print(userImages);

    for(int i = 0;i < userImages.length; i++) {
      image = await fireStore.collection('user_image').add({
        'uid': userId,
        'imagePath':userImages[i].imagePath,
        'created': created,
      });
    }
  }

  //FireStoreに趣味を保存する。
  Future inputUserHobbyData() async {
    final userId = _firebaseAuth.currentUser.uid;

    for(int i = 0; i < cacheHobbies.length; i++){
      await fireStore.collection('user_hobby').add({
        'uid' : userId,
        'hobby': cacheHobbies[i],
      });
    }
    notifyListeners();
  }

  //性別（男性）の色を変える。
  void changeColor1(){
    this.isPressed1 = false;
    if(isPressed2 == false){
      isPressed2 = true;
    }
    notifyListeners();
  }

  //性別（女性）の色を変える。
  void changeColor2(){
    this.isPressed2 = false;
    if(isPressed1 == false){
      isPressed1 = true;
    }
    notifyListeners();
  }


  //名前の状態を保存する
  void inputNameData(value){
    this.name = value;
    notifyListeners();
  }

  //性別の状態を保存する
  void inputSexData(value){
    this.sex = value;
    notifyListeners();
  }

  //年齢の状態を保存する
  void inputAgeData(value){
    this.age = value;
    notifyListeners();
  }

  //あいさつの状態を保存する
  void inputGreetData(value){
    this.greet = value;
    notifyListeners();
  }


  //cacheHobbies配列にチェックを入れたhobbyを挿入
  void addOrRemoveHobbyData(int number){
    if(cacheHobbies.length < 5){
      if(cacheHobbies.contains(number)){
        cacheHobbies.remove(number);
      }else{
        cacheHobbies.add(number);
      }
    }else{
      if(cacheHobbies.contains(number)){
        cacheHobbies.remove(number);
      }else{

      }
    }

    notifyListeners();
  }





  //画像を挿入したとき、画像設定画面に表示する
  Widget displayImage(int index){
    //画像が挿入されているとき（nullでない時）、画像を表示
    if(index < imageList.length && imageList[index] != null) {
      return Container(
        height:150,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
              imageList[index],
              fit: BoxFit.cover,
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






  //プラスボタンの押下した際の処理
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

  }




  //画像をアルバムから取得する。
  Future getImage() async {
    final picker = ImagePicker();

    XFile _image1 = await picker.pickImage(source: ImageSource.gallery);
    image = io.File(_image1.path);

    print(image);
    imageList.add(image);

    notifyListeners();

    await uploadFile(image);
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

    imageRef = storage.ref().child('images/' + image.toString());
    var imageUrl = await imageRef.getDownloadURL();

    //配列にぶち込む
    userImageModel = UserImageModel(
      imagePath: imageUrl,
    );

    userImages.add(userImageModel);
    print(userImages);

  }


  void removeImage(int value) {
    io.File image = imageList[value];
    imageList.removeAt(value);
    userImages.removeAt(value);

    notifyListeners();
    removeFile(image);


  }

  //FireStorageから画像を削除する。
  Future<void> removeFile(io.File image) async{
    io.File imageFile = image;
    Reference ref = storage.ref().child("images"); //保存するフォルダ
    Reference imageRef = ref.child(imageFile.toString());

    if(imageFile != null) {
      await imageRef.delete();
    }
  }


}