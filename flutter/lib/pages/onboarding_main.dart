import 'package:dreamingstory/pages/account/login.dart'; // 일단 home.dart로 연결시켜 놓겠습니다.
//import 'package:dreamingstory/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class OnboardingMain extends StatefulWidget {
  @override
  _OnboardingMainState createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final AudioPlayer _backgroundMusicPlayer = AudioPlayer();
  final AudioPlayer _buttonClickPlayer = AudioPlayer();

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_onboarded', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    await _backgroundMusicPlayer
        .setSource(AssetSource('audios/background.mp3'));
    _backgroundMusicPlayer.setVolume(0.5);
    _backgroundMusicPlayer.resume();
  }

  void _playButtonClickSound() async {
    await _buttonClickPlayer
        .setSource(AssetSource('audios/toy-button-105724.mp3'));
    _buttonClickPlayer.setVolume(1.0);
    _buttonClickPlayer.resume();
  }

  @override
  void dispose() {
    _backgroundMusicPlayer.dispose();
    _buttonClickPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(top: 140),
        child: Column(
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.2 * 255).round()),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Image 1',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  OnboardingPage(title: '꿈꾸는 이야기: START'),
                  OnboardingPage(title: '나만의 이야기를 만들어 보아요.'),
                  OnboardingPage(title: '내가 캐릭터의 주인공이 될 수 있어요.'),
                  OnboardingPage(title: '나만의 프로필을 설정해 보아요.'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _currentPage < 3
                  ? () {
                      _playButtonClickSound();
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  : () {
                      _playButtonClickSound();
                      _completeOnboarding();
                    },
              child: Text(_currentPage < 3 ? '다음' : '시작하기',
                  style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blueAccent : Colors.grey,
              ),
            );
          }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;

  const OnboardingPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
