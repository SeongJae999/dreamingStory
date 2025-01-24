import 'dart:convert';
import 'package:dreamingstory/component/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dreamingstory/component/keyword.dart';
import 'package:dreamingstory/pages/story/story_display_page.dart';

class StoryGenerationPage extends StatefulWidget {
  const StoryGenerationPage({Key? key}) : super(key: key);

  @override
  _StoryGenerationPageState createState() => _StoryGenerationPageState();
}

class _StoryGenerationPageState extends State<StoryGenerationPage> {
  String? topic;
  String? background;
  String? character;
  String? helper;
  String? atmosphere;
  bool? isLoading;
  int currentStep = 0;
  final AuthService _authService = AuthService();

  Future<http.Response> fetchStory(String idToken) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['NGROK_URL']}/stories/generate_story'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'topic': topic,
        'background': background,
        'characters': characters,
        'helper': helper,
        'atmosphere': atmosphere
      }),
    );
    return response;
  }

  void _handleSelection(String selection, List<String> items) async {
    try {
      String? idToken = await _authService.getFirebaseIdToken();

      if (idToken == null) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('인증 토큰이 없습니다. 다시 로그인해주세요.')),
          );
        });
        return;
      }

      setState(() {
        if (items == topics) topic = selection;
        if (items == backgrounds) background = selection;
        if (items == characters) character = selection;
        if (items == helpers) helper = selection;
        if (items == atmospheres) {
          atmosphere = selection;

          fetchStory(idToken).then((response) {
            setState(() {
              isLoading = false;
            });
            if (response.statusCode == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryDisplayPage(
                    response: response,
                    freeStory: false,
                    topic: topic,
                    background: background,
                    character: character,
                    helper: helper,
                    atmosphere: atmosphere,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('스토리 생성 실패: ${response.body}')),
              );
            }
          });
        }
        currentStep++;
      });
    } catch (e) {
      print('스토리 생성 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스토리 생성 중 오류가 발생했습니다.')),
      );
    }
  }

  Widget _buildCard(String title, List<String> items) {
    return GestureDetector(
      onTap: () => _handleSelection(title, items),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  'assets/images/background.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGridItems() {
    switch (currentStep) {
      case 0:
        return topics.map((t) => _buildCard(t, topics)).toList();
      case 1:
        return backgrounds.map((b) => _buildCard(b, backgrounds)).toList();
      case 2:
        return characters.map((c) => _buildCard(c, characters)).toList();
      case 3:
        return helpers.map((h) => _buildCard(h, helpers)).toList();
      case 4:
        return atmospheres.map((a) => _buildCard(a, atmospheres)).toList();
      default:
        return [];
    }
  }

  String _getAppBarTitle() {
    switch (currentStep) {
      case 0:
        return '나만의 동화 만들기';
      case 1:
        return '배경 선택하기';
      case 2:
        return '캐릭터 선택하기';
      case 3:
        return '조력자 선택하기';
      case 4:
        return '분위기 선택하기';
      default:
        return '동화 만들기';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: _buildGridItems(),
              ),
            ),
            if (currentStep > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentStep--;
                  });
                },
                child: Text('이전 단계'),
              ),
          ],
        ),
      ),
    );
  }
}
