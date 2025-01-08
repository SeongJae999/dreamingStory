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

  @override
  void initState() {
    super.initState();
    _fetchStory();
  }

  Future<void> _fetchStory() async {
    try {
      final response = await http.post(
        Uri.parse('https://ac99-222-239-25-12.ngrok-free.app/generate_story'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'topic': widget.topic}),
      );

      if (response.statusCode == 200) {
        setState(() {
          storyContent = jsonDecode(response.body)['response'];
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
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      storyContent ?? '스토리를 불러올 수 없습니다.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
