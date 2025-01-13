class userInfo {
  final String uid;
  final String? email;

  userInfo({required this.uid, this.email});

  factory userInfo.fromJson(Map<String, dynamic> json) {
    return userInfo(
      uid: json['uid'],
      email: json['email'],
    );
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? idToken;
}
