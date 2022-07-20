import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  ///User型の非同期処理
  ///user情報を返す
  static Future<User> signInWithGoogle() async {
    ///FirebaseAuthのインスタンスを生成
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    ///サインイン構成設定を初期化する
    ///GoogleSignInにスコープ（サインイン時に要求する情報を決めることができる）を引数として設定することができる
    ///ex scopes:['email','']
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
    ]);

    ///signIn()はサインインプロセスを開始する
    ///サインインプロセスが中止された場合、nullを返す。
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    print(googleSignInAccount);

    ///アカウントが存在する場合
    if (googleSignInAccount != null) {
      ///認証の詳細を取得する
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      ///Flutter側でGoogleによる認証情報を取得
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      ///try {
      ///取得した認証情報をsignInWithCredentialでFirebaseに送信する
      ///signInWithCredentialは追加のIDプロバイダーデータを返す
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      ///user情報を返す
      user = userCredential.user;

      print(user.uid);

      /**
          ///例外処理
          } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
          content:
          'The account already exists with a different credential',
          ),
          );
          } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
          content:
          'Error occurred while accessing credentials. Try again.',
          ),
          );
          }
          } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
          content: 'Error occurred using Google Sign In. Try again.',
          ),
          );
          }
       **/

      return user;
      // }
    }
  }

  static Future<User> signOutWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignOut = GoogleSignIn();

    ///flutterのサインアウト
    auth.signOut();

    ///Googleのサインアウト
    await googleSignOut.signIn();

  }

/**
    ///エラーメッセージの表示・装飾
    static SnackBar customSnackBar({String content}) {
    return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
    content,
    ///引数で渡されたエラーメッセージを赤色にする
    style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    ),
    );
    }
 **/
}
