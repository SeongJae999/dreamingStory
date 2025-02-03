import 'package:dreamingstory/pages/drawer/setting/account.dart';
import 'package:dreamingstory/pages/drawer/setting/privacy.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamingstory/pages/account/login.dart';
import 'package:dreamingstory/pages/drawer/setting/help.dart';
import 'package:dreamingstory/component/audioplayer.dart';
import 'dart:ui';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(fontFamily: 'GodoB'),
        ),
        backgroundColor: const Color.fromARGB(255, 27, 65, 89),
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 242, 210, 114),
      ),
      body: Stack(
        children: [
          // // 배경 이미지 추가
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/background.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // // 흐림 효과 추가
          // BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          //   child: Container(
          //     color: Colors.black.withOpacity(0.3),
          //   ),
          // ),
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.account_box,
                      color: Color.fromARGB(255, 242, 210, 114)),
                  title: Text(
                    '계정 관리',
                    style: TextStyle(fontFamily: 'GodoM', fontSize: 16),
                  ),
                  onTap: () async {
                    await playbtnSoundMusic();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.device_unknown,
                      color: Color.fromARGB(255, 242, 210, 114)),
                  title: Text(
                    '앱 정보',
                    style: TextStyle(fontFamily: 'GodoM', fontSize: 16),
                  ),
                  onTap: () async {
                    await playbtnSoundMusic();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.info,
                      color: Color.fromARGB(255, 242, 210, 114)),
                  title: Text(
                    '도움말 및 지원',
                    style: TextStyle(fontFamily: 'GodoM', fontSize: 16),
                  ),
                  onTap: () async {
                    await playbtnSoundMusic();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    '로그아웃',
                    style: TextStyle(
                      fontFamily: 'GodoM',
                      color: Color.fromARGB(255, 217, 123, 102),
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    await playbtnSoundMusic();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
