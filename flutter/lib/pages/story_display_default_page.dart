import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // 데이터 로딩 상태
  bool isLoading = true;

  String? title, wisdom, first, second, third, forth;
  String? baseUrl;
  Map<String, String>? audioUrls;
  Map<String, String>? imageUrls;

  String? partKey;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _loadDataFromFirestore();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Firestore에서 데이터 불러오기
  Future<void> _loadDataFromFirestore() async {
    try {
      DocumentSnapshot storyDoc = await FirebaseFirestore.instance
          .collection('story')
          .doc('freeStory001')
          .get();

      if (storyDoc.exists) {
        Map<String, dynamic> data = storyDoc.data() as Map<String, dynamic>;
        setState(() {
          title = data['title'];
          first = data['story']['first'];
          second = data['story']['second'];
          third = data['story']['third'];
          forth = data['story']['forth'];
          wisdom = data['wisdom'];

          audioUrls = Map<String, String>.from(data['audio_urls'] ?? {});
          imageUrls = Map<String, String>.from(data['image_urls'] ?? {});
          baseUrl = 'assets/무료 동화/반짝이의 이빨 모험';
          isLoading = false; // 데이터 로딩 완료
        });
      }
    } catch (e) {
      print('Error loading data from Firestore: $e');
    }
  }

  void playNarration(String partKey) async {
    if (audioUrls != null && audioUrls![partKey] != null) {
      try {
        await audioPlayer.play(AssetSource(
            '${baseUrl?.replaceFirst('assets/', '') ?? ''}/audios/${audioUrls![partKey]}'));
        print("오디오 재생 성공.");
      } catch (e) {
        print("오디오 재생 오류: $e");
      }
    } else {
      print("오디오 URL이 없습니다.");
    }
  }

  // 이미지 경로 처리
  String? _getImagePath(String? text) {
    if (text == title) return baseUrl! + '/images/' + imageUrls!['intro']!;
    if (text == first) return baseUrl! + '/images/' + imageUrls!['intro']!;
    if (text == second)
      return baseUrl! + '/images/' + imageUrls!['development']!;
    if (text == third) return baseUrl! + '/images/' + imageUrls!['climax']!;
    if (text == forth) return baseUrl! + '/images/' + imageUrls!['conclusion']!;
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
                if (index == 0) {
                  partKey = "title";
                } else if (index == 1)
                  partKey = "first";
                else if (index == 2)
                  partKey = "second";
                else if (index == 3)
                  partKey = "third";
                else if (index == 4)
                  partKey = "forth";
                else if (index == 5) partKey = "wisdom";

                if (partKey != null) {
                  playNarration(partKey!); // 해당 페이지의 오디오 재생
                }
              },
              children: pageData.map((data) {
                bool isTitle = partKey == title;
                return Container(
                  decoration: _getImagePath(data['text'] as String?) != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_getImagePath(data['text'])!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  child: Center(
                      child: Align(
                    alignment: Alignment.bottomLeft,
                    child: isTitle
                        ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              data['text'] ?? data['fallback'],
                              style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'GodoB',
                                  backgroundColor: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          )
                        : SizedBox(),
                  )),
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
                  onPressed: () => playNarration("title"), // 수정 필요
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
