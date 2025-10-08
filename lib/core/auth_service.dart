class User {
  final String email;
  final String password;
  final String locale;

  const User({
    required this.email,
    required this.password,
    required this.locale,
  });
}

class AuthService {
  static const List<User> _users = [
    User(email: 'user_en@email.com', password: 'Monolith@26', locale: 'en'),
    User(email: 'user_ja@email.com', password: 'Monolith@26', locale: 'ja'),
  ];

  static User? authenticate(String email, String password) {
    try {
      return _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
