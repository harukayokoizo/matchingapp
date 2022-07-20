import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

import '../code/code_list.dart';
import '../provider/chat_provider.dart';
import '../provider/user_provider.dart';

class ChatProfile extends StatelessWidget{
  final hobbyCode = new HobbyCode();
  final List<dynamic> hobbies;
  final List<dynamic> images;
  final int index;
  final profile;

  ChatProfile(this.index, this.hobbies, this.images, this.profile);
  @override

  Widget build(BuildContext context){
    final PageController controller = PageController(initialPage: 0);
    final currentPageNotifier = ValueNotifier<int>(0);
    final chatModel = Provider.of<ChatProvider>(context, listen: false);
    final userModel = Provider.of<UserProvider>(context, listen: false);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children : [
              Container(
                width: deviceWidth,
                height: deviceHeight - deviceHeight/3,
                color: Colors.white,
              ),
              Container(
                width: deviceWidth,
                height: deviceHeight - deviceHeight/3,

                child: PageView.builder(
                  //スクロールを無効にする
                  physics: NeverScrollableScrollPhysics(),

                  //controllerを定義することにより、別個所からの応答を受ける
                  controller: controller,
                  onPageChanged: (i){
                    print(10);
                    userModel.dotIndicator(controller,currentPageNotifier);
                  },

                  itemBuilder: (context, i) {
                    return Image(
                        image: Image.network(images[i]['imagePath']).image,
                        //画像の大きさをWidgetに合わせる
                        fit: BoxFit.fill,
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(color: Colors.green,),
                            );
                          }
                        }

                    );
                  },
                  itemCount: images.length,
                ),
              ),
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
                    itemCount: images.length,
                    currentPageNotifier: currentPageNotifier,
                  ),

                ),
              ),
              InkWell(
                onTap: () {
                  controller.previousPage(duration: const Duration(milliseconds: 1), curve: Curves.easeInOutBack);
                },
                child: Container(
                  width: deviceWidth / 2,
                  height: deviceHeight - deviceHeight/3,
                ),
              ),
              Positioned(
                left: deviceWidth / 2,
                child: InkWell(
                  onTap: () {
                    controller.nextPage(duration: const Duration(milliseconds: 1), curve: Curves.easeInOutBack);
                  },
                  child: Container(
                    width: deviceWidth / 2,
                    height: deviceHeight - deviceHeight/3,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0,left: 20.0, right: 8.0),
                child: Text(
                    profile.name,
                    style: TextStyle(
                      color: Colors.white,

                      ///文字の色を白にする
                      fontWeight: FontWeight.bold,

                      ///文字を太字する
                      fontSize: 30.0,
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0,),
                child: Text(
                    profile.age,
                    //userModel.users[index].name,
                    style: TextStyle(
                      color: Colors.white,

                      ///文字の色を白にする
                      fontWeight: FontWeight.bold,

                      ///文字を太字する
                      fontSize: 25.0,
                    )
                ),
              ),
            ],
          ),
          Row(
            children: [
              for(int i = 0; i < hobbies.length ;i++)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0,bottom: 10.0),
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
                      hobbyCode.hobbyList[hobbies[i]['hobby']],
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                profile.desc1,
                style: TextStyle(
                  color: Colors.white,

                  ///文字の色を白にする
                  fontWeight: FontWeight.bold,

                  ///文字を太字する
                  fontSize: 25.0,
                )
            ),
          ),
        ],
      ),
    );
  }
}