import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 보호'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '개인정보 처리 방침',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. 수집하는 개인정보 항목\n'
              '- 이메일 주소, 전화번호 등 기본 계정 정보\n'
              '- 서비스 이용 기록 및 기기 정보\n\n'
              '2. 개인정보의 수집 및 이용 목적\n'
              '- 서비스 제공 및 개선\n'
              '- 고객 지원 및 문의 처리\n\n'
              '3. 개인정보의 보유 및 이용 기간\n'
              '- 회원 탈퇴 시 또는 법정 보유기간까지\n\n'
              '4. 개인정보의 제3자 제공\n'
              '- 법령에 의한 경우를 제외하고는 제3자에게 제공하지 않음',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text(
              '개인정보 설정',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('마케팅 정보 수신 동의'),
              subtitle: const Text('2025년 1월 22일에 동의하셨습니다.'),
              value: true,
              onChanged: (value) {
                // 마케팅 정보 수신 동의 설정 변경
              },
            ),
            SwitchListTile(
              title: const Text('알림 수신 동의'),
              subtitle: const Text('2025년 1월 22일에 동의하셨습니다.'),
              value: true,
              onChanged: (value) {
                // 알림 수신 동의 설정 변경
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {
                  // 개인정보 처리 방침 전체 보기
                },
                child: const Text('전체 개인정보 처리 방침 보기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
