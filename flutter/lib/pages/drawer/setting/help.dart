import 'package:flutter/material.dart';
import 'package:dreamingstory/component/audioplayer.dart';
import 'package:dreamingstory/pages/drawer/setting/widget.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '도움말 및 지원',
          style: TextStyle(fontFamily: 'GodoB'),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 65, 89),
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 242, 210, 114),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSectionCard(
              title: '자주 묻는 질문',
              children: [
                buildFAQItem(
                  question: '앱 사용 방법은?',
                  answer: '메인 화면에서 원하는 기능을 선택하여 사용하세요.',
                ),
                const Divider(height: 1),
                buildFAQItem(
                  question: '계정 문제가 발생했어요',
                  answer: '계정 설정에서 비밀번호 재설정을 시도해보세요.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            buildSectionCard(
              title: '고객 지원',
              children: [
                buildContactTile(
                  icon: Icons.email,
                  title: '이메일 문의 (지원팀)',
                  subtitle: 'jeonlaejohgun@gmail.com',
                  onTap: () {
                    // 이메일 보내기 기능 구현
                  },
                ),
                const Divider(height: 1),
                buildContactTile(
                  icon: Icons.phone,
                  title: '전화 문의 (대표 조정민)',
                  subtitle: '010-9891-3644',
                  onTap: () {
                    // 전화 걸기 기능 구현
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
