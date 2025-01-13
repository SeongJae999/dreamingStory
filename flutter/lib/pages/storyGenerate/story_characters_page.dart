import 'package:flutter/material.dart';
import 'package:dreamingstory/pages/storyGenerate/story_helper_page.dart';

class StoryCharactersPage extends StatelessWidget {
  final String topic;
  final String background;
  const StoryCharactersPage(
      {Key? key, required this.topic, required this.background})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('캐릭터 선택하기'),
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
                _buildCharacterCard(
                    '소년', 'assets/images/background.png', context),
                _buildCharacterCard(
                    '소녀', 'assets/images/background.png', context),
                _buildCharacterCard(
                    '웃음 많은 공주님', 'assets/images/background.png', context),
                _buildCharacterCard(
                    '모험을 좋아하는 강아지', 'assets/images/background.png', context),
                _buildCharacterCard(
                    '웃음쟁이 아기 토끼', 'assets/images/background.png', context),
                _buildCharacterCard(
                    '용감한 꼬마 로봇', 'assets/images/background.png', context),
                _buildCharacterCard(
                    '작은 드래곤', 'assets/images/background.png', context),
                _buildCharacterCard(
                    '먹보 판다', 'assets/images/background.png', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(
      String character, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryHelperPage(
              topic: topic,
              background: background,
              character: character,
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
                character,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
