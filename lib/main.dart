import 'package:flutter/material.dart';
import 'menu.dart';

const String accessPassword = 'a9d72c5b418de730';

void main() {
  runApp(const Gatekeeper());
}

class Gatekeeper extends StatelessWidget {
  const Gatekeeper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新WMS App',
      theme: ThemeData(
        primaryColor: const Color(0xFF004593),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 14,
            fontFamily: 'Helvetica Neue',
            color: Colors.black,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004593))
            .copyWith(primary: const Color(0xFF004593)),
      ),
      home: const AccessGate(),
    );
  }
}

class AccessGate extends StatefulWidget {
  const AccessGate({super.key});

  @override
  State<AccessGate> createState() => _AccessGateState();
}

class _AccessGateState extends State<AccessGate> {
  final _controller = TextEditingController();
  String _error = '';

  void _checkAccess() {
    if (_controller.text == accessPassword) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      setState(() {
        _error = 'パスワードが違います';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'パスワードを入力してください',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '16桁のアクセスパスワード',
                ),
              ),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkAccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$'); // 簡易メールアドレス判定

  void _login() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'ユーザー名とパスワードを入力してください。';
      });
      return;
    }

    if (!_emailRegex.hasMatch(_usernameController.text)) {
      setState(() {
        _errorMessage = '正しいメールアドレス形式で入力してください。';
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text(
                  '新WMS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.8,
                    fontFamily: 'Helvetica Neue',
                  ),
                ),
                centerTitle: true,
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 60),
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'ユーザー名（メールアドレス）',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 14, fontFamily: 'Helvetica Neue'),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'パスワード',
                            border: OutlineInputBorder(),
                          ),
                          style: const TextStyle(fontSize: 14, fontFamily: 'Helvetica Neue'),
                        ),
                        const SizedBox(height: 10),
                        if (_errorMessage.isNotEmpty)
                          Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 344,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'ログイン',
                              style: TextStyle(fontSize: 16, fontFamily: 'Helvetica Neue'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
