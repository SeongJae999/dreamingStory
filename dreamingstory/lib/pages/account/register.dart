import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 텍스트 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // 폼 키
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _error;

  // 등록 함수
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 이메일과 비밀번호로 사용자 생성
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 사용자 ID 가져오기
      String userId = userCredential.user!.uid;

      // 추가 사용자 데이터를 Firestore에 저장
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': _emailController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
        'is_active': true,
      });

      // 등록 성공, 로그인 페이지로 돌아가기
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = '예상치 못한 오류가 발생했습니다.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // 컨트롤러 해제
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error != null) ...[
                Text(_error!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
              ],
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : '유효한 이메일을 입력하세요',
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: '전화번호'),
                validator: (value) => value != null && value.length >= 10
                    ? null
                    : '유효한 전화번호를 입력하세요',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) => value != null && value.length >= 6
                    ? null
                    : '최소 6자 이상 입력하세요',
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _register();
                        }
                      },
                      child: const Text('등록'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
