import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dreamingstory/pages/account/register.dart';
import 'package:dreamingstory/pages/account/forgot_password.dart';
import 'package:dreamingstory/pages/home.dart';
import 'package:dreamingstory/utils/login_text.dart';
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
  bool _isPasswordVisible = false;
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

      final response = await _authService.postRequest(
          '/auth/google_login',
          {
            'id_token': idToken,
          },
          requiresAuth: false);

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

  Widget _buildGlassContainer(Size size) {
    double containerWidth = size.width;
    if (size.width > 600) {
      containerWidth = size.width * 0.6;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: containerWidth,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
                padding: EdgeInsets.all(size.width > 600 ? 40 : 30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.04),
                      _buildEmailField(),
                      SizedBox(height: size.height * 0.02),
                      _buildPasswordField(),
                      SizedBox(height: size.height * 0.03),
                      _buildLoginButton(),
                      SizedBox(height: size.height * 0.02),
                      _buildDivider(),
                      SizedBox(height: size.height * 0.02),
                      _buildGoogleSignInButton(),
                      SizedBox(height: size.height * 0.02),
                      _buildSignUpButton(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "AI 창작 동화: 꿈꾸는 이야기",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontFamily: 'GodoB',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "동화는 도덕적 교훈과 시대적 해석 이상의 것입니다. \n동화를 통해 자란 아이는 세상을 현명하고, \n예의 바르게 살아가는 법을 배우게 됩니다. \n- S.T. Gibson -",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                  fontFamily: 'GodoM',
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextUtil(
          text: "아이디 (이메일 주소)",
          fontFamily: 'GodoM',
          size: 14,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.2),
          ),
          child: TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "이메일을 입력하세요",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const Icon(Icons.mail_outline, color: Colors.white),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextUtil(
          text: "비밀번호",
          fontFamily: 'GodoM',
          size: 14,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.2),
          ),
          child: TextFormField(
            controller: _passwordController,
            style: const TextStyle(color: Colors.white),
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: "비밀번호를 입력하세요",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _login();
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator()
          : const TextUtil(
              text: "로그인",
              fontFamily: 'GodoM',
              size: 16,
            ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _signInWithGoogle,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      icon: Image.asset(
        'assets/images/google_logo.png',
        height: 24,
      ),
      label: const TextUtil(
        text: "Google로 계속하기",
        fontFamily: 'GodoM',
        size: 16,
      ),
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: const TextUtil(
        text: "계정이 없으신가요? 회원가입",
        fontFamily: 'GodoM',
        size: 14,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextUtil(
            text: "또는",
            fontFamily: 'GodoM',
            size: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomText() {
    return TextUtil(
      text: "버전 : Test / 수정된 날짜 : 2025-01-30",
      fontFamily: 'GodoM',
      size: 12,
      color: Colors.white.withOpacity(0.7),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
              double horizontalPadding = size.width * 0.05;
              if (size.width > 600) {
                horizontalPadding = size.width * 0.2;
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.08),
                    _buildHeader(), // Responsive spacing
                    _buildGlassContainer(size),
                    SizedBox(height: size.height * 0.02),
                    _buildBottomText(),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
