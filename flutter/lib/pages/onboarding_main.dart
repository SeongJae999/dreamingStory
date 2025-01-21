import 'package:dreamingstory/pages/account/login.dart';
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
            // Container(
            //   width: 250,
            //   height: 250,
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(20),
            //     child: Image.asset(
            //       'assets/images/ssa.jpg',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            SizedBox(height: 320),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  OnboardingPage(title: 'AI 창작 동화 : 꿈꾸는 이야기'),
                  OnboardingPage(title: '우리 아이에게 필요한 교훈을\n 입력할 수 있어요'),
                  OnboardingPage(title: '멋진 동화가 만들어졌다면\n 공유할 수 있어요'),
                  OnboardingPage(title: '우리 아이가 상상하는 것을\n 현실로 만들어줄 수 있어요'),
                  OnboardingPage(title: '무료 동화도 계속해서\n 업데이트 된답니다'),
                  OnboardingPage(title: '이제 동화의 세계로\n 뛰어들어 볼까요?'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _currentPage < 5
                  ? () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  : () {
                      _completeOnboarding();
                    },
              child: Text(_currentPage < 5 ? '다음' : '시작하기',
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
          children: List.generate(6, (index) {
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
