import 'package:flutter/material.dart';
import 'menu.dart'; // menu.dart をインポート

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
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
            .copyWith(
          primary: const Color(0xFF004593),
        ),
      ),
      home: const LoginPage(),
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

    // ログイン処理（省略）
    print('ログイン試行: ユーザー名=${_usernameController.text}, パスワード=${_passwordController.text}');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 画面タップでキーボード閉じる
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight, // AppBar分を除く
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // 上寄せ
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 60), // 上に余白を追加
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
                  width: MediaQuery.of(context).size.width * 0.8, // 幅80%
                  height: 48, // ボタン高さ固定
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // ボタンを黒く
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
    );
  }
}
