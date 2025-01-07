import 'package:flutter/material.dart';
import '../home.dart';

class NextStoryPage extends StatelessWidget {
  final String topic;

  const NextStoryPage({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('다음 이야기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '선택한 주제: $topic',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // 여기에 선택한 이야기를 표시하는 위젯을 추가할 수 있습니다.
            Text(
              '여기에 선택한 이야기를 표시합니다.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // 종료 버튼 추가
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
              child: Text('스토리 종료'),
            ),
          ],
        ),
      ),
    );
  }
}
