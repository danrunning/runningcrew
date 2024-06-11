import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // HomeScreen import 추가

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isToday = true; // 초기 상태는 "오늘"
  String userName = 'User_Name'; // 사용자 이름 기본값
  double todayDistance = 0.0;
  String todayPace = '0\'00\"';
  String todayTime = '00:00';
  int todayCalories = 0;
  double totalDistance = 0.0;
  String totalPace = '0\'00\"';
  String totalTime = '00:00';
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    _loadRecentData();
    _loadTotalData();
  }

  Future<void> _loadUserData() async {
    try {
      // SharedPreferences에서 저장된 사용자 이름을 가져오기
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUserName = prefs.getString('username') ?? 'User_Name';

      // 저장된 값 출력
      print('Stored username: $storedUserName');

      setState(() {
        userName = storedUserName;
      });
    } catch (error) {
      print('Failed to get user data: $error');
    }
  }

  Future<void> _loadRecentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todayDistance = prefs.getDouble('recent_distance') ?? 0.0;
      todayPace = prefs.getString('recent_pace') ?? '0\'00\"';
      todayTime = prefs.getString('recent_time') ?? '00:00';
      todayCalories = prefs.getInt('recent_calories') ?? 0;
    });
  }

  Future<void> _loadTotalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalDistance = prefs.getDouble('total_distance') ?? 0.0;
      totalPace = prefs.getString('total_pace') ?? '0\'00\"';
      totalTime = prefs.getString('total_time') ?? '00:00';
      totalCalories = prefs.getInt('total_calories') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 8),
            Text('내 정보'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey,
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/Ellipse 6.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 16),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  InfoCard(
                    title: '거리',
                    content: isToday ? todayDistance.toStringAsFixed(2) : totalDistance.toStringAsFixed(2),
                    backgroundColor: Color(0xFFF6F5F2),
                  ),
                  InfoCard(
                    title: '페이스',
                    content: isToday ? todayPace : totalPace,
                    backgroundColor: Color(0xFFF0EBE3),
                  ),
                  InfoCard(
                    title: '시간',
                    content: isToday ? todayTime : totalTime,
                    backgroundColor: Color(0xFFF3D0D7),
                  ),
                  InfoCard(
                    title: '칼로리',
                    content: isToday ? todayCalories.toString() : totalCalories.toString(),
                    backgroundColor: Color(0xFFFFEFEF),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                setState(() {
                  isToday = !isToday; // "오늘"과 "누적" 상태 변경
                });
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent, // 투명한 배경색
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black), // 검정색 테두리 추가
                ),
                child: Center(
                  child: Text(
                    isToday ? '최근' : '누적', // 상태에 따라 텍스트 변경
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색상
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final Color backgroundColor;

  InfoCard({required this.title, required this.content, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
