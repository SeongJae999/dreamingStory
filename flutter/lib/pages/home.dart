import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/component/auth_service.dart';
import 'package:dreamingstory/pages/drawer/sharing.dart';
import 'package:dreamingstory/pages/drawer/setting.dart';
import 'package:dreamingstory/pages/drawer/subscribe1.dart';
import 'package:dreamingstory/pages/onboarding.dart';
import 'package:dreamingstory/pages/story/story_generate.dart';
import 'package:dreamingstory/pages/story/story_selection.dart';
import 'package:dreamingstory/pages/slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  final userInfo? user;
  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AuthService _authService = AuthService();
  //late AppLifecycleListener _lifecycleListener;
  bool _isLoading = false;
  String? _error;
  String? _protectedData;

  Future<void> _fetchProtectedData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String? token = await _authService.getFirebaseIdToken();
      if (token == null) {
        throw Exception('로그인이 필요합니다.');
      }

      final response =
          await _authService.getRequest('/auth/protected', headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _protectedData = data['message'];
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _protectedData = data['detail'] ?? '데이터를 불러오지 못했습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _protectedData = '오류가 발생했습니다: $e';
      });
      print('데이터 가져오기 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _playBackgroundMusic() async {
  //   try {
  //     await _backgroundMusicPlayer.setSource(
  //       AssetSource('audios/dreaming_story.wav'),
  //     );
  //     _backgroundMusicPlayer.setVolume(0.5);
  //     _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
  //     await _backgroundMusicPlayer.resume();
  //   } catch (e) {
  //     print('오디오 재생 중 오류 발생: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("사용자가 로그아웃 상태입니다.");
      } else {
        print("사용자가 로그인 상태입니다: ${user.email}");
      }
    });
    _fetchProtectedData();
    //_playBackgroundMusic();
    /*
    _lifecycleListener = AppLifecycleListener(
      onPause: () {
        _backgroundMusicPlayer.pause();
      },
      onResume: () {
        _backgroundMusicPlayer.resume();
      },
    );
    */
  }

  @override
  void dispose() {
    //_lifecycleListener.dispose();
    // _backgroundMusicPlayer.dispose();
    super.dispose();
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

  Widget _buildStoryCreationCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StoryGenerationPage()),
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

  Widget _buildBottomNavigationBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
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
            label: '꿈꾸는 이야기',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '꿈꾸는 이야기',
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
                      widget.user?.email ?? '테스트 중',
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
                  MaterialPageRoute(builder: (context) => Onboarding()),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.jpg'),
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
                  _buildSectionTitle('최근 동화'),
                  SizedBox(height: 16),
                  StoryCreationCarouselPage(),
                  SizedBox(height: 32),
                  _buildSectionTitle('인기 무료'),
                  SizedBox(height: 16),
                  StorySelectionPage(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
