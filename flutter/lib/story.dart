import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Story {
  final String id;
  final String title;
  final String content;
  final List<String> imageIds;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.imageIds,
  });

  factory Story.fromFirestore(Map<String, dynamic> data, String id) {
    var rawImageIds = data['image_ids'];
    List<String> imageIds;

    if (rawImageIds is String) {
      imageIds = rawImageIds.split(',').map((e) => e.trim()).toList();
    } else if (rawImageIds is Iterable) {
      imageIds = List<String>.from(rawImageIds);
    } else {
      imageIds = [];
    }

    return Story(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageIds: imageIds,
    );
  }
}

class ImageData {
  final String id;
  final String storyId;
  final String filePath;
  final DateTime createdAt;

  ImageData({
    required this.id,
    required this.storyId,
    required this.filePath,
    required this.createdAt,
  });

  factory ImageData.fromFirestore(Map<String, dynamic> data, String id) {
    // created_at 필드를 처리할 때 타입 확인
    DateTime parsedCreatedAt;
    var createdAtField = data['created_at'];

    if (createdAtField is Timestamp) {
      // Firestore Timestamp 타입인 경우
      parsedCreatedAt = createdAtField.toDate();
    } else if (createdAtField is String) {
      // 문자열인 경우 ISO8601 형식으로 파싱
      parsedCreatedAt = DateTime.parse(createdAtField);
    } else {
      // 기본값 또는 예외 처리
      parsedCreatedAt = DateTime.now();
    }

    return ImageData(
      id: id,
      storyId: data['story_id'] ?? '',
      filePath: data['image_url'] ?? '',
      createdAt: parsedCreatedAt,
    );
  }
}

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<Story> getStoryWithImages(String storyId) async {
  // 1. 동화 가져오기
  DocumentSnapshot storySnapshot =
      await firestore.collection('story').doc(storyId).get();
  Story story = Story.fromFirestore(
      storySnapshot.data() as Map<String, dynamic>, storySnapshot.id);

  // 2. 동화와 연관된 이미지들 가져오기
  QuerySnapshot imageQuery = await firestore
      .collection('image')
      .where('story_id', isEqualTo: storyId)
      .get();

  List<ImageData> images = imageQuery.docs.map((doc) {
    return ImageData.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }).toList();

  // 필요에 따라 Story 모델에 이미지 리스트를 포함하도록 확장 가능
  // 예를 들어, Story 클래스에 List<ImageData> images; 필드를 추가하고 설정할 수 있습니다.

  // 여기서는 story와 images를 함께 반환하지 않고 따로 사용.
  // 필요에 따라 두 데이터를 묶어 반환하는 방법을 선택하세요.

  // 예시에서는 story만 반환하고, images는 따로 관리
  return story;
}

class StoryScreen extends StatelessWidget {
  final String storyId;

  const StoryScreen({Key? key, required this.storyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('story').doc(storyId).get(),
      builder: (context, storySnapshot) {
        if (storySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!storySnapshot.hasData || !storySnapshot.data!.exists) {
          return const Center(child: Text('스토리를 찾을 수 없습니다.'));
        }

        // 스토리 데이터 추출
        var storyData = storySnapshot.data!.data() as Map<String, dynamic>;
        Story story = Story.fromFirestore(storyData, storySnapshot.data!.id);

        return Scaffold(
          appBar: AppBar(title: Text(story.title)),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(story.content, style: const TextStyle(fontSize: 16)),
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('image')
                      .where('story_id', isEqualTo: storyId)
                      .get(),
                  builder: (context, imageSnapshot) {
                    if (imageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!imageSnapshot.hasData) {
                      return const Center(child: Text('이미지를 불러올 수 없습니다.'));
                    }

                    List<ImageData> images =
                        imageSnapshot.data!.docs.map((doc) {
                      return ImageData.fromFirestore(
                          doc.data() as Map<String, dynamic>, doc.id);
                    }).toList();

                    return ListView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        final image = images[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text('이미지 ID: ${image.id}'),
                              // 여기서 image.filePath를 NetworkImage나 다른 방식으로 불러올 수 있음
                              Image.asset(image.filePath),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
