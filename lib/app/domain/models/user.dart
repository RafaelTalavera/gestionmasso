class User {
  User({required this.token});

  // Constructor con nombre para crear un User desde un Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(token: map['token']);
  }

  final String token;
}
