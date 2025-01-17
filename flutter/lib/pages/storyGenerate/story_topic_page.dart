import 'package:flutter/material.dart';
import 'package:dreamingstory/pages/storyGenerate/story_background_page.dart';

class StoryTopicPage extends StatelessWidget {
  const StoryTopicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나만의 동화 만들기'),
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
                _buildTopicCard(
                    '친구와 함께 놀아요', 'assets/images/background.png', context),
                _buildTopicCard(
                    '맛있는 음식을 골고루 먹어요', 'assets/images/background.png', context),
                _buildTopicCard(
                    '양치질은 즐거워요', 'assets/images/background.png', context),
                _buildTopicCard(
                    '혼자서도 잘해요', 'assets/images/background.png', context),
                _buildTopicCard(
                    '잠자리에 일찍 들어요', 'assets/images/background.png', context),
                _buildTopicCard(
                    '엄마 아빠 말씀을 잘 들어요', 'assets/images/background.png', context),
                _buildTopicCard(
                    '정리정돈이 재미있어요', 'assets/images/background.png', context),
                _buildTopicCard(
                    '기다리는 것을 배워요', 'assets/images/background.png', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(String title, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryBackGroundPage(topic: title),
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
}
