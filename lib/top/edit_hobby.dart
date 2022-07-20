import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../code/code_list.dart';
import '../provider/myprofile_provider.dart';

class EditHobby extends StatefulWidget{

  @override
  EditHobbyState createState() => EditHobbyState();
}
class EditHobbyState extends State<EditHobby>{
  final hobbyCode = new HobbyCode();
  @override

  Widget build(BuildContext context) {
    int index = 1;
    final profileModel = Provider.of<MyProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '趣味',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
                '完了',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            onPressed: () async{
              await profileModel.updateHobby();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for(int i = 0; i < 10;i++)
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, top: 16.0, right: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  for(int j = 1; j < 4; j++)
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shadowColor: Colors.white,
                            minimumSize: Size(100, 40),
                            backgroundColor: profileModel.cacheHobbies.contains(index) ? Colors.orange : Colors.black,//(横、高さ)
                            side: BorderSide(
                                color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "${hobbyCode.hobbyList[index++]}",
                            style: TextStyle(
                              fontSize: 20,
                              color: profileModel.cacheHobbies.contains(index) ? Colors.white : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            int number = (i * 3) + j;

                            if(profileModel.cacheHobbies.length < 5) {
                              if (profileModel.cacheHobbies.contains(number)) {
                                profileModel.cacheHobbies.remove(number);
                              } else {
                                print(1);
                                profileModel.cacheHobbies.add(number);
                              }

                              print(profileModel.cacheHobbies);
                              setState(() {});
                            }else{
                              if (profileModel.cacheHobbies.contains(number)) {
                                profileModel.cacheHobbies.remove(number);
                              } else {

                              }
                              setState(() {});
                            }
                          },
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      )

    );
  }

}