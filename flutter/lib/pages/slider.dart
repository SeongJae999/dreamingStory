import 'package:dreamingstory/component/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dreamingstory/component/story.dart';
import 'package:dreamingstory/component/auth_service.dart';
import 'package:dreamingstory/pages/story/recent_story.dart';

class StoryCreationCarouselPage extends StatefulWidget {
  @override
  _StoryCreationCarouselState createState() => _StoryCreationCarouselState();
}

class _StoryCreationCarouselState extends State<StoryCreationCarouselPage> {
  late Future<List<RecentStory>> _recentStoriesFuture;
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final AuthService _authService = AuthService();

  final String? baseUrl = dotenv.env['NGROK_URL'];

  @override
  void initState() {
    super.initState();
    _recentStoriesFuture = _fetchRecentStories();
  }

  Future<List<RecentStory>> _fetchRecentStories() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("사용자가 로그인하지 않았습니다.");
    }

    String? idToken = await _authService.getFirebaseIdToken();
    return Recent_Story(baseUrl: baseUrl!).getRecentStories(idToken!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecentStory>>(
      future: _recentStoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('최근 동화가 없습니다.'));
        } else {
          final stories = snapshot.data!;
          return Column(
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController,
                itemCount: stories.length,
                options: CarouselOptions(
                  height: 250,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final story = stories[index];
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            story.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Icon(Icons.error));
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 10,
                        right: 10,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            story.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: stories.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(
                                _currentIndex == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
