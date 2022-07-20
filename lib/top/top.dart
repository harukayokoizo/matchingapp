import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matching_app/loginpage.dart';
import 'package:matching_app/top/chatlist.dart';
import 'package:matching_app/top/chooseuser.dart';
import 'package:matching_app/top/myprofile.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';

import '../provider/bottomtab_provider.dart';
import '../provider/user_provider.dart';

class TopPage extends StatelessWidget{
  final List<Widget> _pageList = <Widget>[
    ChooseUser(),
    ChatList(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomTabProvider>(
      builder: (context, model, child) {
        final tabItems = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.swipe),
            label: 'スワイプ',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'チャット',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'プロフィール',
          ),
        ];

        return Scaffold(
          body: _pageList[model.currentIndex],/*IndexedStack(
            index: model.currentIndex,
            children: _pageList,
          ),*/
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: model.currentIndex,
            onTap: (index) {
              model.currentIndex = index;
            },
            items: tabItems,
          ),
        );
      },
    );
  }
}