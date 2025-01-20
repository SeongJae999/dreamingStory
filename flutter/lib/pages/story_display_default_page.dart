import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:dreamingstory/pages/home.dart';

class StoryDisplayDefaultPage extends StatefulWidget {
  @override
  _StoryDisplayDefaultPageState createState() =>
      _StoryDisplayDefaultPageState();
}

class _StoryDisplayDefaultPageState extends State<StoryDisplayDefaultPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _showTextContainer = false;
  String? _currentText;
  int currentPageIndex = 0;
  String? title;
  String? wisdom;
  String? first;
  String? second;
  String? third;
  String? forth;
  String? firstImagePath;
  String? secondImagePath;
  String? thirdImagePath;
  String? forthImagePath;
  String? baseUrl;

  @override
  void initState() {
    super.initState();

    // ... 기본 데이터 설정 ...
    title = '반짝이의 이빨 모험';
    first =
        ''' 옛날 옛적에 반짝이라는 작은 토끼가 살았어요.\n 반짝이는 하얀 털과 긴 귀가 참 예뻤어요.\n 하지만 반짝이는 이를 닦는 걸 정말 싫어했어요.\n "싫어! 이 닦기 싫어!" 하고 매일 투덜거렸죠.''';
    second =
        ''' 어느 날, 반짝이의 이빨에 꼬마 세균들이 이사를 왔어요.\n 꼬마 세균들은 "야호! 맛있는 집이다!" 하며 신나게 춤을 췄어요.\n 반짝이의 이빨은 점점 누렇게 변해갔어요.\n "아야야, 이가 아파!" 반짝이가 울먹였어요.''';
    third =
        ''' 반짝이는 고민에 빠졌어요. "어떡하지? 이가 너무 아파."\n 그때 현명한 부엉이 선생님이 나타났어요.\n "반짝아, 이를 깨끗이 닦으면 세균들이 도망갈 거야."\n 반짝이는 용기를 내어 이를 닦기로 했어요.\n "치카치카 쓱싹쓱싹" 열심히 이를 닦았어요.''';
    forth =
        ''' 며칠 뒤, 반짝이의 이는 하얗게 반짝였어요.\n 꼬마 세균들은 "여긴 너무 깨끗해!" 하며 도망갔어요.\n 반짝이는 기뻐하며 말했어요. "와! 이 닦기 정말 좋아!"\n 그 후로 반짝이는 매일 즐겁게 이를 닦았답니다.''';

    firstImagePath = 'assets/무료 동화/반짝이의 이빨 모험/images/intro.png';
    secondImagePath = 'assets/무료 동화/반짝이의 이빨 모험/images/development.png';
    thirdImagePath = 'assets/무료 동화/반짝이의 이빨 모험/images/climax.png';
    forthImagePath = 'assets/무료 동화/반짝이의 이빨 모험/images/conclusion.png';
    baseUrl = 'assets/무료 동화/반짝이의 이빨 모험/audios/';
  }

  @override
  void dispose() {
    // 페이지에서 벗어날 때 다시 세로모드로 설정
    audioPlayer.stop();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void playNarration() async {
    String? audioUrl;
    switch (currentPageIndex) {
      case 0:
        audioUrl = 'title_narration.mp3';
        break;
      case 1:
        audioUrl = 'first_narration.mp3';
        break;
      case 2:
        audioUrl = 'second_narration.mp3';
        break;
      case 3:
        audioUrl = 'third_narration.mp3';
        break;
      case 4:
        audioUrl = 'forth_narration.mp3';
        break;
    }

    if (audioUrl != null) {
      try {
        await audioPlayer.setSource(AssetSource('$baseUrl$audioUrl'));
        audioPlayer.setVolume(1.0);
        audioPlayer.setReleaseMode(ReleaseMode.stop);
        await audioPlayer.resume();
        print("오디오 재생 성공.");
      } catch (e) {
        print("오디오 재생 오류: $e");
      }
    } else {
      print("오디오 URL이 없습니다.");
    }
  }

  Widget _buildPage({
    required String? text,
    required String fallback,
    TextStyle? textStyle,
  }) {
    String? imagePath;

    // 텍스트에 따라 이미지 경로 설정
    if (text == title) {
      imagePath = firstImagePath;
    } else if (text == first) {
      imagePath = firstImagePath;
    } else if (text == second) {
      imagePath = secondImagePath;
    } else if (text == third) {
      imagePath = thirdImagePath;
    } else if (text == forth) {
      imagePath = forthImagePath;
    }

    return Container(
      decoration: imagePath != null
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    //가로 모드
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final PageController _pageController = PageController();

    List<Map<String, dynamic>> pageData = [
      {
        'text': title,
        'fallback': '제목이 없습니다.',
        'textStyle': TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      },
      {
        'text': first,
        'fallback': '첫 번째 부분이 없습니다.',
      },
      {
        'text': second,
        'fallback': '두 번째 부분이 없습니다.',
      },
      {
        'text': third,
        'fallback': '세 번째 부분이 없습니다.',
      },
      {
        'text': forth,
        'fallback': '네 번째 부분이 없습니다.',
      },
      {
        'text': wisdom,
        'fallback': '교훈이 없습니다.',
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                    _currentText = index == 0
                        ? null
                        : index == 1
                            ? first
                            : index == 2
                                ? second
                                : index == 3
                                    ? third
                                    : index == 4
                                        ? forth
                                        : null;
                  });
                }, // PageController 설정
                children: pageData.map((data) {
                  return _buildPage(
                    text: data['text'] as String?,
                    fallback: data['fallback'] as String,
                    textStyle: data['textStyle'] as TextStyle?,
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/home.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                SizedBox(width: 16.0), // 홈 버튼과 나레이션 버튼 사이 간격
                IconButton(
                  onPressed: () {
                    playNarration;
                  }, // 나레이션 재생 함수 호출
                  icon: Image.asset(
                    'assets/images/music.png', // 음악 아이콘 이미지 경로
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            // 왼쪽 버튼
            left: 16.0,
            top: MediaQuery.of(context).size.height / 2 - 32.0, // 수직 중앙 정렬
            child: IconButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 60,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            // 오른쪽 버튼
            right: 16.0,
            top: MediaQuery.of(context).size.height / 2 - 32.0, // 수직 중앙 정렬
            child: IconButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 60,
                color: Colors.blue,
              ),
            ),
          ),
          if (_showTextContainer)
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7), // 반투명한 검정색 배경
                  borderRadius: BorderRadius.circular(8.0), // 모서리 둥근 정도
                ),
                child: Text(
                  _currentText ?? '', // 텍스트 내용
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상
                    fontSize: 16.0, // 텍스트 크기
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showTextContainer = !_showTextContainer; // 텍스트 컨테이너 표시 여부 반전
            if (_showTextContainer) {
              // 텍스트 컨테이너가 표시될 때 현재 페이지의 텍스트 설정
              switch (currentPageIndex) {
                case 1:
                  _currentText = first;
                  break;
                case 2:
                  _currentText = second;
                  break;
                case 3:
                  _currentText = third;
                  break;
                case 4:
                  _currentText = forth;
                  break;
                default:
                  _currentText = null;
              }
            } else {
              // 텍스트 컨테이너가 사라질 때 현재 텍스트 초기화
              _currentText = null;
            }
          });
        },
        child: Icon(_showTextContainer ? Icons.close : Icons.text_fields),
      ),
    );
  }
}
