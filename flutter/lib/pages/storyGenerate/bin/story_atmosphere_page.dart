import 'package:flutter/material.dart';
import 'package:dreamingstory/pages/storyGenerate/story_display_page.dart';

class StoryAtmospherePage extends StatelessWidget {
  final String topic;
  final String background;
  final String character;
  final String helper;
  const StoryAtmospherePage(
      {Key? key,
      required this.topic,
      required this.background,
      required this.character,
      required this.helper})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('분위기 선택하기'),
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
                _buildAtmosphereCard(
                    '따뜻하고 행복한 이야기', 'assets/images/background.png', context),
                _buildAtmosphereCard(
                    '설레고 신나는 모험 이야기', 'assets/images/background.png', context),
                _buildAtmosphereCard(
                    '용기를 주는 이야기', 'assets/images/background.png', context),
                _buildAtmosphereCard(
                    '꿈처럼 환상적인 이야기', 'assets/images/background.png', context),
                _buildAtmosphereCard(
                    '포근하고 안락한 이야기', 'assets/images/background.png', context),
                _buildAtmosphereCard(
                    '웃음이 가득한 이야기', 'assets/images/background.png', context),
                _buildAtmosphereCard(
                    '반짝이는 희망의 이야기', 'assets/images/background.png', context),
                _buildAtmosphereCard(
                    '동화 같은 로맨틱 이야기', 'assets/images/background.png', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAtmosphereCard(
      String atmosphere, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDisplayPage(
              topic: topic,
              background: background,
              characters: character,
              helper: helper,
              atmosphere: atmosphere,
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
                atmosphere,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
