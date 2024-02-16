import 'package:camera_pj/component/token_manager.dart';
import 'package:camera_pj/controller/account_controller.dart';
import 'package:camera_pj/screen/sign_in_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../screen/home_screen.dart';

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (googleAuth.idToken != null) {
        await TokenManager().setToken(googleAuth.idToken!);
        print(googleAuth.idToken);
      }
      print(googleAuth.idToken);
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);


      if (fcmToken != null) {
        await TokenManager().setToken(fcmToken);
      }
      return userCredential.user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> checkUserInfoAndNavigate(User? user) async {
  if (user == null) {
    print("로그인 실패");
    return;
  }

  final idToken = await TokenManager().getToken();
  final fcmToken = await TokenManager().getFcmToken();

  final dio = Dio();

  try {
    final response = await dio.post(
      'https://fire-61d9a.du.r.appspot.com/users/signIn/',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      }),
      data: {
        'fcmToken': fcmToken,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = response.data;
      print(response.data);
      Get.to(HomeScreen());
    } else if (response.statusCode == 404) {
      Get.to(SignInNameInput());
    } else {
      print("서버 에러: ${response.data}");
    }
  } catch (e) {
    print("Dio 에러: $e");
  }
}

void onGoogleSignInButtonPressed() {
  signInWithGoogle().then((user) {
    checkUserInfoAndNavigate(user);
  });
}