import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool _isTermsExpanded = false;
  bool _isPrivacyExpanded = false;
  bool _isMarketingConsent = true;
  bool _isNotificationConsent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 정보'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildExpandableSection(
                      title: '이용 약관',
                      isExpanded: _isTermsExpanded,
                      onToggle: (value) =>
                          setState(() => _isTermsExpanded = value),
                      content: const [
                        '''제1조 (목적)

이 약관은 앱 서비스(이하 "서비스")의 이용 조건 및 운영규칙, 회원과 운영자 간의 권리, 의무 등을 규정합니다. 서비스를 이용하고자 하는 모든 회원은 본 약관을 동의해야 합니다.

제2조 (회원 가입)

회원 가입은 본 약관에 동의 후 회원정보를 입력하여 완료됩니다. 허위 정보 입력 시 서비스 이용이 제한될 수 있습니다.

제3조 (서비스 이용)

회원은 서비스를 통해 제공되는 모든 콘텐츠를 법령 및 본 약관에서 허용하는 범위 내에서만 이용할 수 있습니다.

... (실제 이용약관 전문 추가) ...'''
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildExpandableSection(
                      title: '개인정보 처리방침',
                      isExpanded: _isPrivacyExpanded,
                      onToggle: (value) =>
                          setState(() => _isPrivacyExpanded = value),
                      content: const [
                        '''1. 수집하는 개인정보 항목

- 회원가입 시: 이메일, 비밀번호, 이름, 연락처

- 서비스 이용 시: IP 주소, 쿠키, 서비스 이용 기록

2. 개인정보 수집 목적

- 회원 관리 및 서비스 제공

- 신규 서비스 개발 및 마케팅 활용

3. 개인정보 보유 기간

- 회원 탈퇴 시 즉시 파기 (단, 법령 규정 시 예외 적용)

... (실제 개인정보처리방침 전문 추가) ...'''
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('마케팅 정보 수신 동의'),
                      subtitle: const Text('2025년 1월 22일에 동의하셨습니다.'),
                      value: _isMarketingConsent,
                      onChanged: (value) {
                        setState(() {
                          _isMarketingConsent = value;
                        });
                        // 마케팅 정보 수신 동의 설정 변경 로직 추가
                      },
                    ),
                    SwitchListTile(
                      title: const Text('알림 수신 동의'),
                      subtitle: const Text('2025년 1월 22일에 동의하셨습니다.'),
                      value: _isNotificationConsent,
                      onChanged: (value) {
                        setState(() {
                          _isNotificationConsent = value;
                        });
                        // 알림 수신 동의 설정 변경 로직 추가
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Version 1.0 (Test)\nIcons by Icons8',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required ValueChanged<bool> onToggle,
    required List<String> content,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onToggle(!isExpanded),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max, // ← 수정됨
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 300),
                        turns: isExpanded ? 0.5 : 0,
                        child: const Icon(
                            Icons.expand_more, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: content.map((text) =>
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              text,
                              style: const TextStyle(fontSize: 14),
                            ),
                          )).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

