import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StoryCreationCarousel extends StatefulWidget {
  @override
  _StoryCreationCarouselState createState() => _StoryCreationCarouselState();
}

class _StoryCreationCarouselState extends State<StoryCreationCarousel> {
  final List<String> imagePaths = [
    'assets/images/main01.png',
    'assets/images/main02.png',
    'assets/images/main03.png',
  ];

  final List<String> captions = [
    "이미지를 눌러 나만의 동화를 만들어보세요!", // 첫 번째 이미지에 대한 설명
    "창의적인 이야기를 지금 시작해보세요!", // 두 번째 이미지에 대한 설명
    "동화를 통해 상상력을 펼쳐보세요!", // 세 번째 이미지에 대한 설명
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5), // 슬라이드 간격을 5초로 조정
            autoPlayAnimationDuration:
                Duration(milliseconds: 800), // 부드러운 애니메이션
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imagePaths.asMap().entries.map((entry) {
            int index = entry.key;
            String imagePath = entry.value;
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
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 10, // 이미지 내부 상단 위치
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), // 반투명 배경
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      captions[index], // 해당 이미지의 설명
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagePaths.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => setState(() {
                _currentIndex = entry.key;
              }),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
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
