import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:otk_wms_mock/login.dart';
import 'package:otk_wms_mock/top-menu.dart';
import 'l10n/app_localizations.dart';

const String accessPassword = 'aaaa';
Locale _locale = Locale('ja');

void main() {
  runApp(const Gatekeeper());
}

class Gatekeeper extends StatelessWidget {
  const Gatekeeper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '新WMS',
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
      locale: _locale, 
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ja'), // Japanese
      ],
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

  late String currentLanguage;

  void _checkAccess() {
    if (_controller.text == accessPassword) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      setState(() {
        _error = AppLocalizations.of(context)!.password_incorrect;
      });
    }
  }

  void _changeLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? Locale('ja') : Locale('en');
    });

    // 言語変更を適用するにはアプリ全体を再ビルドする
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Gatekeeper()),
    );
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
              Text(
                AppLocalizations.of(context)!.enter_password,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.access_password_hint,
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
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _checkAccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.black.withOpacity(0.3),
                    elevation: 6,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeLanguage,
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        tooltip: _locale.languageCode == 'en' ? 'Switch to Japanese' : '英語に切り替える',
        child: Text(_locale.languageCode == 'en' ? 'JP' : 'EN'),
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
  final TextEditingController _usernameController =
      TextEditingController(text: 'user@example.com');

  final TextEditingController _passwordController =
      TextEditingController(text: 'password123');

  String _errorMessage = '';
  final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  void _login() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.username_password_required;
      });
      return;
    }

    if (!_emailRegex.hasMatch(_usernameController.text)) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.email_format_error;
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const TopMenuScreen(),
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
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.zero,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.zero, // 角丸なし
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.new_wms,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 60),
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.username_email,
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 16, fontFamily: 'Helvetica Neue'),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.password,
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(fontSize: 16, fontFamily: 'Helvetica Neue'),
                            ),
                            const SizedBox(height: 12),
                            if (_errorMessage.isNotEmpty)
                              Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            const SizedBox(height: 32),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: TextStyle(fontSize: 18, fontFamily: 'Helvetica Neue'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
    ),
  );
}
}