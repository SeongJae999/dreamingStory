import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/pages/drawer/sharing.dart';
import 'package:dreamingstory/pages/drawer/setting.dart';
import 'package:dreamingstory/pages/drawer/subscribe1.dart';
import 'package:dreamingstory/pages/onboarding_main.dart';
// import 'package:dreamingstory/pages/story/story_generate.dart';
import 'package:dreamingstory/pages/story/story_selection.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  final userInfo? user;
  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  late AppLifecycleListener _lifecycleListener;

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundMusicPlayer.setSource(
        AssetSource('audios/dreaming_story.wav'),
      );
      _backgroundMusicPlayer.setVolume(0.5);
      _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundMusicPlayer.resume();
    } catch (e) {
      print('오디오 재생 중 오류 발생: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();

    _lifecycleListener = AppLifecycleListener(
      onPause: () {
        _backgroundMusicPlayer.pause();
      },
      onResume: () {
        _backgroundMusicPlayer.resume();
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _backgroundMusicPlayer.dispose();
    super.dispose();
  }

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
                  StoryCreationCarousel(),
                  SizedBox(height: 32),
                  _buildSectionTitle('인기 무료'),
                  SizedBox(height: 16),
                  StorySelectionPage(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

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

class StoryCreationCarousel extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/main01.png',
    'assets/images/main02.png',
    'assets/images/main03.png',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        aspectRatio: 16 / 9,
      ),
      items: imagePaths.map((imagePath) {
        return GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StorySelectionPage()),
            );
          },
          child: Container(
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
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}