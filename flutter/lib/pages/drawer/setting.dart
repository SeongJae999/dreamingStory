import 'package:dreamingstory/pages/drawer/setting/account.dart';
import 'package:dreamingstory/pages/drawer/setting/privacy.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dreamingstory/pages/account/login.dart';
import 'package:dreamingstory/pages/drawer/setting/help.dart';

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
            leading: const Icon(Icons.account_box),
            title: const Text('계정 관리'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('앱 정보'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPage()),
              );
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
