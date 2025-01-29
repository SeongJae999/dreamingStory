import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dreamingstory/pages/home.dart';
import 'package:dreamingstory/pages/story/feedback.dart';

class StoryDisplayPage extends StatefulWidget {
  final http.Response response;
  final bool freeStory;

  final String? idToken;
  final String? taskId;
  final String? topic;
  final String? background;
  final String? character;
  final String? helper;
  final String? atmosphere;

  const StoryDisplayPage({
    Key? key,
    required this.response,
    required this.freeStory,
    this.idToken,
    this.taskId,
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
  String? currentText;
  String? currentImageUrl;
  String? currentAudioUrl;
  String? partKey;
  String? taskId;
  String statusMessage = "";
  int currentPartIndex = 0;
  bool isPlaying = false;
  bool isLoading = true;
  bool _hasStartedGeneration = false;

  Map<String, String?> storyParts = {
    "title": null,
    "first": null,
    "second": null,
    "third": null,
    "forth": null,
    "wisdom": null,
  };

  Map<String, String?> audioUrls = {};
  Map<String, String?> imageUrls = {};

  final AudioPlayer audioPlayer = AudioPlayer();
  final baseUrl = dotenv.env['NGROK_URL'];

  final List<String> pageKeys = [
    "title",
    "first",
    "second",
    "third",
    "forth",
    "wisdom"
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPageIndex);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    widget.freeStory ? _loadFreeStory() : _initStepwiseGeneration();
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _loadFreeStory() async {
    try {
      final data = jsonDecode(utf8.decode(widget.response.bodyBytes));

      if (!mounted) return;
      setState(() {
        storyParts = Map<String, String>.from(data['story'] ?? {})
          ..addAll({
            "title": data['title'] ?? "제목 없음",
            "wisdom": data['wisdom'] ?? "교훈이 없습니다.",
          });
        ;
        imageUrls = Map<String, String>.from(data['image_urls'] ?? {});
        audioUrls = Map<String, String>.from(data['audio_urls'] ?? {});
        isLoading = false;
      });
    } catch (e) {
      print('무료 동화 로드 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('무료 동화를 불러오는 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _initStepwiseGeneration() async {
    if (_hasStartedGeneration) {
      print(">>> start_generation 이미 호출됨. 스킵.");
      return;
    }
    _hasStartedGeneration = true;

    setState(() {
      isLoading = true;
      statusMessage = "start_generation 호출 중...";
    });

    print(">>> Calling start_generation");

    try {
      final startResponse = await http.post(
        Uri.parse('$baseUrl/generate_stories/start_generation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.idToken}'
        },
        body: jsonEncode({"topic": widget.topic ?? "내 동화 주제"}),
      );

      if (startResponse.statusCode == 200) {
        final data = jsonDecode(startResponse.body);
        taskId = data["task_id"];
        statusMessage = "Task created: $taskId";

        print(">>> Task created: $taskId");
        await _generateAndFetchPart("title");
      } else {
        statusMessage = "start_generation 실패: ${startResponse.body}";
        print(">>> start_generation 실패: ${startResponse.body}");
      }
    } catch (e) {
      print(">>> start_generation 예외 발생: $e");
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _generatePart(String part) async {
    if (taskId == null) {
      setState(() {
        statusMessage = "taskId가 없습니다. start_generation 먼저 호출하세요.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      statusMessage = "$part 파트 생성 요청 중...";
    });

    print(">>> Generating part: $part");

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/generate_stories/generate_part/$taskId/$part'),
        headers: {
          'Authorization': 'Bearer ${widget.idToken}',
        },
      );

      if (response.statusCode == 200) {
        statusMessage = "$part 파트 백그라운드 생성 시작";
        print(">>> $part 파트 백그라운드 생성 시작");
      } else {
        statusMessage = "$part 파트 생성 실패: ${response.body}";
        print(">>> $part 파트 생성 실패: ${response.body}");
      }
    } catch (e) {
      print(">>> generatePart($part) 예외 발생: $e");
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchPart(String part) async {
    if (taskId == null) {
      if (!mounted) return;
      setState(() {
        statusMessage = "taskId가 없습니다. start_generation 먼저 호출하세요.";
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      isLoading = true;
      statusMessage = "$part 파트를 불러오는 중...";
    });

    print(">>> Fetching part: $part");
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/generate_stories/fetch_part/$taskId/$part'),
        headers: {
          'Authorization': 'Bearer ${widget.idToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data["content"];
        print("Full response data: $data");
        print("data['content'] is: ${data['content']}");
        // content: { "text": "...", "image_url": "...", "audio_url": "..." }
        print("Fetched text for part '$part': ${content["text"]}");

        setState(() {
          storyParts[part] = content["text"];
          imageUrls[part] = content["image_url"];
          audioUrls[part] = content["audio_url"];
          statusMessage = "$part 파트 로드 성공!";
        });

        print(">>> $part 파트 로드 성공");
      } else {
        if (!mounted) return;
        setState(() {
          statusMessage = "$part 파트 로드 실패: ${response.body}";
        });
      }
    } catch (e) {
      print(">>> fetchPart($part) 예외 발생: $e");
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _generateAndFetchPart(String part) async {
    await _generatePart(part);

    bool partGenerated = false;
    int retryCount = 0;
    int maxRetries = 10;

    while (!partGenerated && retryCount < maxRetries) {
      await Future.delayed(Duration(seconds: 1));
      final statusResponse = await http.get(
        Uri.parse('$baseUrl/generate_stories/check_status/$taskId'),
        headers: {
          'Authorization': 'Bearer ${widget.idToken}',
        },
      );

      if (statusResponse.statusCode == 200) {
        final statusData = jsonDecode(statusResponse.body);
        if (statusData['parts'][part] != null) {
          partGenerated = true;
          break;
        }
      } else {
        print(">>> check_status 실패: ${statusResponse.body}");
      }

      retryCount++;
    }
    if (partGenerated) {
      await _fetchPart(part);
    } else {
      if (!mounted) return;
      setState(() {
        statusMessage = "$part 파트 생성 실패 또는 시간이 초과되었습니다.";
      });
      print(">>> $part 파트 생성 실패 또는 시간이 초과되었습니다.");
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  void _onPageChanged(int index) async {
    if (!mounted) return;
    setState(() {
      currentPageIndex = index;
    });

    if (index == pageKeys.length - 1) {
      FeedbackForm.showFeedbackForm(context);
      return;
    }

    if (widget.freeStory) return;

    final partKey = pageKeys[index];
    if (storyParts[partKey] != null) {
      print(">>> Part '$partKey' already exists. Skipping generation.");
      return;
    }
    await _generateAndFetchPart(partKey);
  }

  String getTextForPage(String pageKey) {
    print("getTextForPage($pageKey) => ${storyParts[pageKey]}");
    return storyParts[pageKey] ?? "내용을 불러오는 중입니다.";
  }

  String? _getImagePath(String partKey) {
    final url = imageUrls[partKey];
    if (url != null && url.isNotEmpty) {
      if (url.startsWith("http")) {
        return url;
      } else {
        return Uri.parse(baseUrl!).resolve(url).toString();
      }
    }
    return null;
  }

  Widget _buildPageContent(String partKey) {
    final path = _getImagePath(partKey);

    return Container(
      decoration: BoxDecoration(
        image: path != null
            ? DecorationImage(
                image: path.startsWith("http")
                    ? NetworkImage(path)
                    : AssetImage(path) as ImageProvider,
                fit: BoxFit.cover,
                colorFilter: partKey == 'title'
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      )
                    : null,
              )
            : null,
      ),
      child: partKey == 'title'
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  getTextForPage(partKey),
                  style: TextStyle(
                    fontFamily: 'GodoB',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.fill
                      ..color = Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(),
    );
  }

  void toggleNarration(String partKey) async {
    if (partKey.isEmpty) return;

    if (isPlaying) {
      await audioPlayer.pause();
      if (!mounted) return;
      setState(() {
        isPlaying = false;
      });
    } else {
      final audioUrl = audioUrls[partKey];
      if (audioUrl != null) {
        try {
          Uri fullUri = Uri.parse(baseUrl!).resolve(audioUrl);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: pageKeys.map((key) {
              return _buildPageContent(key);
            }).toList(),
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
                  onPressed: () {
                    toggleNarration(pageKeys[currentPageIndex]);
                  },
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
                if (_pageController.hasClients) {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
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
                if (_pageController.hasClients) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              icon: Image.asset(
                'assets/images/forward.png',
                width: 48,
                height: 48,
              ),
            ),
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
          if (_showTextContainer)
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  getTextForPage(pageKeys[currentPageIndex])
                      .replaceAll(r'\n', '\n'),
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontFamily: 'GodoM'),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: currentPageIndex != 0 && currentPageIndex != 5
          ? GestureDetector(
              onTap: () {
                if (!mounted) return;
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
