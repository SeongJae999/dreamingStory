import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dreamingstory/utils/login_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final baseUrl = dotenv.env['NGROK_URL'];
      final response = await http.post(Uri.parse('$baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          }));

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        setState(() {
          _error = '회원가입 실패: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _error = '예상치 못한 오류가 발생했습니다: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildGlassContainer(Size size) {
    double containerWidth = size.width;
    if (size.width > 600) {
      containerWidth = size.width * 0.6;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: containerWidth),
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
                      _buildNameField(),
                      SizedBox(height: size.height * 0.02),
                      _buildEmailField(),
                      SizedBox(height: size.height * 0.02),
                      _buildPasswordField(),
                      SizedBox(height: size.height * 0.02),
                      _buildConfirmPasswordField(),
                      SizedBox(height: size.height * 0.03),
                      _buildRegisterButton(),
                      SizedBox(height: size.height * 0.02),
                      _buildLoginButton(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const TextUtil(
        text: "이미 계정이 있으신가요? 로그인",
        fontFamily: 'GodoM',
        size: 14,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBottomText() {
    return const TextUtil(
      text: "회원가입 시 이용약관 및 개인정보 처리방침에 동의하게 됩니다.",
      fontFamily: 'GodoM',
      size: 12,
      color: Colors.white,
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : () {},
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
              text: "회원가입",
              fontFamily: 'GodoM',
              size: 16,
            ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextUtil(
          text: "비밀번호 확인",
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
            style: const TextStyle(color: Colors.white),
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              hintText: "비밀번호를 다시 입력하세요",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextUtil(
          text: "이름",
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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "이름을 입력하세요",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: const Icon(Icons.person_outline, color: Colors.white),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextUtil(
          text: "이메일 주소",
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
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
