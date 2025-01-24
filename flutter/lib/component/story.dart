class Story {
  final String title;
  final String imagePath;
  final String storyId;

  Story({required this.title, required this.imagePath, required this.storyId});
}

final List<Story> stories = [
  Story(
    title: '반짝이의 이빨 모험',
    imagePath: 'assets/title/teeth_title.png',
    storyId: 'freeStory001',
  ),
  Story(
    title: '해와 달이 된 오누이',
    imagePath: 'assets/title/sun_title.png',
    storyId: 'freeStory002',
  ),
  Story(
    title: '의좋은 형제',
    imagePath: 'assets/title/brothers_title.png',
    storyId: 'freeStory003',
  ),
    Story(
    title: '금도끼 은도끼',
    imagePath: 'assets/title/axes_title.png',
    storyId: 'freeStory004',
  ),

];
