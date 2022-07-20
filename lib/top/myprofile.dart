import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/top/setting.dart';
import 'package:provider/provider.dart';

import '../loginpage.dart';
import '../provider/myprofile_provider.dart';
import '../utils/authentication.dart';
import 'edit_profile.dart';

class MyProfile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final profileModel = Provider.of<MyProfileProvider>(context, listen: false);

    if(profileModel.myProfileModel != null){
      return MyProfileDisplay();
    }else{
      return GetMyProfile();
    }

  }
}

class GetMyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileModel = Provider.of<MyProfileProvider>(context, listen: true);

    return FutureBuilder(
        future: profileModel.getMyProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
          return Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.green,
              )
          );
          }
          return MyProfileDisplay();
        }
    );
  }
}

class MyProfileDisplay extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    final profileModel = Provider.of<MyProfileProvider>(context, listen: false);
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    print(20);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0,bottom: 10.0),
              child: Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.network(profileModel.myProfileModel.mainImagePath).image
                      )
                  )
              ),
            ),
            Container(
              width: deviceWidth,
              child: Center(
                child: Text(
                  '${profileModel.myProfileModel.myProfile.name}  ${profileModel.myProfileModel.myProfile.age}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, bottom: 80.0),
                    child: InkWell(
                      child: Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white12,
                                  blurRadius: 10.0,//影の濃さ
                                  spreadRadius: 20.0,//影の広さ（大きさ）
                                  offset: Offset(0, 0))//影の位置(x軸,y軸)

                            ],
                          ),
                        child: Icon(
                          Icons.settings,
                          size: 30,
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Setting(),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0, bottom: 80.0),
                    child: InkWell(
                      child: Container(
                          width: 90.0,
                          height: 90.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white12,
                                  blurRadius: 10.0,//影の濃さ
                                  spreadRadius: 20.0,//影の広さ（大きさ）
                                  offset: Offset(0, 0))//影の位置(x軸,y軸)

                            ],

                          ),
                        child: Icon(
                            Icons.edit,
                          size: 30,
                        ),
                      ),
                      highlightColor: null,
                      onTap: ()async{
                        await profileModel.getImagesAndHobby();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfile(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ]
      ),
    );
  }
}