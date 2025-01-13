import 'package:flutter/material.dart';
import 'package:dreamingstory/pages/storyGenerate/story_atmosphere_page.dart';

class StoryHelperPage extends StatelessWidget {
  final String topic;
  final String background;
  final String character;
  const StoryHelperPage(
      {Key? key,
      required this.topic,
      required this.background,
      required this.character})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도움말 선택하기'),
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
                _buildHelperCard(
                    '말하는 돌', 'assets/images/background.png', context),
                _buildHelperCard(
                    '말하는 책', 'assets/images/background.png', context),
                _buildHelperCard(
                    '마법 지팡이', 'assets/images/background.png', context),
                _buildHelperCard(
                    '작은 요정 친구', 'assets/images/background.png', context),
                _buildHelperCard(
                    '미소를 짓는 해님', 'assets/images/background.png', context),
                _buildHelperCard(
                    '장난꾸러기 바람', 'assets/images/background.png', context),
                _buildHelperCard(
                    '지혜로운 부엉이', 'assets/images/background.png', context),
                _buildHelperCard(
                    '빛나는 별', 'assets/images/background.png', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelperCard(
      String helper, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryAtmospherePage(
              topic: topic,
              background: background,
              character: character,
              helper: helper,
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
                helper,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
