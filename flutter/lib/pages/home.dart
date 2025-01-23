import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/pages/drawer/sharing.dart';
import 'package:dreamingstory/pages/drawer/setting.dart';
import 'package:dreamingstory/pages/drawer/subscribe1.dart';
import 'package:dreamingstory/pages/onboarding_main.dart';
import 'package:dreamingstory/pages/story/story_generate.dart';
import 'package:dreamingstory/pages/story/story_selection.dart';

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

  @override
  Widget build(BuildContext context) {
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
                          builder: (context) => StoryGenerationPage()),
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
                //SizedBox(height: 32),
                //RecentStory(),
                SizedBox(height: 32),
                StorySelectionPage(),
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
