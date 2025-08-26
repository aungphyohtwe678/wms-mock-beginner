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
    User(email: 'user1@example.com', password: 'password123', locale: 'en'),
    User(email: 'user2@example.com', password: 'pass4567', locale: 'ja'),
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
