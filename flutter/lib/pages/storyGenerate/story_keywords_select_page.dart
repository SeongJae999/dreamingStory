import 'package:dreamingstory/pages/storyGenerate/story_display_page.dart';
import 'package:flutter/material.dart';

class StoryCreationPage extends StatefulWidget {
  const StoryCreationPage({Key? key}) : super(key: key);

  @override
  _StoryCreationPageState createState() => _StoryCreationPageState();
}

class _StoryCreationPageState extends State<StoryCreationPage> {
  String? topic;
  String? background;
  String? character;
  String? helper;
  String? atmosphere;
  int currentStep = 0;

  final List<String> topics = [
    '친구와 함께 놀아요',
    '맛있는 음식을 골고루 먹어요',
    '양치질은 즐거워요',
    '혼자서도 잘해요',
    '잠자리에 일찍 들어요',
    '엄마 아빠 말씀을 잘 들어요',
    '정리정돈이 재미있어요',
    '기다리는 것을 배워요',
  ];

  final List<String> backgrounds = [
    '겨울 왕국',
    '마법 학교',
    '구름 궁전',
    '초록 언덕 마을',
    '미래 도시',
    '깊은 숲속',
    '달빛에 반짝이는 호수',
    '캔디 숲',
  ];

  final List<String> characters = [
    '소년',
    '소녀',
    '웃음 많은 공주님',
    '모험을 좋아하는 강아지',
    '웃음쟁이 아기 토끼',
    '용감한 꼬마 로봇',
    '작은 드래곤',
    '먹보 판다',
  ];

  final List<String> helpers = [
    '말하는 돌',
    '말하는 책',
    '마법 지팡이',
    '작은 요정 친구',
    '미소를 짓는 해님',
    '장난꾸러기 바람',
    '지혜로운 부엉이',
    '빛나는 별',
  ];

  final List<String> atmospheres = [
    '따뜻하고 행복한 이야기',
    '설레고 신나는 모험 이야기',
    '용기를 주는 이야기',
    '꿈처럼 환상적인 이야기',
    '포근하고 안락한 이야기',
    '웃음이 가득한 이야기',
    '반짝이는 희망의 이야기',
    '동화 같은 사랑 이야기',
  ];

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

  Widget _buildCard(String title, List<String> items) {
    return GestureDetector(
      onTap: () => _handleSelection(title, items),
      child: Card(
        elevation: 4,
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

  void _handleSelection(String selection, List<String> items) {
    setState(() {
      if (items == topics) topic = selection;
      if (items == backgrounds) background = selection;
      if (items == characters) character = selection;
      if (items == helpers) helper = selection;
      if (items == atmospheres) {
        atmosphere = selection;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoryDisplayPage(
                    topic: topic!,
                    background: background,
                    characters: character,
                    helper: helper,
                    atmosphere: atmosphere,
                  )),
        );
      }
      currentStep++;
    });
  }
}
