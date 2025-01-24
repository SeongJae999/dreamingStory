import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dreamingstory/pages/account/register.dart';
import 'package:dreamingstory/pages/home.dart';
import 'package:dreamingstory/component/user.dart';
import 'package:dreamingstory/component/auth_service.dart';

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
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final response = await _authService.postRequest('/auth/login', {
        'email': email,
        'password': password,
      });

      user = await _authService.handleLoginResponse(response);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      }
    } catch (e) {
      setState(() {
        _error = '로그인 실패: $e';
      });
      print('로그인 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
          _error = 'Google 로그인 취소됨';
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String idToken = googleAuth.idToken!;

      final response = await _authService.postRequest('/auth/google_login', {
        'id_token': idToken,
      });

      user = await _authService.handleLoginResponse(response);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Google 로그인 중 오류가 발생했습니다: $e';
      });
      print('Google 로그인 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response =
          await _authService.postRequest('/auth/anonymous_login', {});

      user = await _authService.handleLoginResponse(response);

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      }
    } catch (e) {
      setState(() {
        _error = '익명 로그인 중 오류가 발생했습니다: $e';
      });
      print('익명 로그인 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
