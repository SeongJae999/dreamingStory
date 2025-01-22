import 'package:dreamingstory/pages/drawer/sharing.dart';
import 'package:dreamingstory/pages/drawer/subscribe1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamingstory/pages/onboarding_main.dart';
import 'package:dreamingstory/pages/account/login.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/pages/storyGenerate/story_keywords_select_page.dart';
import 'package:dreamingstory/pages/story_display_default_page.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:dreamingstory/pages/drawer/setting.dart';

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
        child: Container(
          color: const Color.fromARGB(255, 27, 65, 89),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 242, 210, 114),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '메뉴',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 27, 65, 89),
                        fontSize: 28,
                        fontFamily: 'GodoB',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      user?.email ?? '게스트 계정입니다.',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 27, 65, 89),
                        fontSize: 14,
                        fontFamily: 'GodoM',
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                icon: Icons.share,
                title: '공유',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SharingPage()),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.subscriptions,
                title: '구독 및 결제',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscribePage()),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.settings,
                title: '설정',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.help_outline,
                title: '사용 가이드',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnboardingMain()),
                ),
              ),
            ],
          ),
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
                // 나만의 동화 만들기 섹션
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

                // 인기 무료 섹션
                Text(
                  '인기 무료',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GodoB'),
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
                      const TextScroll('반짝이의 이빨 모험'),
                      'assets/무료 동화/반짝이의 이빨 모험/images/intro.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryDisplayDefaultPage(),
                          ),
                        );
                      },
                    ),
                    _buildStoryCard(
                      context,
                      const TextScroll(
                        '구름 궁전의 웃음 공주와 기다림의 마법',
                        mode: TextScrollMode.endless,
                        velocity: Velocity(pixelsPerSecond: Offset(30, 0)),
                        numberOfReps: 200,
                        delayBefore: Duration(milliseconds: 3000),
                        pauseBetween:
                            Duration(milliseconds: 1000), // 1000ms = 1s
                      ),
                      'assets/무료 동화/구름 궁전의 웃음 공주와 기다림의 마법/images/intro.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryDisplayDefaultPage(),
                          ),
                        );
                      },
                    ),
                    _buildStoryCard(
                      context,
                      const TextScroll('흥부와 놀부'),
                      'assets/무료 동화/흥부와 놀부/images/intro.png',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryDisplayDefaultPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
              onTap: (index) {
                // 하단바 아이템 클릭 시 동작 구현 필요
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 242, 210, 114)),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'GodoM',
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildStoryCard(
    BuildContext context,
    Widget title,
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
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.bookmark,
                      color: Color.fromARGB(255, 217, 123, 102),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'GodoM',
            ),
            child: title,
          ),
        ],
      ),
    );
  }
}
