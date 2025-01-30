class Story {
  final String title;
  final String imagePath;
  final String storyId;

  Story({required this.title, required this.imagePath, required this.storyId});
}

final List<Story> stories = [
  Story(
    title: '반짝이의 이빨 모험',
    imagePath: 'assets/freeStory/freeStory001/images/title.png',
    storyId: 'freeStory001',
  ),
  Story(
    title: '해와 달이 된 오누이',
    imagePath: 'assets/freeStory/freeStory002/images/title.png',
    storyId: 'freeStory002',
  ),
  Story(
    title: '의좋은 형제',
    imagePath: 'assets/freeStory/freeStory003/images/title.png',
    storyId: 'freeStory003',
  ),
  Story(
    title: '금도끼 은도끼',
    imagePath: 'assets/freeStory/freeStory004/images/title.png',
    storyId: 'freeStory004',
  ),
];

class RecentStory {
  final String storyId;
  final String title;
  final String imageUrl;
  final String audioUrl;
  final DateTime createdAt;

  RecentStory({
    required this.storyId,
    required this.title,
    required this.imageUrl,
    required this.audioUrl,
    required this.createdAt,
  });

  factory RecentStory.fromJson(Map<String, dynamic> json) {
    return RecentStory(
      storyId: json['storyId'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
