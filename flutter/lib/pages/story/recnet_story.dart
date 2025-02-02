import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamingstory/component/auth_service.dart';
import 'package:dreamingstory/pages/story/story_display_page.dart';

class StoryCreationCarouselPage extends StatefulWidget {
  @override
  _StoryCreationCarouselState createState() => _StoryCreationCarouselState();
}

class _StoryCreationCarouselState extends State<StoryCreationCarouselPage> {
  bool isLoading = false;
  String? errorMessage;
  String? idToken;
  http.Response? storedResponse;

  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  final String? baseUrl = dotenv.env['NGROK_URL'];
  List<Map<String, dynamic>> stories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<http.Response> _fetchRecentStories() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("사용자가 로그인하지 않았습니다.");
    }

    idToken = await _authService.getFirebaseIdToken();
    if (idToken == null) {
      throw Exception("유효한 ID 토큰을 가져올 수 없습니다.");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/stories/recent_stories'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final listData = data["stories"];

    setState(() {
      stories = listData.map<Map<String, dynamic>>((item) {
        return {
          "text": item["text"] ?? '',
          "image_url": item["image_url"] ?? '',
        };
      }).toList();
    });

    return response;
  }

  Future<void> _loadStories() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _fetchRecentStories();
      storedResponse = response;

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final rawStories = data["stories"] as List<dynamic>?;
        if (rawStories != null) {
          List<Map<String, dynamic>> tempList = [];

          for (var doc in rawStories) {
            final parts = doc["parts"] ?? {};
            String text = "";
            String imageUrl = "";

            if (parts is Map) {
              for (var entry in parts.entries) {
                final partValue = entry.value;
                final pText = partValue["text"] ?? "";
                final pImage = partValue["image_url"] ?? "";
                if (pImage.isNotEmpty || pText.isNotEmpty) {
                  text = pText;
                  imageUrl = pImage;
                  break;
                }
              }
            }

            if (imageUrl.isEmpty) {
              continue;
            }

            tempList.add({
              "text": text,
              "image_url": imageUrl,
            });
          }

          setState(() {
            stories = tempList;
          });
        }
      } else {
        errorMessage = "서버 에러: ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      errorMessage = "$e";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const Center(child: Text('최근 스토리가 없습니다.'));

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: stories.length,
          itemBuilder: (context, index, realIndex) {
            final story = stories[index];
            final imageUrl = story["image_url"] ?? '';
            final title = story["text"] ?? '';
            final url = Uri.parse(baseUrl!).resolve(imageUrl).toString();

            return GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDisplayPage(
                      response: storedResponse!,
                      freeStory: true,
                      idToken: idToken,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: url.startsWith("http")
                              ? NetworkImage(url)
                              : AssetImage(url) as ImageProvider,
                          fit: BoxFit.cover,
                        )),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: stories.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = entry.key;
                });
              },
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
