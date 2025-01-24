/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:text_scroll/text_scroll.dart';
import 'package:dreamingstory/component/story.dart';
import 'package:dreamingstory/pages/story/story_display_page.dart';

class StorySelection extends StatelessWidget {
  const StorySelection({Key? key}) : super(key: key);

  Future<http.Response> fetchStory(String storyId) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['NGROK_URL']}/stories/recent_stories'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'story_id': storyId}),
    );
    return response;
  }

  Widget _buildStoryCard(Story story, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StoryDisplayPage(storyId: story.storyId, freeStory: true),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.asset(
                    story.imagePath,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.bookmark,
                      color: Color.fromARGB(255, 217, 123, 102),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'GodoM',
            ),
            child: TextScroll(story.title),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 만든 동화 이야기',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'GodoB',
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
          children:
              stories.map((story) => _buildStoryCard(story, context)).toList(),
        ),
      ],
    );
  }
}
*/
