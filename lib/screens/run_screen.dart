import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'on_end.dart'; // OnEndPage의 경로를 추가

class RunScreen extends StatefulWidget {
  @override
  _RunScreenState createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  late Timer _timer;
  int _seconds = 0;
  double _distance = 0.0;
  Position? _lastPosition;
  final double weight = 70.0; // 사용자의 체중 (kg), 칼로리 계산에 사용

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startTracking();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _startTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        if (_lastPosition != null) {
          _distance += Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          ) / 1000; // meters to kilometers
        }
        _lastPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = _seconds ~/ 60;
    final int remainingSeconds = _seconds % 60;
    final double pace = _distance > 0 ? _seconds / 60 / _distance : 0.0; // km per minute

    return Scaffold(
      backgroundColor: Colors.white, // 배경색을 흰색으로 변경
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "${pace.toStringAsFixed(2)}'",
                      style: TextStyle(fontSize: 18, color: Colors.black), // 페이스 텍스트 색상 변경
                    ),
                    Text(
                      "페이스",
                      style: TextStyle(fontSize: 16, color: Color(0xFF735858)), // 페이스 라벨 텍스트 색상 변경
                    ),
                  ],
                ),
                SizedBox(width: 20), // 간격
                Column(
                  children: [
                    Text(
                      "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}",
                      style: TextStyle(fontSize: 18, color: Colors.black), // 시간 텍스트 색상 변경
                    ),
                    Text(
                      "시간",
                      style: TextStyle(fontSize: 16, color: Color(0xFF735858)), // 시간 라벨 텍스트 색상 변경
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50), // 간격
            Text(
              _distance.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 40, // 거리 표시 텍스트 크기 변경
                fontWeight: FontWeight.bold,
                color: Colors.black, // 텍스트 색상 변경
              ),
            ),
            SizedBox(height: 5), // 간격
            Text(
              "킬로미터",
              style: TextStyle(fontSize: 18, color: Color(0xFF735858)), // 거리 단위 표시 텍스트 색상 변경
            ),
            SizedBox(height: 50), // 간격
            GestureDetector(
              onTap: () {
                _timer.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnEndPage(
                      pace: pace.toStringAsFixed(2),
                      distance: _distance.toStringAsFixed(2),
                      time: "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}",
                    ),
                  ),
                ); // OnEndPage로 이동
              },
              child: Container(
                height: 70, // 크기 조정
                width: double.infinity, // 전체 가로폭
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black, width: 2), // 완주 버튼의 테두리를 검정색으로 변경
                  shape: BoxShape.circle, // 동그라미 모양
                ),
                margin: EdgeInsets.only(top: 20), // 위치 조정
                child: Center(
                  child: Text(
                    "완주",
                    style: TextStyle(
                      color: Colors.black, // 검정 색상
                      fontSize: 16, // 글자 크기
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
