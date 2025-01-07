import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dreamingstory/pages/account/register.dart';
import 'package:dreamingstory/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 텍스트 컨트롤러
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 폼 키
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _error;

  // GoogleSignIn 인스턴스 생성
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 로그인 함수
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 로그인 성공, AuthenticationWrapper가 HomePage로 이동
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

  // Google Sign-In 함수
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 기존 세션 로그아웃
      await _googleSignIn.signOut();

      // Google 로그인 시도
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // 사용자가 로그인 취소
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Firestore에 사용자 데이터 저장 (존재하지 않을 경우)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': userCredential.user!.email,
          'phone_number': userCredential.user!.phoneNumber,
          'created_at': FieldValue.serverTimestamp(),
          'is_active': true,
        });
      }
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

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Firebase 익명 로그인
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print('익명 로그인 성공: ${userCredential.user?.uid}');

      // 로그인 성공 후 홈 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      setState(() {
        _error = '익명 로그인에 실패했습니다.';
      });
      print('익명 로그인 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 컨트롤러 해제
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
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
                          _login();
                        }
                      },
                      child: const Text('로그인'),
                    ),
              SizedBox(height: 10),
              _isLoading
                  ? SizedBox()
                  : ElevatedButton.icon(
                      icon: Icon(Icons.login),
                      label: Text('Google로 로그인'),
                      onPressed: _signInWithGoogle,
                    ),
              SizedBox(height: 10),
              _isLoading
                  ? SizedBox()
                  : ElevatedButton(
                      onPressed: _signInAnonymously,
                      child: Text('익명 로그인'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
                child: const Text('계정이 없으신가요? 등록하기'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
