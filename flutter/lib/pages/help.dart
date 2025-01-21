import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도움말 및 지원'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '자주 묻는 질문',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              question: '앱 사용 방법은?',
              answer: '메인 화면에서 원하는 기능을 선택하여 사용하세요.',
            ),
            _buildFAQItem(
              question: '계정 문제가 발생했어요',
              answer: '계정 설정에서 비밀번호 재설정을 시도해보세요.',
            ),
            const SizedBox(height: 24),
            const Text(
              '고객 지원',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('이메일 문의 (지원팀)'),
              subtitle: const Text('jeonlaejohgun@gmail.com'),
              onTap: () {
                // 이메일 보내기 기능 구현
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('전화 문의 (대표 조정민)'),
              subtitle: const Text('010-9891-3644'),
              onTap: () {
                // 전화 걸기 기능 구현
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '앱 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('버전 및 업데이트'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('현재 버전: test'),
                  Text('최신 버전: test'),
                  Text('업데이트 날짜: 2025-01-21')
                ],
              ),
              onTap: () {
                // 전화 걸기 기능 구현
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
