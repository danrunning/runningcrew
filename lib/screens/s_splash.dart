// s_splash.dart
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 's_login.dart'; // 로그인 화면 파일을 import
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '88e76129a9cf987cef8a6a93cd8fe0bb');

  // 키 해시를 가져와 출력합니다.
  String keyHash = await KakaoSdk.origin;
  print('키 해시: $keyHash');

  // Firebase 초기화가 이미 수행되었는지 확인
  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (e.toString().contains('A Firebase App named "[DEFAULT]" already exists')) {
      // 이미 초기화된 경우 예외를 무시합니다.
    } else {
      rethrow;
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: navigateToLogin,
        behavior: HitTestBehavior.opaque, // 이 속성을 추가하여 빈 공간 터치도 감지
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 20,
              child: FadeTransition(
                opacity: _animation,
                child: Text(
                  'find\nyour\ncrew.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Aleo',
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Text(
                'Running Crew',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Abhaya Libre',
                  fontWeight: FontWeight.w800, // ExtraBold
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}