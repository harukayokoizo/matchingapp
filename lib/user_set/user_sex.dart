import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:matching_app/test.dart';
import 'package:matching_app/user_set/user_age.dart';
import 'package:matching_app/user_set/user_hobby.dart';
import 'package:matching_app/user_set/user_name.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';

class SexSetting extends StatelessWidget {
  /*
  String name;
  SexSetting({Key key,this.name}) : super(key: key);
   */

  @override
  Widget build(BuildContext context) {
    int sex = 1;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final resultProvider = Provider.of<InitSetProvider>(context, listen: false);

    return Scaffold(
        body: Consumer<InitSetProvider>(
          builder: (context, model, _){
            return Column(
              children: [
                Container(
                  height: 170,
                  width: deviceWidth,
                  child: Stack(
                      children: [
                        Container(
                          height: 170,
                          width: deviceWidth,
                        ),
                        Positioned(
                          top: 30,
                          left: 0,
                          child: IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                size: 50,
                              ),
                              onPressed: (){
                                Navigator.pop(
                                  context,
                                  true,
                                );
                              }
                          ),
                        ),
                        Positioned(
                          left: deviceWidth/2 - 30,
                          top: 85,
                          child: Text(
                              "??????",
                              style: TextStyle(
                                color: Colors.white,
                                ///???????????????????????????
                                fontWeight: FontWeight.bold,
                                ///?????????????????????
                                fontSize: 30.0,
                                ///?????????????????????????????????
                              )),
                        ),
                      ]),
                ),
                Container(
                  height: 400,
                  width: deviceWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            shadowColor: Colors.white,
                            minimumSize: Size(250, 70), //(????????????)
                            side: BorderSide(color: Colors.white, width: 2),
                            backgroundColor: model.isPressed1 ? Theme.of(context).scaffoldBackgroundColor : Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "??????",
                            style: TextStyle(
                              fontSize: 27,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            sex = 0;
                            model.inputSexData(sex);
                            model.changeColor1();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shadowColor: Colors.white,
                            minimumSize: Size(250, 70), //(????????????)
                            side: BorderSide(
                                color: model.isPressed1 ? Colors.white : Colors.white,
                                width: 2
                            ),
                            backgroundColor: model.isPressed2 ? Theme.of(context).scaffoldBackgroundColor : Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "??????",
                            style: TextStyle(
                              fontSize: 27,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            sex = 1;
                            model.inputSexData(sex);
                            model.changeColor2();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 300,
                    width: deviceWidth,
                    child: FittedBox(
                      child: GestureDetector(
                        ///?????????????????????
                        onTap: () {
                          print(model.sex);

                          if(model.sex != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AgeSetting();
                                },
                              ),
                            );
                          }
                        },

                        ///????????????????????????????????????
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 100.0, right: 100.0,bottom: 70),
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),

                            ///padding?????????????????????????????????????????????
                            padding: EdgeInsets.symmetric(horizontal: 130, vertical: 6),

                            ///?????????????????????????????????
                            decoration: BoxDecoration(

                              ///box??????????????????????????????
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.orange),

                            ///box?????????????????????????????????
                            child: Text(
                              "??????",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },

        )
    );
    }
  }
