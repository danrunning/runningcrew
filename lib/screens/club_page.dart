import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // HomeScreen import 추가
class ClubListPage extends StatelessWidget {
  Future<void> _showConfirmationDialog(BuildContext context, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '가입 확인',
            style: TextStyle(color: Colors.black), // 팝업 타이틀 색상 변경
          ),
          content: Text(
            '해당 클럽에 가입하시겠습니까?',
            style: TextStyle(color: Colors.black), // 팝업 내용 색상 변경
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClubPage(index: index, userName: userName ?? 'User_Name')), // 사용자 이름을 전달
                );
              },
              child: Text(
                '예',
                style: TextStyle(color: Colors.blue), // 예 버튼 색상 변경
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: Text(
                '아니요',
                style: TextStyle(color: Colors.red), // 아니요 버튼 색상 변경
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.groups), // 사람 여러 명 아이콘
            SizedBox(width: 8),
            Text('클럽 목록'), // 텍스트
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // 높이 조정
          child: Container(
            color: Colors.grey, // 배경색을 통한 구분
            height: 2.0, // 높이 설정
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10, // 클럽 목록의 수를 지정합니다.
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClubCard(
                  index: index,
                  onCardTap: () => _showConfirmationDialog(context, index)), // 클럽 카드 렌더링
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          height: 40.0, // 높이 설정
          child: Center(
            child: Text('abc@mail.com', style: TextStyle(fontSize: 16, color: Colors.grey)), // 글자색 회색 추가
          ),
        ),
      ),
    );
  }
}

class ClubCard extends StatelessWidget {
  final int index;
  final VoidCallback onCardTap;

  ClubCard({required this.index, required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    List<IconData> clubIcons = [
      Icons.flag,
      Icons.badge,
      Icons.home,
      Icons.favorite,
      Icons.thumb_up,
      Icons.star,
      Icons.watch,
      Icons.emoji_events // 추가된 emoji_events 아이콘
    ]; // 클럽 아이콘 리스트

    return GestureDetector(
      onTap: onCardTap, // 카드 터치 시 이벤트 처리
      child: Card(
        elevation: 5, // 카드 높이 조정
        margin: EdgeInsets.symmetric(vertical: 2.0), // 카드의 간격 조정
        color: Color(0xFFF6F5F2), // 배경색을 지정합니다.
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0), // 카드의 상하 여백 조정
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(0xFFD9D9D9), // 동그라미 배경색 변경
              child: Icon(
                clubIcons[index % clubIcons.length], // 클럽마다 다른 아이콘
                color: Colors.black,
              ), // 클럽 이름을 의미하는 아이콘
            ),
            title: Text('클럽 ${index + 1}', style: TextStyle(color: Colors.black)), // 클럽의 이름
          ),
        ),
      ),
    );
  }
}

class ClubPage extends StatelessWidget {
  final int index;
  final String userName;

  ClubPage({required this.index, required this.userName});

  @override
  Widget build(BuildContext context) {
    List<IconData> clubIcons = [
      Icons.flag,
      Icons.badge,
      Icons.home,
      Icons.favorite,
      Icons.thumb_up,
      Icons.star,
      Icons.watch,
      Icons.emoji_events // 추가된 emoji_events 아이콘
    ]; // 클럽 아이콘 리스트

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent, // 투명하게 설정
              child: Icon(
                clubIcons[index % clubIcons.length], // 클럽 아이콘 설정
                color: Colors.black,
                size: 30.0, // 아이콘 사이즈 설정
              ),
            ),
            SizedBox(width: 8),
            Text('클럽 ${index + 1}') // 클럽 이름 추가
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // 높이 조정
          child: Container(
            color: Colors.grey, // 배경색을 통한 구분
            height: 2.0, // 높이 설정
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ClubMemberCard(index: 0, userName: userName),
          ClubMemberCard(index: 1),
          ClubMemberCard(index: 2),
          ClubMemberCard(index: 3),
          ClubMemberCard(index: 4),
          ClubMemberCard(index: 5),
          ClubMemberCard(index: 6),
          ClubMemberCard(index: 7),
        ],
      ),
    );
  }
}

class ClubMemberCard extends StatelessWidget {
  final int index;
  final String? userName;

  ClubMemberCard({required this.index, this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Color(0xFFF6F5F2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // 카드의 상하 여백 조정
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(0xFFD9D9D9),
            child: Icon(
              index == 0 ? Icons.emoji_events : Icons.person, // 첫 멤버의 경우 emoji_events 아이콘
              color: Colors.black,
            ),
          ),
          title: Text(
              index == 0 && userName != null ? userName! : '멤버 ${index + 1}',
              style: TextStyle(color: Colors.black)
          ),
        ),
      ),
    );
  }
}