import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamingstory/pages/account/login.dart';
import 'package:dreamingstory/pages/help.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('알림 설정'),
            onTap: () {
              // 알림 설정 페이지로 이동
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('개인정보 보호'),
            onTap: () {
              // 개인정보 보호 페이지로 이동
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('언어 설정'),
            onTap: () {
              // 언어 설정 페이지로 이동
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('도움말 및 지원'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
          ListTile(
            title: Text(
              '로그아웃',
              style: TextStyle(
                fontFamily: 'GodoM',
                color: Color.fromARGB(255, 217, 123, 102),
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
