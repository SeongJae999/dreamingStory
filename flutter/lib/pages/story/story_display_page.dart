import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dreamingstory/pages/home.dart';
import 'package:dreamingstory/pages/story/feedback.dart';
import 'package:lottie/lottie.dart';

class StoryDisplayPage extends StatefulWidget {
  final http.Response response;
  final bool freeStory;

  final String? topic;
  final String? background;
  final String? character;
  final String? helper;
  final String? atmosphere;

  const StoryDisplayPage({
    Key? key,
    required this.response,
    required this.freeStory,
    this.topic,
    this.background,
    this.character,
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
  String? partKey;
  bool isPlaying = false;

  String? title;
  String? wisdom;
  String? first;
  String? second;
  String? third;
  String? forth;
  bool isLoading = false;
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
    if (!widget.freeStory) isLoading = true;
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
    try {
      if (widget.response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(widget.response.bodyBytes));
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
        throw Exception('동화를 불러오는데 실패했습니다');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('오류가 발생했습니다: $e');
    }
  }

  void playNarration(String partKey) async {
    if (audioUrls![partKey] != null) {
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

  String? _getImagePath(String partKey) {
    if (partKey == 'title')
      partKey = 'first';
    else if (partKey == 'wisdom') partKey = 'forth';

    Map<String, String> imagePaths = {
      'first': imageUrls!['first']!,
      'second': imageUrls!['second']!,
      'third': imageUrls!['third']!,
      'forth': imageUrls!['forth']!,
    };

    Uri fullUri = Uri.parse(baseUrl!).resolve(imagePaths[partKey]!);
    return fullUri.toString();
  }

  Widget _buildPageContent(String partKey) {
    return Container(
      decoration: _getImagePath(partKey) != null
          ? BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_getImagePath(partKey)!),
                fit: BoxFit.cover,
              ),
            )
          : null,
      child: partKey == 'title'
          ? Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  title ?? '제목이 없습니다.',
                  style: TextStyle(
                    fontFamily: 'GodoB',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  String getTextForPage(String pageKey) {
    switch (pageKey) {
      case 'title':
        return title ?? '제목이 없습니다.';
      case 'first':
        return first ?? '첫 번째 부분이 없습니다.';
      case 'second':
        return second ?? '두 번째 부분이 없습니다.';
      case 'third':
        return third ?? '세 번째 부분이 없습니다.';
      case 'forth':
        return forth ?? '네 번째 부분이 없습니다.';
      case 'wisdom':
        return wisdom ?? '교훈이 없습니다.';
      default:
        return '알 수 없는 페이지';
    }
  }

  void toggleNarration() async {
    if (partKey == null) return;

    if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      if (audioUrls![partKey] != null) {
        try {
          Uri fullUri = Uri.parse(baseUrl!).resolve(audioUrls![partKey]!);
          await audioPlayer.play(UrlSource(fullUri.toString()));
          setState(() {
            isPlaying = true;
          });
        } catch (e) {
          print("오디오 재생 오류: $e");
        }
      } else {
        print("오디오 URL이 없습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    // String storyContent =
    //     widget.response != null ? widget.response.body : 'No content available';
    List<String> pageKeys = [
      'title',
      'first',
      'second',
      'third',
      'forth',
      'wisdom'
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(child: Lottie.asset('assets/images/Main Scene.json'))
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        currentPageIndex = index;
                        _currentText = getTextForPage(pageKeys[index]);
                      });

                      partKey = pageKeys[index];
                      if (index == 5) {
                        FeedbackForm.showFeedbackForm(context);
                      }
                    },
                    children: pageKeys.map((key) {
                      return _buildPageContent(key);
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
                        onPressed: toggleNarration,
                        icon: Image.asset(
                          isPlaying
                              ? 'assets/images/pause.png'
                              : 'assets/images/play.png',
                          width: 60,
                          height: 60,
                        ),
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
                    icon: Image.asset(
                      'assets/images/backward.png',
                      width: 48,
                      height: 48,
                    ),
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
                    icon: Image.asset(
                      'assets/images/forward.png',
                      width: 48,
                      height: 48,
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
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        (_currentText ?? '').replaceAll(r'\n', '\n'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'GodoM',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: currentPageIndex != 0 && currentPageIndex != 5
          ? GestureDetector(
        onTap: () {
          setState(() {
            _showTextContainer = !_showTextContainer;
          });
        },
        child: Image.asset(
          _showTextContainer
              ? 'assets/images/delete.png'
              : 'assets/images/chat.png',
          width: 56,
          height: 56,
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
