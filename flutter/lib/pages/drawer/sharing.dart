import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SharingPage extends StatelessWidget {
  const SharingPage({Key? key}) : super(key: key);

  Future<void> _launchGitHub() async {
    const url = 'https://github.com/SeongJae999/dreamingStory';
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // 외부 브라우저에서 열기
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '공유',
          style: TextStyle(fontFamily: 'GodoB'),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 65, 89),
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 242, 210, 114),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '앱이 아직 마켓 플레이스에 등록되지 않았습니다.\n\'꿈꾸는 이야기\'의 홈페이지를 방문해보세요!',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'GodoM',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchGitHub,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 27, 65, 89),
                foregroundColor: const Color.fromARGB(255, 242, 210, 114),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'GodoM',
                ),
              ),
              child: const Text('홈페이지 열기'),
            ),
          ],
        ),
      ),
    );
  }
}
