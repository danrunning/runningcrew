import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // PlatformException을 사용하기 위해 추가
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

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
              child: Opacity(
                opacity: 0.8,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _loginWithKakao(context);
                  },
                  icon: Icon(Icons.chat_bubble),
                  label: Text('카카오 로그인'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    minimumSize: Size(200, 50),
                  ),
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

  Future<void> _loginWithKakao(BuildContext context) async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          print('카카오톡으로 로그인 성공 ${token.accessToken}');
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');
          if (error is PlatformException && error.code == 'CANCELED') {
            return;
          }
          token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
        }
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
      }

      // 토큰 저장
      TokenManagerProvider.instance.manager.setToken(token);

      // 로그인 후 다음 화면으로 이동
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}
