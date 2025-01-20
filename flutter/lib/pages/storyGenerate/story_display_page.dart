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

  Widget _buildPage({
    required String? text,
    required String fallback,
    TextStyle? textStyle,
    String? partKey,
  }) {
    String? fullImageUrl;
    if (imageUrls != null && imageUrls![partKey] != null)
      fullImageUrl =
          Uri.parse(baseUrl!).resolve(imageUrls![partKey]!).toString();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            text ?? fallback,
            style: textStyle ?? TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8.0),
          if (fullImageUrl != null) Image.network(fullImageUrl)
        ],
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
        'imageUrl': imageUrls?['first'],
      },
      {
        'text': first,
        'fallback': '첫 번째 부분이 없습니다.',
        'imageUrl': imageUrls?['first'],
      },
      {
        'text': second,
        'fallback': '두 번째 부분이 없습니다.',
        'imageUrl': imageUrls?['first'],
      },
      {
        'text': third,
        'fallback': '세 번째 부분이 없습니다.',
        'imageUrl': imageUrls?['first'],
      },
      {
        'text': forth,
        'fallback': '네 번째 부분이 없습니다.',
        'imageUrl': imageUrls?['first'],
      },
      {
        'text': wisdom,
        'fallback': '교훈이 없습니다.',
        'imageUrl': imageUrls?['first'],
      },
    ];

    return Scaffold(
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
                          partKey: "first" as String?,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
