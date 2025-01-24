import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dreamingstory/component/story.dart';
import 'package:dreamingstory/pages/story/story_display_page.dart';

class StorySelectionPage extends StatefulWidget {
  const StorySelectionPage({Key? key}) : super(key: key);

  @override
  _StorySelectionState createState() => _StorySelectionState();
}

class _StorySelectionState extends State<StorySelectionPage> {
  Future<http.Response> fetchStory(String storyId) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['NGROK_URL']}/stories/free_story'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'story_id': storyId}),
    );
    return response;
  }

  Widget _buildStoryCard(Story story, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        http.Response response = await fetchStory(story.storyId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StoryDisplayPage(response: response, freeStory: true),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                story.imagePath,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  story.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GodoM',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
