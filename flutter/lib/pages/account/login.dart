import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dreamingstory/pages/account/register.dart';
import 'package:dreamingstory/pages/home.dart';
import 'package:dreamingstory/component/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _error;
  userInfo? user;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<userInfo?> _makeAuthenticatedRequest(String idToken) async {
    try {
      final baseUrl = dotenv.env['NGROK_URL'];
      final response = await http.get(
        Uri.parse('$baseUrl/auth/current-user'),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = userInfo.fromJson(data);
        setState(() {
          print('\nAPI 응답: ${response.body}');
        });

        return user;
      } else {
        setState(() {
          print('\nAPI 요청 실패: ${response.statusCode} - ${response.body}');
        });
        return null;
      }
    } catch (e) {
      setState(() {
        print('\n요청 중 오류 발생: $e');
      });
      return null;
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String? idToken = await userCredential.user!.getIdToken();
      AuthService().idToken = idToken;

      user = await _makeAuthenticatedRequest(idToken!);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = '예상치 못한 오류가 발생했습니다.';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print('익명 로그인 성공: ${userCredential.user?.uid}');

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
