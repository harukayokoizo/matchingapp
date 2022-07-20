import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:matching_app/hive/hive_type.dart';
import 'package:matching_app/provider/bottomtab_provider.dart';
import 'package:matching_app/provider/chat_provider.dart';
import 'package:matching_app/provider/initset_provider.dart';
import 'package:matching_app/provider/login_provider.dart';
import 'package:matching_app/provider/myprofile_provider.dart';
import 'package:matching_app/provider/type_provider.dart';
import 'package:matching_app/provider/user_provider.dart';
import 'package:matching_app/test.dart';
import 'package:matching_app/top/myprofile.dart';
import 'package:matching_app/top/top.dart';
import 'package:matching_app/utils/authentication.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'hive/hive_database.dart';
import 'hive/hive_swipe.dart';
import 'loginpage.dart';

Future<void> main() async {
  // main()の中で非同期処理を行う際には、下記を実行しなければいけないらしい
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Hiveの初期化
  await Hive.initFlutter();
  // カスタムアダプターの追加
  Hive.registerAdapter<Person>(PersonAdapter());
  Hive.registerAdapter<MyType>(MyTypeAdapter());
  Hive.registerAdapter<Swipe>(SwipeAdapter());
  //personsデータベースを開く
  //var persons = await Hive.openBox('record');

  // iOS,androidともに縦向き固定
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<InitSetProvider>(
                create: (context) => InitSetProvider()
            ),
            ChangeNotifierProvider<UserProvider>(
                create: (context) => UserProvider()
            ),
            ChangeNotifierProvider<BottomTabProvider>(
                create: (context) => BottomTabProvider()
            ),
            ChangeNotifierProvider<TypeProvider>(
                create: (context) => TypeProvider()
            ),
            ChangeNotifierProvider<ChatProvider>(
                create: (context) => ChatProvider()
            ),
            ChangeNotifierProvider<MyProfileProvider>(
                create: (context) => MyProfileProvider()
            ),
            ChangeNotifierProvider<LoginProvider>(
                create: (context) => LoginProvider()
            ),
          ],
          child: MyApp(),
        )
    );
  });
  /// MyAppはルートウィジェットです。
}

///ユーザーがサインアウトするまで、ログインを維持するためにAuthenticationProviderを実装する
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print(1);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          ///色を黒か明るいの
          brightness: Brightness.dark,
          ///constants.dartで定義したもの
          primaryColor: kPrimaryColor,

          ///MaterialAppのscaffoldの背景色を指定
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            ///largeテキストの色、幅
            headline4: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),

            ///ボタンの色
            button: TextStyle(
              color: kPrimaryColor,
            ),

            ///largeテキストのダイアログの色、フォント
            headline1: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.normal,
            ),
          ),

          ///入力欄を入れる
          inputDecorationTheme: InputDecorationTheme(
            ///入力欄にアンダーラインを入れる
            enabledBorder: UnderlineInputBorder(
              ///アンダーラインのスタイル指定(色、長さ)
              borderSide: BorderSide(
                ///withOpacityは透明度を指定する
                color: Colors.white.withOpacity(.3),
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          //アプリの起動時（使用中）にユーザーの Firebase Auth のログイン状態を確認・監視する
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // スプラッシュ画面(ロード中の画面)
                return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Colors.green,
                    )
                );
              }
              print(3);
              //ログイン済みの場合
              if (snapshot.hasData) {
                final model = Provider.of<LoginProvider>(context, listen: false);
                model.getMyUser();
                //取得できたかどうかを判定する。
                //model.exitMyUser(model.myProfile);
                return Consumer<LoginProvider>(
                    builder: (context, loginModel, _) {
                      if(!loginModel.exit){
                        return LoginPage();
                      }else{
                        return TopPage();
                      }
                    }

                );
              }else {
                //final model = Provider.of<UserProvider>(context, listen: false);
                //model.getMyUser(model.currentUser.uid);
                //取得できたかどうかを判定する。
                //model.exitMyUser(model.userdata);
                // User が null である場合、ログイン画面に遷移する。
                return LoginPage();
              }
            },

    )
    );
  }
}
