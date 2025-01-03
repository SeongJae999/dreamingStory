import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryDisplayPage extends StatefulWidget {
  final String topic;

  const StoryDisplayPage({Key? key, required this.topic}) : super(key: key);

  @override
  _StoryDisplayPageState createState() => _StoryDisplayPageState();
}

class _StoryDisplayPageState extends State<StoryDisplayPage> {
  String? storyContent;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStory();
  }

  Future<void> _fetchStory() async {
    try {
      final response = await http.post(
        Uri.parse('https://7066-222-239-25-12.ngrok-free.app/generate_story'),
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
                child: Text(
                  storyContent ?? '스토리를 불러올 수 없습니다.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }
}
