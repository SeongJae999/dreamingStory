import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'account/login.dart'; // 일단 onboarding 페이지와 연결시켜 놓겠습니다.
import 'package:dreamingstory/pages/onboarding_main.dart';
import 'package:dreamingstory/pages/storyGenerate/story_topic_page.dart';
import 'package:dreamingstory/component/user.dart';

class HomePage extends StatelessWidget {
  final userInfo? user;
  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('메뉴',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text(user?.email ?? '이메일 정보 없음'),
            ),
            ListTile(
              title: Text('공유'),
              onTap: () {
                // 공유 기능 구현 필요
              },
            ),
            ListTile(
              title: Text('구독 및 취소'),
              onTap: () {
                // 구독 및 취소 기능 구현 필요
              },
            ),
            ListTile(
              title: Text('설정'),
              onTap: () {
                // 설정 페이지로 이동하는 기능 구현 필요
              },
            ),
            ListTile(
              title: Text('사용 가이드'),
              onTap: () {
                // 사용 가이드 페이지로 이동하는 기능 구현 필요
              },
            ),
            ListTile(
              title: Text('로그아웃'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingMain()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 나만의 동화 만들기 섹션
              Text(
                '나만의 동화 만들기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoryTopicPage()),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/background.png', // 이미지 경로 수정 필요
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 32),

              // 인기 무료 섹션
              Text(
                '인기 무료',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  _buildStoryCard(
                    context,
                    '아기 돼지 삼형제',
                    'assets/images/background.png',
                    () {
                      // 아기 돼지 삼형제 페이지로 이동
                    },
                  ),
                  _buildStoryCard(
                    context,
                    '흥부와 놀부',
                    'assets/images/background.png',
                    () {
                      // 흥부와 놀부 페이지로 이동
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard(
    BuildContext context,
    String title,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(
                    imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
