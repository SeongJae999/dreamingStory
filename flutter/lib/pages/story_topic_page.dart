import 'package:flutter/material.dart';
import 'package:dreamingstory/pages/story_display_page.dart';

class StoryTopicPage extends StatelessWidget {
  const StoryTopicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('나만의 동화 만들기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildTopicCard(
                '이빨을 잘 닦아요!', 'assets/images/background.png', context),
            _buildTopicCard(
                '친구들과 친하게 지내요!', 'assets/images/background.png', context),
            _buildTopicCard(
                '청소를 잘해요!', 'assets/images/background.png', context),
            _buildTopicCard(
                '어른들께 인사를 잘해요!', 'assets/images/background.png', context),
            _buildTopicCard(
                '똥을 잘 싸요!', 'assets/images/background.png', context),
            _buildTopicCard(
                '넘어져도 울지 않아요!', 'assets/images/background.png', context),
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
            builder: (context) => StoryDisplayPage(topic: title),
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
