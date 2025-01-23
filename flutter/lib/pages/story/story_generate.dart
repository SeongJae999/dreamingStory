/*
import 'package:flutter/material.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/component/keyword.dart';
import 'package:dreamingstory/pages/story/story_display_page.dart';


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
  bool isLoading = false;

  void _handleSelection(String selection, List<String> items) {
    String? idToken = AuthService().idToken;

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
                    storyId: idToken!,
                    freeStory: false,
                    topic: topic,
                    background: background,
                    character: character,
                    helper: helper,
                    atmosphere: atmosphere,
                  )),
        );
      }
      currentStep++;
    });
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
*/
