import 'package:flutter/material.dart';
import 'package:dreamingstory/pages/storyGenerate/bin/story_characters_page.dart';

class StoryBackGroundPage extends StatelessWidget {
  final String topic;
  const StoryBackGroundPage({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('배경 선택하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildBackgroundCard(
                    '겨울 왕국', 'assets/images/background.png', context),
                _buildBackgroundCard(
                    '마법 학교', 'assets/images/background.png', context),
                _buildBackgroundCard(
                    '구름 궁전', 'assets/images/background.png', context),
                _buildBackgroundCard(
                    '초록 언덕 마을', 'assets/images/background.png', context),
                _buildBackgroundCard(
                    '미래 도시', 'assets/images/background.png', context),
                _buildBackgroundCard(
                    '깊은 숲속', 'assets/images/background.png', context),
                _buildBackgroundCard(
                    '달빛에 반짝이는 호수', 'assets/images/background.png', context),
                _buildBackgroundCard(
                    '캔디 숲', 'assets/images/background.png', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundCard(
      String background, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryCharactersPage(
              topic: topic,
              background: background,
            ),
          ),
        );
      },
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
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                background,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
