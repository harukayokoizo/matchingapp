import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/top/show_dialog.dart';
import 'package:provider/provider.dart';

import '../code/code_list.dart';
import '../provider/myprofile_provider.dart';
import 'edit_hobby.dart';

class EditProfile extends StatelessWidget{
  final hobbyCode = new HobbyCode();

  @override

  Widget build(BuildContext context){
    final profileModel = Provider.of<MyProfileProvider>(context, listen: false);
    final TextEditingController controller = TextEditingController(text: profileModel.myProfileModel.myProfile.desc1.replaceAll('\\n', '\n'),);
    final double deviceWidth = MediaQuery.of(context).size.width;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );




    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async{
            print(controller.text);
            profileModel.errorMessage = "";
            if(profileModel.initialGreet != controller.text) {
              await profileModel.updateProfile(controller.text);
            }
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'プロフィール編集',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 420,
                width: deviceWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 21),
                  child: Consumer<MyProfileProvider>(
                      builder: (context, imageModel, _) {
                        print('再描画');
                        print(profileModel.errorMessage);
                        print(imageModel.userImages);
                        return Column(
                          children: [
                            Row(
                              children: [
                                Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180,
                                        width: 125,
                                      ),
                                      Positioned(
                                        top: 30,
                                        child: imageModel.displayImage(0),
                                      ),
                                      if(0 < imageModel.userImages.length && imageModel.userImages[0].imagePath != null)
                                      Positioned(
                                          top: 5,
                                          left: 75,
                                          //プラスボタンのフォーマット
                                          child: Container(
                                            width: 40.0,
                                            child: SwitchButton(0)
                                          ),
                                      ),
                                      if(0 >= imageModel.userImages.length)
                                        Positioned(
                                          top: 5,
                                          left: 75,
                                          //プラスボタンのフォーマット
                                          child: Container(
                                            width: 40.0,
                                            child: FloatingActionButton(
                                              //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                              heroTag: "btn"+"7",
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.black,
                                              onPressed: () async{
                                                profileModel.errorMessage = "";
                                                await imageModel.uploadImage();
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),

                                    ]
                                ),
                                Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180,
                                        width: 125,
                                      ),
                                      Positioned(
                                        top: 30,
                                        child: imageModel.displayImage(1),
                                      ),
                                      if(1 < imageModel.userImages.length && imageModel.userImages[1].imagePath != null)
                                      Positioned(
                                          top: 5,
                                          left: 75,
                                          child: Container(
                                            width: 40.0,
                                            child: SwitchButton(1),
                                          )
                                      ),
                                      if(1 >= imageModel.userImages.length)
                                        Positioned(
                                          top: 5,
                                          left: 75,
                                          //プラスボタンのフォーマット
                                          child: Container(
                                            width: 40.0,
                                            child: FloatingActionButton(
                                              //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                              heroTag: "btn"+"8",
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.black,
                                              onPressed: () async{
                                                profileModel.errorMessage = "";
                                                await imageModel.uploadImage();
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                    ]
                                ),
                                Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180,
                                        width: 121,
                                      ),
                                      Positioned(
                                        top: 30,
                                        child: imageModel.displayImage(2),
                                      ),
                                      if(2 < imageModel.userImages.length && imageModel.userImages[2].imagePath != null)
                                        Positioned(
                                            top: 5,
                                            left: 75,
                                            child: Container(
                                              width: 40.0,
                                              child: SwitchButton(2),
                                            )
                                        ),
                                      if(2 >= imageModel.userImages.length)
                                        Positioned(
                                          top: 5,
                                          left: 75,
                                          //プラスボタンのフォーマット
                                          child: Container(
                                            width: 40.0,
                                            child: FloatingActionButton(
                                              //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                              heroTag: "btn"+"9",
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.black,
                                              onPressed: () async{
                                                profileModel.errorMessage = "";
                                                await imageModel.uploadImage();
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                    ]
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180,
                                        width: 125,
                                      ),
                                      Positioned(
                                        top: 30,
                                        child: imageModel.displayImage(3),
                                      ),
                                      if(3 < imageModel.userImages.length && imageModel.userImages[3].imagePath != null)
                                        Positioned(
                                            top: 5,
                                            left: 75,
                                            child: Container(
                                              width: 40.0,
                                              child: SwitchButton(3),
                                            )
                                        ),
                                      if(3 >= imageModel.userImages.length)
                                        Positioned(
                                          top: 5,
                                          left: 75,
                                          //プラスボタンのフォーマット
                                          child: Container(
                                            width: 40.0,
                                            child: FloatingActionButton(
                                              //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                              heroTag: "btn"+"10",
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.black,
                                              onPressed: () async{
                                                profileModel.errorMessage = "";
                                                await imageModel.uploadImage();
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                    ]
                                ),
                                Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180,
                                        width: 125,
                                      ),
                                      Positioned(
                                        top: 30,
                                        child: imageModel.displayImage(4),
                                      ),
                                      if(4 < imageModel.userImages.length && imageModel.userImages[4].imagePath != null)
                                        Positioned(
                                            top: 5,
                                            left: 75,
                                            child: Container(
                                              width: 40.0,
                                              child: SwitchButton(4),
                                            )
                                        ),
                                      if(4 >= imageModel.userImages.length)
                                        Positioned(
                                          top: 5,
                                          left: 75,
                                          //プラスボタンのフォーマット
                                          child: Container(
                                            width: 40.0,
                                            child: FloatingActionButton(
                                              //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                              heroTag: "btn"+"11",
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.black,
                                              onPressed: () async{
                                                profileModel.errorMessage = "";
                                                await imageModel.uploadImage();
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                    ]
                                ),
                                Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 180,
                                        width: 121,
                                      ),
                                      Positioned(
                                        top: 30,
                                        child: imageModel.displayImage(5),
                                      ),
                                      if(5 < imageModel.userImages.length && imageModel.userImages[5].imagePath != null)
                                        Positioned(
                                            top: 5,
                                            left: 75,
                                            child: Container(
                                              width: 40.0,
                                              child: SwitchButton(5),
                                            )
                                        ),
                                      if(5 >= imageModel.userImages.length)
                                        Positioned(
                                          top: 5,
                                          left: 75,
                                          //プラスボタンのフォーマット
                                          child: Container(
                                            width: 40.0,
                                            child: FloatingActionButton(
                                              //１画面に複数のFloatingActionButtonを持たせたい場合、各ボタンにheroTagを追加する。
                                              heroTag: "btn"+"12",
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.black,
                                              onPressed: () async{
                                                profileModel.errorMessage = "";
                                                await imageModel.uploadImage();
                                              },
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                    ]
                                ),
                              ],
                            ),
                            if(profileModel.errorMessage != "")
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                        '${profileModel.errorMessage}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      }
                      ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 20.0,bottom: 10.0),
                child: Container(
                  child: Text(
                      'あいさつ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              TextFormField(
                minLines: 2,
                maxLines: 6,
                maxLength: 50,
                controller: controller,
                style: TextStyle(
                  color: Color(0xff696969),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  counterStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                      borderRadius: BorderRadius.zero
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.zero
                  ),
                  ),

                onChanged: (value){
                  print(value);
                  profileModel.myProfileModel.myProfile.desc1 = value;
                },
                ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 20.0,bottom: 10.0),
                child: Container(
                  child: Text(
                    '趣味',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            Consumer<MyProfileProvider>(
                builder: (context, hobbyModel, _) {
                  return InkWell(
                      onTap: ()async{
                        profileModel.errorMessage = "";
                        await profileModel.getHobbies();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditHobby(),
                          ),
                        );
                      },
                    child: Container(
                      height: 60,
                      width: deviceWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 0.0,
                                maxWidth: 300.0,
                                minHeight: 30.0,
                                maxHeight: 60.0,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    for (int i = 0; i<hobbyModel.userHobbies.length; i++)
                                      TextSpan(
                                        children: [
                                          if(i == hobbyModel.userHobbies.length - 1)
                                          TextSpan(
                                            text: '${hobbyCode.hobbyList[hobbyModel.userHobbies[i].hobby]}',
                                            style: TextStyle(color: Colors.grey, fontSize: 18),
                                          ),
                                          if(i != hobbyModel.userHobbies.length - 1)
                                            TextSpan(
                                              text: '${hobbyCode.hobbyList[hobbyModel.userHobbies[i].hobby]},',
                                              style: TextStyle(color: Colors.grey, fontSize: 18),
                                            ),
                                        ],

                                      ),
                                    ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(
                                Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  );
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20.0,bottom: 10.0),
                child: Container(
                  child: Text(
                    '仕事',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                width: deviceWidth,
                color: Colors.white,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.zero
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20.0,bottom: 10.0),
                child: Container(
                  child: Text(
                    '住んでいるエリア',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: InkWell(
                    onTap: (){
                      /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditHobby(),
                        ),
                      );
                      */
                    },
                    child: Container(
                      height: 60,
                      width: deviceWidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              '住んでいるエリア',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}