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

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
