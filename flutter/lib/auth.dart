// lib/auth_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true; // 로그인/회원가입 전환
  String _message = '';

  // 사용자 인증 처리 함수
  Future<void> _authenticate() async {
    try {
      UserCredential userCredential;
      if (_isLogin) {
        // 로그인
        userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // 회원가입
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Firestore에 사용자 데이터 추가
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': 'User Name', // 실제 사용자 이름으로 대체
          'email': _emailController.text.trim(),
          'age': 25, // 실제 사용자 나이로 대체
        });
      }

      // ID 토큰 획득
      String? idToken = await userCredential.user!.getIdToken();

      setState(() {
        _message = '인증 성공! UID: ${userCredential.user!.uid}';
      });

      // 인증된 API 요청 예제
      await _makeAuthenticatedRequest(idToken!);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = '인증 실패: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _message = '오류 발생: $e';
      });
    }
  }

  // 인증된 API 요청 함수
  Future<void> _makeAuthenticatedRequest(String idToken) async {
    final url =
        Uri.parse('http://10.0.2.2:8000/auth/current-user'); // FastAPI 엔드포인트

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _message += '\nAPI 응답: ${response.body}';
        });
      } else {
        setState(() {
          _message += '\nAPI 요청 실패: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _message += '\n요청 중 오류 발생: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_isLogin ? '로그인' : '회원가입'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: '이메일'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authenticate,
                child: Text(_isLogin ? '로그인' : '회원가입'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin ? '회원가입이 필요하신가요?' : '로그인이 필요하신가요?'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(_message),
                ),
              ),
            ],
          ),
        ));
  }
}
