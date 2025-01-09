import 'package:flutter/material.dart';
import '../home.dart';

class NextStoryPage extends StatelessWidget {
  final String topic;

  const NextStoryPage({Key? key, required this.topic}) : super(key: key);

  // 필요한 경우 텍스트와 스타일을 재사용할 수 있는 헬퍼 함수
  Widget _buildSection({required String text, required TextStyle style}) {
    return Text(
      text,
      style: style,
    );
  }

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
            _buildSection(
              text: '선택한 주제: $topic',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildSection(
              text: '여기에 선택한 이야기를 표시합니다.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
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
