// s_splash.dart
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 's_login.dart'; // 로그인 화면 파일을 import

void main() {
  KakaoSdk.init(nativeAppKey: 'db5ebeafb0496e3d199bb132fea34aca');
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
