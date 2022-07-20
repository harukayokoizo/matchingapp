import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../code/code_list.dart';
import '../provider/user_provider.dart';
import '../test.dart';

class ForwardCard extends StatelessWidget{
  final int index;
  //imagePage配列[ClipRRect(BorderRadius.circular(25.0)), ClipRRect(BorderRadius.circular(25.0))]
  final PageController controller = PageController(initialPage: 0);
  final currentPageNotifier = ValueNotifier<int>(0);
  final hobbyCode = new HobbyCode();

  ForwardCard(this.index);
  @override



  Widget build(BuildContext context) {
    print('forword');
    List imagePage = [];
    final model = Provider.of<UserProvider>(context, listen: false);
    imagePage = model.imageDownload(model.users[index].userImages);

    print(imagePage);

    return Center(
            child: Stack(
              children: [
                Container(
                  width: 350,
                  height: 550,
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    //border: Border.all(color: kBackgroundColor, width: 5),
                    borderRadius: BorderRadius.circular(25),
                  ),

                ),
                Container(
                  width: 350,
                  height: 550,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange, width: 3),

                    ///boxの角の丸みを指定する
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: PageView.builder(
                    //スクロールを無効にする
                    physics: NeverScrollableScrollPhysics(),

                    //controllerを定義することにより、別個所からの応答を受ける
                    controller: controller,
                    onPageChanged: (i){
                      print(10);
                      model.dotIndicator(controller,currentPageNotifier);
                      },

                    itemBuilder: (context, i) {
                      return imagePage[i];
                    },
                    itemCount: imagePage.length,
                  ),
                ),
                if(imagePage.length > 1)
                Positioned(
                  top: 20,
                  right: 100,
                  left: 100,
                  child: Container(
                    height: 50.0,
                    child: CirclePageIndicator(
                      size: 10,
                      selectedSize: 20,
                      dotColor: Colors.black,
                      selectedDotColor: Colors.orange,
                      borderColor: Colors.white,
                      selectedBorderColor: Colors.white,
                      itemCount: imagePage.length,
                      currentPageNotifier: currentPageNotifier,
                    ),

                  ),
                ),
                Positioned(
                  bottom: 0,
                  child:Container(
                    width: 350,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                    ),
                  )
                ),
                Positioned(
                  left: 25,
                  bottom: 170,
                  child: Text(
                      model.users[index].userModel.name,
                      style: TextStyle(
                        color: Colors.white,

                        ///文字の色を白にする
                        fontWeight: FontWeight.bold,

                        ///文字を太字する
                        fontSize: 30.0,
                      )
                  ),
                ),
                Positioned(
                  left: 135,
                  bottom: 170,
                  child: Text(
                      model.users[index].userModel.age,
                      style: TextStyle(
                        color: Colors.white,

                        ///文字の色を白にする
                        fontWeight: FontWeight.bold,

                        ///文字を太字する
                        fontSize: 30.0,
                      )
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 120,
                  child: Container(
                    child: Row(
                      children: [
                        for(int i = 0; i < model.users[index].userHobbies.length;i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: 80,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                border: Border.all(color: Colors.orange,
                                    width: 2),

                                ///boxの角の丸みを指定する
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                hobbyCode.hobbyList[model.users[index].userHobbies[i].hobby],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  bottom: 60,
                  child: Container(
                    width: 300,
                    child: Text(
                        model.users[index].userModel.desc1,
                        style: TextStyle(
                          color: Colors.white,

                          ///文字の色を白にする
                          fontWeight: FontWeight.bold,

                          ///文字を太字する
                          fontSize: 20.0,
                        )
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.previousPage(duration: const Duration(milliseconds: 1), curve: Curves.easeInOutBack);
                  },
                  child: Container(
                    width: 350 / 2,
                    height: 550,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      //border: Border.all(color: kBackgroundColor, width: 5),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft: Radius.circular(25)),
                    ),
                  ),
                ),
                Positioned(
                  left: 350 / 2,
                  child: InkWell(
                    onTap: () {
                      controller.nextPage(duration: const Duration(milliseconds: 1), curve: Curves.easeInOutBack);
                    },
                    child: Container(
                      width: 350 / 2,
                      height: 550,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        //border: Border.all(color: kBackgroundColor, width: 5),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
      }
}