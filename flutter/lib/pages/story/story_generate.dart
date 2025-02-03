import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dreamingstory/component/auth_service.dart';
import 'package:dreamingstory/component/keyword.dart';
import 'package:dreamingstory/pages/story/story_display_page.dart';
import 'package:dreamingstory/pages/home.dart';
import 'package:dreamingstory/component/audioplayer.dart';

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
  String? taskId;
  bool isLoading = false;
  int currentStep = 0;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // 가로 모드 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // 세로 모드 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<http.Response> startStoryGeneration(String idToken) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['NGROK_URL']}/generate_stories/start_generation'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'topic': topic,
        'background': background,
        'character': character,
        'helper': helper,
        'atmosphere': atmosphere,
      }),
    );
    return response;
  }

  void _cancelGeneration() {
    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _handleSelection(String selection, List<String> items) async {
    try {
      await playbtnSoundMusic();
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
          setState(() {
            isLoading = true;
          });

          startStoryGeneration(idToken).then((response) {
            setState(() {
              isLoading = false;
            });
            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);

              setState(() {
                taskId = data['task_id'];
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('동화 생성이 완료되었습니다!')),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryDisplayPage(
                    response: response,
                    freeStory: false,
                    idToken: idToken,
                    taskId: taskId,
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
    String imagePath;
    if (items == characters) {
      imagePath = 'assets/button/등장인물/$title.png';
    } else if (items == backgrounds) {
      imagePath = 'assets/button/배경/$title.png';
    } else if (items == helpers) {
      imagePath = 'assets/button/조력자/$title.png';
    } else if (items == topics) {
      imagePath = 'assets/button/교훈/$title.png';
    } else if (items == atmospheres) {
      imagePath = 'assets/button/감정과 분위기/$title.png';
    } else {
      imagePath = 'assets/images/background.png';
    }

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
                  imagePath,
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
        return characters.map((c) => _buildCard(c, characters)).toList();
      case 1:
        return backgrounds.map((b) => _buildCard(b, backgrounds)).toList();
      case 2:
        return helpers.map((h) => _buildCard(h, helpers)).toList();
      case 3:
        return topics.map((t) => _buildCard(t, topics)).toList();
      case 4:
        return atmospheres.map((a) => _buildCard(a, atmospheres)).toList();
      default:
        return [];
    }
  }

  String _getAppBarTitle() {
    switch (currentStep) {
      case 0:
        return '주인공 선택하기';
      case 1:
        return '배경 선택하기';
      case 2:
        return '친구 선택하기';
      case 3:
        return '교훈 선택하기';
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
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          _getAppBarTitle(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'GodoB',
            color: Color.fromARGB(255, 242, 210, 114),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 27, 65, 89),
        actions: [
          if (currentStep > 0)
            IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 242, 210, 114)),
              onPressed: () {
                setState(() {
                  currentStep--;
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 242, 210, 114)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            )
        ],
      ),
      body: Container(
        color: Color.fromARGB(200, 27, 65, 89), // 단색으로 변경
        child: SafeArea(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (currentStep + 1) / 5,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 242, 210, 114),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: GridView.count(
                      key: ValueKey<int>(currentStep),
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.4,
                      children: _buildGridItems(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
