import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dreamingstory/component/story.dart';

class Recent_Story {
  final String baseUrl;

  Recent_Story({required this.baseUrl});

  Future<List<RecentStory>> getRecentStories(String idToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories/recent_stories'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<RecentStory> stories =
          data.map((json) => RecentStory.fromJson(json)).toList();
      return stories;
    } else {
      throw Exception('Failed to load recent stories: ${response.body}');
    }
  }
}
