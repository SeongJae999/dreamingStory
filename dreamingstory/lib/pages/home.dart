import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 로그아웃 함수
    Future<void> _logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }

    return Scaffold(
      // AppBar에 뒤로가기 버튼 및 로그아웃 버튼 추가
      appBar: AppBar(
        title: const Text('홈'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _logout();
              // 로그아웃 후 자동으로 AuthenticationWrapper가 LoginPage로 전환됩니다.
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          '홈 화면입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
