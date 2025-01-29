// lib/pages/account/forgot_password.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dreamingstory/component/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _message;

  final AuthService _authService = AuthService();

  Future<void> _sendResetEmail() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final String email = _emailController.text.trim();

    try {
      final response = await _authService.postRequest(
        '/auth/forgot_password',
        {
          'email': email,
        },
        requiresAuth: false,
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = '비밀번호 재설정 이메일이 전송되었습니다.';
        });
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          _message = '오류: ${error['detail'] ?? '알 수 없는 오류'}';
        });
      }
    } catch (e) {
      setState(() {
        _message = '요청 중 오류가 발생했습니다: $e';
      });
      print('비밀번호 재설정 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 재설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_message != null) ...[
                Text(
                  _message!,
                  style: TextStyle(
                    color:
                        _message!.startsWith('오류') ? Colors.red : Colors.green,
                  ),
                ),
                SizedBox(height: 10),
              ],
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : '유효한 이메일을 입력하세요',
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _sendResetEmail();
                        }
                      },
                      child: const Text('비밀번호 재설정 이메일 보내기'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
