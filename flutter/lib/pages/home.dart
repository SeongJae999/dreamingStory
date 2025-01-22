import 'package:flutter/material.dart';
import 'package:dreamingstory/pages/drawer/sharing.dart';
import 'package:dreamingstory/pages/drawer/subscribe1.dart';
import 'package:dreamingstory/pages/onboarding_main.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/pages/storyGenerate/story_keywords_select_page.dart';
import 'package:dreamingstory/pages/story_display_default_page.dart';
import 'package:dreamingstory/pages/drawer/setting.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:text_scroll/text_scroll.dart';
//import 'package:dreamingstory/pages/account/login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final userInfo? user;
  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();

  void _playBackgroundMusic() async {
    await _backgroundMusicPlayer
        .setSource(AssetSource('audios/dreaming_story.wav'));
    _backgroundMusicPlayer.setVolume(0.5);
    _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    _backgroundMusicPlayer.resume();
  }

  @override
  void dispose() {
    _backgroundMusicPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //배경음악 재생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playBackgroundMusic();
    });
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
                      widget.user?.email ?? '게스트 계정입니다.',
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
                onTap: () => Navigator.pushReplacement(
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
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('나만의 동화 만들기'),
                  SizedBox(height: 16),
                  _buildStoryCreationCard(context),
                  SizedBox(height: 32),
                  _buildSectionTitle('인기 무료'),
                  SizedBox(height: 16),
                  _buildPopularFreeGrid(context),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Helper methods
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'GodoB',
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black.withOpacity(0.3),
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCreationCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StoryCreationPage()),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/준비중.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularFreeGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.7,
      children: [
        _buildStoryCard(
          context,
          '반짝이의 이빨 모험',
          'assets/무료 동화/반짝이의 이빨 모험/images/intro.png',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoryDisplayDefaultPage())),
        ),
        _buildStoryCard(
          context,
          '구름 궁전의 웃음 공주와 기다림의 마법',
          'assets/무료 동화/구름 궁전의 웃음 공주와 기다림의 마법/images/intro.png',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoryDisplayDefaultPage())),
        ),
        _buildStoryCard(
          context,
          '흥부와 놀부',
          'assets/무료 동화/흥부와 놀부/images/intro.png',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoryDisplayDefaultPage())),
        ),
      ],
    );
  }

  Widget _buildStoryCard(BuildContext context, String title, String imagePath,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GodoM',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
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
        selectedLabelStyle: const TextStyle(fontFamily: 'GodoM', fontSize: 14),
        unselectedLabelStyle:
            const TextStyle(fontFamily: 'GodoM', fontSize: 12),
        onTap: (index) {
          // Implement navigation logic here
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
}
