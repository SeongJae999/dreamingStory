class Story {
  final String title;
  final String imagePath;
  final String storyId;

  Story({required this.title, required this.imagePath, required this.storyId});
}

final List<Story> stories = [
  Story(
    title: '반짝이의 이빨 모험',
    imagePath: 'assets/무료 동화/반짝이의 이빨 모험/images/intro.png',
    storyId: 'freeStory001',
  ),
  Story(
    title: '구름 궁전의 웃음 공주와 기다림의 마법',
    imagePath: 'assets/무료 동화/구름 궁전의 웃음 공주와 기다림의 마법/images/intro.png',
    storyId: 'freeStory002',
  ),
  Story(
    title: '흥부와 놀부',
    imagePath: 'assets/무료 동화/흥부와 놀부/images/intro.png',
    storyId: 'freeStory003',
  ),
];
