// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:dreamingstory/component/user.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String? _baseUrl = dotenv.env['NGROK_URL'];

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<void> storeFirebaseIdToken(String token) async {
    await _secureStorage.write(key: 'firebase_id_token', value: token);
  }

  Future<String?> getFirebaseIdToken() async {
    String? token = await _secureStorage.read(key: 'firebase_id_token');
    if (token == null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        token = await user.getIdToken(true);
        await storeFirebaseIdToken(token!);
      }
    }
    return token;
  }

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    if (_baseUrl == null) {
      throw Exception('서버 URL이 설정되지 않았습니다.');
    }

    final url = Uri.parse('$_baseUrl$endpoint');

    final idToken = await getFirebaseIdToken();
    if (idToken == null) {
      throw Exception('Firebase ID 토큰을 가져올 수 없습니다. 다시 로그인하세요.');
    }

    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken'
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    final response = await http.post(
      url,
      headers: defaultHeaders,
      body: jsonEncode(body),
    );

    return response;
  }

  Future<http.Response> getRequest(String endpoint,
      {Map<String, String>? headers}) async {
    if (_baseUrl == null) {
      throw Exception('서버 URL이 설정되지 않았습니다.');
    }

    final url = Uri.parse('$_baseUrl$endpoint');

    final idToken = await getFirebaseIdToken();
    if (idToken == null) {
      throw Exception('Firebase ID 토큰을 가져올 수 없습니다. 다시 로그인하세요.');
    }

    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken'
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    final response = await http.get(
      url,
      headers: defaultHeaders,
    );

    return response;
  }

  Future<userInfo?> handleLoginResponse(http.Response response) async {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final idToken = data['id_token'];
      await storeFirebaseIdToken(idToken);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return userInfo.fromJson({
          'uid': user.uid,
          'email': user.email ?? '',
        });
      }
      return null;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['detail'] ?? '로그인 요청에 실패했습니다.');
    }
  }
}
