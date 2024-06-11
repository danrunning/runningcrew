import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // PlatformException을 사용하기 위해 추가
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:running_crew/screens/personal_page.dart';
import 'home_screen.dart'; // 홈 화면 파일을 import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 사용자 정보 저장을 위해 추가

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/icons/login_image.png', // 이미지 경로 수정
              fit: BoxFit.cover, // 이미지 크기 조정
            ),
          ),
          // 상단의 Running Crew 텍스트
          Positioned(
            top: 10,
            left: 17,
            child: Text(
              'Running Crew',
              style: TextStyle(
                fontFamily: 'Abhaya Libre',
                fontWeight: FontWeight.w800, // ExtraBold
                fontSize: 40, // 글씨 크기 40pt로 수정
                color: Colors.white,
              ),
            ),
          ),
          // 로그인 버튼
          Positioned(
            bottom: 46,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  signInWithKaKao(context); // context를 전달
                },
                child: Image.asset(
                  'assets/icons/kakao_login.png',
                  width: 200, // 버튼 크기 조정
                  height: 50,
                ),
              ),
            ),
          ),
          // 최하단의 문구
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Opacity(
                opacity: 0.2,
                child: Text(
                  'Life is short, Run',
                  style: TextStyle(
                    fontFamily: 'Abhaya Libre',
                    fontWeight: FontWeight.w800, // ExtraBold
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigatorToMainPage(BuildContext context){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
  }

  Future<void> signInWithKaKao(BuildContext context) async {
    try {
      kakao.OAuthToken token;
      if (await kakao.isKakaoTalkInstalled()) {
        try {
          token = await kakao.UserApi.instance.loginWithKakaoTalk();
          print('카카오톡으로 로그인 성공');
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');

          if (error is PlatformException && error.code == 'CANCELED') {
            return;
          }

          token = await kakao.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        }
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      }

      var provider = OAuthProvider("oidc.runningcrew");
      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      kakao.User user;
      try {
        user = await kakao.UserApi.instance.me();
      } catch (error) {
        print('사용자 정보 요청 실패 $error');
        return;
      }

      List<String> scopes = [];
      if (user.kakaoAccount?.profileNeedsAgreement == true) {
        scopes.add('profile');
      }

      if (scopes.isNotEmpty) {
        print('사용자에게 추가 동의 받아야 하는 항목이 있습니다');
        try {
          token = await kakao.UserApi.instance.loginWithNewScopes(scopes);
          print('현재 사용자가 동의한 동의항목: ${token.scopes}');
        } catch (error) {
          print('추가 동의 요청 실패 $error');
          return;
        }

        try {
          user = await kakao.UserApi.instance.me();
          print('사용자 정보 요청 성공'
              '\n회원번호: ${user.id}'
              '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
              '\n이메일: ${user.kakaoAccount?.email}');
        } catch (error) {
          print('사용자 정보 요청 실패 $error');
          return;
        }
      }

      String? nickname = user.kakaoAccount?.profile?.nickname;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', nickname ?? 'User_Name');
      print('사용자 이름 저장 완료: $nickname');

      navigatorToMainPage(context);
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}
