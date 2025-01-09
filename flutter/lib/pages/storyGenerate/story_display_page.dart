import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  bool isLoading = true;
  String? imagePath;
  String? title;
  String? first;
  String? second;
  String? third;
  String? forth;
  String? wisdom;

  @override
  void initState() {
    super.initState();
    _fetchStory();
  }

  Future<void> _fetchStory() async {
    try {
      final response = await http.post(
        Uri.parse('https://37d8-222-239-25-12.ngrok-free.app/generate_story'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'topic': widget.topic}),
      );

      if (response.statusCode == 200) {
        setState(() {
          title = jsonDecode(response.body)['title'];
          first = jsonDecode(response.body)['story']['first'];
          second = jsonDecode(response.body)['story']['second'];
          third = jsonDecode(response.body)['story']['third'];
          forth = jsonDecode(response.body)['story']['forth'];
          wisdom = jsonDecode(response.body)['wisdom'];
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
            : PageView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          title ?? '제목이 없습니다.',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        // 이미지 출력 부분
                        imagePath != null
                            ? Image.asset(imagePath!)
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          first ?? '첫 번째 부분이 없습니다.',
                          style: TextStyle(fontSize: 16),
                        ),
                        // 이미지 출력 부분
                        imagePath != null
                            ? Image.asset(imagePath!)
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          second ?? '두 번째 부분이 없습니다.',
                          style: TextStyle(fontSize: 16),
                        ),
                        // 이미지 출력 부분
                        imagePath != null
                            ? Image.asset(imagePath!)
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          third ?? '세 번째 부분이 없습니다.',
                          style: TextStyle(fontSize: 16),
                        ),
                        // 이미지 출력 부분
                        imagePath != null
                            ? Image.asset(imagePath!)
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          forth ?? '네 번째 부분이 없습니다.',
                          style: TextStyle(fontSize: 16),
                        ),
                        // 이미지 출력 부분
                        imagePath != null
                            ? Image.asset(imagePath!)
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          wisdom ?? '교훈이 없습니다.',
                          style: TextStyle(fontSize: 16),
                        ),
                        // 이미지 출력 부분
                        imagePath != null
                            ? Image.asset(imagePath!)
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
