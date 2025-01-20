import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/pages/home.dart';
import 'package:lottie/lottie.dart';

class StoryDisplayPage extends StatefulWidget {
  final String topic;
  final String? background;
  final String? characters;
  final String? helper;
  final String? atmosphere;

  const StoryDisplayPage({
    Key? key,
    required this.topic,
    this.background,
    this.characters,
    this.helper,
    this.atmosphere,
  }) : super(key: key);

  @override
  _StoryDisplayPageState createState() => _StoryDisplayPageState();
}

class _StoryDisplayPageState extends State<StoryDisplayPage> {
  String? title;
  String? wisdom;
  String? first;
  String? second;
  String? third;
  String? forth;
  String? imagePath;
  bool isLoading = true;
  Map<String, String>? audioUrls;
  List<String> pageAudioKeys = [
    "title",
    "first",
    "second",
    "third",
    "forth",
    "wisdom"
  ];
  final AudioPlayer audioPlayer = AudioPlayer();
  final baseUrl = dotenv.env['NGROK_URL'];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _fetchStory();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _fetchStory() async {
    String? idToken = AuthService().idToken;

    if (idToken == null) throw Exception("유효한 인증 토큰이 없습니다.");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/stories/generate_story'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'topic': widget.topic,
          'background': widget.background,
          'characters': widget.characters,
          'helper': widget.helper,
          'atmosphere': widget.atmosphere
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          title = data['title'];
          first = data['story']['first'];
          second = data['story']['second'];
          third = data['story']['third'];
          forth = data['story']['forth'];
          wisdom = data['wisdom'];
<<<<<<< HEAD
          audioUrl = data['audio_url'];
          imagePath = "assets/images/반짝이.png";
=======
          audioUrls = Map<String, String>.from(data['audio_urls'] ?? {});
          imagePath = "assets/images/ssa.jpg";
>>>>>>> e6a3395705fdc9d466d9f2ecf3e3d5f8a26f4ccc
          isLoading = false;
        });
      } else {
        throw Exception('스토리를 불러오는데 실패했습니다');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('오류가 발생했습니다: $e');
    }
  }

  void playNarration(String partKey) async {
    if (audioUrls != null && audioUrls![partKey] != null) {
      try {
        Uri fullUri = Uri.parse(baseUrl!).resolve(audioUrls![partKey]!);
        await audioPlayer.play(UrlSource(fullUri.toString()));
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
    required String? imagePath,
  }) {
    bool isTitle = text == title;

    return Container(
      decoration: imagePath != null
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: isTitle // 제목 텍스트이면 가운데 정렬
          ? Center(
              child: Text(
                text ?? fallback,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GodoB'),
                textAlign: TextAlign.center,
              ),
            )
          : Align(
              // 그 외 텍스트는 좌하단 정렬
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  text ?? fallback,
                  style: textStyle ??
                      TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          backgroundColor: Colors.white,
                          fontFamily: 'GodoM'),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
<<<<<<< HEAD
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(child: Lottie.asset('assets/images/Main Scene.json'))
                : Column(
                    children: [
                      Expanded(
                        child: PageView(
                          children: pageData.map((data) {
                            return _buildPage(
                              text: data['text'] as String?,
                              fallback: data['fallback'] as String,
                              textStyle: data['textStyle'] as TextStyle?,
                              imagePath: imagePath,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
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
=======
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
        ),
        title: Text('동화 이야기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  ElevatedButton(
                    onPressed: () => playNarration("title"),
                    child: Text('내레이션 재생'),
                  ),
                  Expanded(
                    child: PageView(
                      onPageChanged: (int index) {
                        String? key;
                        if (index < pageAudioKeys.length) {
                          key = pageAudioKeys[index];
                        }
                        if (key != null) {
                          playNarration(key);
                        }
                      },
                      children: pageData.map((data) {
                        return _buildPage(
                          text: data['text'] as String?,
                          fallback: data['fallback'] as String,
                          textStyle: data['textStyle'] as TextStyle?,
                          imagePath: imagePath,
                        );
                      }).toList(),
                    ),
>>>>>>> e6a3395705fdc9d466d9f2ecf3e3d5f8a26f4ccc
                  ),
                ),
                SizedBox(width: 16.0), // 홈 버튼과 나레이션 버튼 사이 간격
                IconButton(
                  onPressed: playNarration, // 나레이션 재생 함수 호출
                  icon: Image.asset(
                    'assets/images/music.png', // 음악 아이콘 이미지 경로
                    width: 60,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
