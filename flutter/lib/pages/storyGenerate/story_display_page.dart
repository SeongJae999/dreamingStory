import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/pages/home.dart';

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
  bool _showTextContainer = false;
  int currentPageIndex = 0;
  String? _currentText;

  String? title;
  String? wisdom;
  String? first;
  String? second;
  String? third;
  String? forth;
  bool isLoading = true;
  Map<String, String>? audioUrls;
  Map<String, String>? imageUrls;
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
          audioUrls = Map<String, String>.from(data['audio_urls'] ?? {});
          imageUrls = Map<String, String>.from(data['image_urls'] ?? {});
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

  String? _getImagePath(String? text) {
    if (imageUrls != null && imageUrls!['first'] != null) {
      String imagePath = imageUrls!['first']!;

      // baseUrl을 사용하여 절대 경로로 변환
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        // 만약 이미 절대 URL이면 그대로 반환
        return imagePath;
      } else {
        // 상대 URL이라면 baseUrl과 합쳐서 절대 경로로 만듬
        Uri fullUri = Uri.parse(baseUrl!).resolve(imagePath);
        return fullUri.toString();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final PageController _pageController = PageController();

    List<Map<String, dynamic>> pageData = [
      {'text': title, 'fallback': '제목이 없습니다.'},
      {'text': first, 'fallback': '첫 번째 부분이 없습니다.'},
      {'text': second, 'fallback': '두 번째 부분이 없습니다.'},
      {'text': third, 'fallback': '세 번째 부분이 없습니다.'},
      {'text': forth, 'fallback': '네 번째 부분이 없습니다.'},
      {'text': wisdom, 'fallback': '교훈이 없습니다.'},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PageView(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  currentPageIndex = index;
                  _currentText = pageData[index]['text'] as String?;
                });

                // 페이지에 맞는 오디오 재생
                String? partKey;
                if (index == 0)
                  partKey = "title";
                else if (index == 1)
                  partKey = "first";
                else if (index == 2)
                  partKey = "second";
                else if (index == 3)
                  partKey = "third";
                else if (index == 4)
                  partKey = "forth";
                else if (index == 5) partKey = "wisdom";

                if (partKey != null) {
                  playNarration(partKey); // 해당 페이지의 오디오 재생
                }
              },
              children: pageData.map((data) {
                return Container(
                  decoration: _getImagePath(data['text'] as String?) != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_getImagePath(data['text'])!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  child: Center(
                    child: (currentPageIndex == 0)
                        ? Text(
                            data['text'] ?? data['fallback'],
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        : SizedBox(),
                  ),
                );
              }).toList(),
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
                  icon: Image.asset('assets/images/home.png',
                      width: 60, height: 60),
                ),
                SizedBox(width: 16.0),
                IconButton(
                  onPressed: () => playNarration("title"),
                  icon: Image.asset('assets/images/music.png',
                      width: 60, height: 60),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.0,
            top: MediaQuery.of(context).size.height / 2 - 32.0,
            child: IconButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(Icons.arrow_back_ios, size: 60, color: Colors.blue),
            ),
          ),
          Positioned(
            right: 16.0,
            top: MediaQuery.of(context).size.height / 2 - 32.0,
            child: IconButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icon(Icons.arrow_forward_ios, size: 60, color: Colors.blue),
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
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  (_currentText ?? '').replaceAll(r'\n', '\n'),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showTextContainer = !_showTextContainer;
          });
        },
        child: Icon(_showTextContainer ? Icons.close : Icons.text_fields),
      ),
    );
  }
}
