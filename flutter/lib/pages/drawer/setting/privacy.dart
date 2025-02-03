import 'package:flutter/material.dart';
import 'package:dreamingstory/component/audioplayer.dart';
import 'package:dreamingstory/pages/drawer/setting/widget.dart';
import 'package:dreamingstory/pages/drawer/setting/terms.dart';

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
        title: const Text(
          '앱 정보',
          style: TextStyle(fontFamily: 'GodoB'),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 65, 89),
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 242, 210, 114),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildSectionCard(
                    title: '약관 및 정책',
                    children: [
                      buildExpandableTile(
                        title: '이용 약관',
                        isExpanded: _isTermsExpanded,
                        onTap: () => setState(
                            () => _isTermsExpanded = !_isTermsExpanded),
                        content: [
                          Text(policy, style: TextStyle(fontFamily: 'GodoM'))
                        ],
                      ),
                      const Divider(height: 1),
                      buildExpandableTile(
                        title: '개인정보 처리방침',
                        isExpanded: _isPrivacyExpanded,
                        onTap: () => setState(
                            () => _isPrivacyExpanded = !_isPrivacyExpanded),
                        content: [
                          Text(privacy, style: TextStyle(fontFamily: 'GodoM'))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildSectionCard(
                    title: '알림 설정',
                    children: [
                      buildSwitchTile(
                        title: '마케팅 정보 수신 동의',
                        subtitle: '2025년 1월 22일에 동의하셨습니다.',
                        value: _isMarketingConsent,
                        onChanged: (value) =>
                            setState(() => _isMarketingConsent = value),
                      ),
                      const Divider(height: 1),
                      buildSwitchTile(
                        title: '알림 수신 동의',
                        subtitle: '2025년 1월 22일에 동의하셨습니다.',
                        value: _isNotificationConsent,
                        onChanged: (value) =>
                            setState(() => _isNotificationConsent = value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          buildVersionInfo('1.0.0 / ICONS BY ICONS8'),
        ],
      ),
    );
  }
}
