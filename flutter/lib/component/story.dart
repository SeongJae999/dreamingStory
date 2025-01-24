class Story {
  final String title;
  final String imagePath;
  final String storyId;

  Story({required this.title, required this.imagePath, required this.storyId});
}

final List<Story> stories = [
  Story(
    title: '반짝이의 이빨 모험',
    imagePath: 'assets/무료 동화/반짝이의 이빨 모험/title.png',
    storyId: 'freeStory001',
  ),
  Story(
    title: '해와 달이 된 오누이',
    imagePath: 'assets/무료 동화/해와 달이 된 오누이/title.png',
    storyId: 'freeStory002',
  ),
  Story(
    title: '의좋은 형제',
    imagePath: 'assets/무료 동화/의좋은 형제/title.png',
    storyId: 'freeStory003',
  ),
  Story(
    title: '금도끼 은도끼',
    imagePath: 'assets/무료 동화/금도끼 은도끼/title.png',
    storyId: 'freeStory004',
  ),
];
