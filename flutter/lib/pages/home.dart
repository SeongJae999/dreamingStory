import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/pages/onboarding_main.dart';
import 'package:dreamingstory/pages/account/login.dart';
import 'package:dreamingstory/pages/storyGenerate/story_generate.dart';
import 'package:dreamingstory/pages/storyGenerate/story_selection.dart';

class HomePage extends StatelessWidget {
  final userInfo? user;
  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '나의 책장',
          style: TextStyle(fontFamily: 'GodoB'),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 65, 89),
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 242, 210, 114),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                '메뉴',
                style: TextStyle(
                    color: const Color.fromARGB(255, 242, 210, 114),
                    fontSize: 24,
                    fontFamily: 'GodoB'),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 27, 65, 89),
              ),
            ),
            ListTile(
              title: Text(
                user?.email ?? '게스트 계정입니다.',
                style: TextStyle(fontFamily: 'GodoM'),
              ),
            ),
            ListTile(
              title: Text(
                '공유',
                style: TextStyle(fontFamily: 'GodoM'),
              ),
              onTap: () {
                // 공유 기능 구현 필요
              },
            ),
            ListTile(
              title: Text(
                '구독 및 취소',
                style: TextStyle(fontFamily: 'GodoM'),
              ),
              onTap: () {
                // 구독 및 취소 기능 구현 필요
              },
            ),
            ListTile(
              title: Text(
                '설정',
                style: TextStyle(fontFamily: 'GodoM'),
              ),
              onTap: () {
                // 설정 페이지로 이동하는 기능 구현 필요
              },
            ),
            ListTile(
              title: Text(
                '사용 가이드',
                style: TextStyle(fontFamily: 'GodoM'),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnboardingMain()));
              },
            ),
            ListTile(
              title: Text(
                '로그아웃',
                style: TextStyle(
                  fontFamily: 'GodoM',
                  color: Color.fromARGB(255, 217, 123, 102),
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나만의 동화 만들기',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GodoB'),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StoryCreationPage()),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/준비중.jpg', // 이미지 경로 수정 필요
                      width: double.infinity,
                      height: 360,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                StorySelection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          double height = constraints.maxHeight * 0.1; // 화면 높이의 10%
          return Container(
            height: height,
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.collections_bookmark),
                  label: '나의 책장',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.diversity_3),
                  label: '친구의 책장',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.brush),
                  label: '캐릭터 꾸미기',
                ),
              ],
              currentIndex: 0,
              selectedItemColor: const Color.fromARGB(255, 242, 210, 114),
              unselectedItemColor: const Color.fromARGB(100, 242, 210, 114),
              backgroundColor: const Color.fromARGB(255, 27, 65, 89),
              selectedLabelStyle:
                  const TextStyle(fontFamily: 'GodoM', fontSize: 16),
              unselectedLabelStyle:
                  const TextStyle(fontFamily: 'GodoM', fontSize: 14),
              onTap: (index) {},
            ),
          );
        },
      ),
    );
  }
}
