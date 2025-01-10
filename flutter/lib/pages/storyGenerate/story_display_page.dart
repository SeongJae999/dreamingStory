import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'next_story_page.dart';

class StoryDisplayPage extends StatefulWidget {
  final String topic;

  const StoryDisplayPage({Key? key, required this.topic}) : super(key: key);

  @override
  _StoryDisplayPageState createState() => _StoryDisplayPageState();
}

class _StoryDisplayPageState extends State<StoryDisplayPage> {
  String? storyContent;
  String? firstNextStory;
  String? secondNextStory;
  String? imagePath;
  String? title;
  String? wisdom;
  String? audioUrl;
  Map<String, String>? story;
  bool isLoading = true;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchStory();
  }

  Future<void> _fetchStory() async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['NGROK_URL']}/stories/generate_story'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'topic': widget.topic}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          title = data['title'];
          story = Map<String, String>.from(data['story']);
          wisdom = data['wisdom'];
          audioUrl = data['audio_url'];
          imagePath = "assets/images/ssa.jpg";
          isLoading = false;
        });
      } else {
        throw Exception('스토리를 불러오는데 실패했습니다');
      }
    } catch (e) {
      setState(() {
        storyContent = '오류가 발생했습니다: $e';
        isLoading = false;
      });
    }
  }

  void playNarration() async {
    if (audioUrl != null) {
      try {
        await audioPlayer.play(UrlSource(audioUrl!));
        print("오디오 재생 성공.");
      } catch (e) {
        print("오디오 재생 오류: $e");
      }
    }
  }

  Future<String?> _generateImage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://eb88-222-239-25-12.ngrok-free.app/generate_image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('이미지 생성에 실패했습니다');
      }
    } catch (e) {
      setState(() {
        imagePath = '오류가 발생했습니다: $e';
      });
      return null;
    }
  }

  void _navigateToNextStory(String topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NextStoryPage(topic: topic),
      ),
    );
  }

  Widget _buildPage({
    required String? text,
    required String fallback,
    TextStyle? textStyle,
    required String? imagePath,
  }) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            text ?? fallback,
            style: textStyle ?? TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8.0),
          if (imagePath != null) Image.asset(imagePath) else Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('동화 이야기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // PageView를 Expanded로 감싸 화면을 차지하도록 함
                  Expanded(
                    child: PageView(
                      children: [
                        // 첫 페이지: 제목 표시
                        _buildPage(
                          text: title,
                          fallback: '제목이 없습니다.',
                          textStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          imagePath: imagePath,
                        ),
                        // story 맵의 각 항목에 대해 동적으로 페이지 생성
                        if (story != null)
                          ...story!.entries.map((entry) => _buildPage(
                                text: entry.value,
                                fallback: '${entry.key} 부분이 없습니다.',
                                imagePath: imagePath,
                              )),
                        // 마지막 페이지: 교훈 표시
                        _buildPage(
                          text: wisdom,
                          fallback: '교훈이 없습니다.',
                          imagePath: imagePath,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (audioUrl != null) {
                        playNarration();
                      } else {
                        print("오디오 URL이 없습니다.");
                      }
                    },
                    child: Text('내레이션 재생'),
                  ),
                ],
              ),
      ),
    );
  }
}
