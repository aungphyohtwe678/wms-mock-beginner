import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'core/login_validators.dart';
import 'core/auth_service.dart';
import 'core/ui_constants.dart';
import 'core/login_messages.dart';
import 'top-menu.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  final Locale? userLocale;
  
  const LoginScreen({super.key, this.userLocale});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      
      final user = AuthService.authenticate(email, password);
      if (user != null) {
        // Change the app-wide locale
        final newLocale = Locale(user.locale);
        final appState = MyApp.of(context);
        if (appState != null) {
          appState.changeLocale(newLocale);
        }
        
        final message = user.locale == 'en' 
            ? LoginMessages.loginSuccessEn 
            : LoginMessages.loginSuccessJa;
            
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        
        // Navigate to TopMenuScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TopMenuScreen(userLocale: newLocale),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(LoginMessages.loginError)),
        );
      }
    }
  }

  Widget _buildLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/wms.svg',
          width: UiConstants.logoWidth,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: UiConstants.spacing8),
        const Text(
          LoginMessages.monolithText,
          style: TextStyle(
            color: UiConstants.primaryWhite,
            fontSize: UiConstants.fontSize24,
            fontWeight: FontWeight.bold,
            letterSpacing: UiConstants.letterSpacing10,
          ),
        ),
        const SizedBox(height: UiConstants.spacing4),
        const Text(
          LoginMessages.pikkingText,
          style: TextStyle(
            color: UiConstants.primaryWhite,
            fontSize: UiConstants.fontSize18,
            fontWeight: FontWeight.w500,
            letterSpacing: UiConstants.letterSpacing13,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                const Text(LoginMessages.userIdLabel),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    LoginMessages.voiceSettingsText,
                    style: TextStyle(fontSize: UiConstants.fontSize12),
                  ),
                ),
              ],
            ),
          ),
          _buildFormField(
            controller: _emailController,
            hintText: LoginMessages.emailHint,
            validator: LoginValidators.email,
          ),
          const SizedBox(height: UiConstants.spacing8),
          const Text(
            LoginMessages.lastLoginText,
            style: TextStyle(
              color: UiConstants.greyText,
              fontSize: UiConstants.fontSize12,
            ),
          ),
          const SizedBox(height: UiConstants.spacing16),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(LoginMessages.passwordLabel),
          ),
          _buildFormField(
            controller: _passwordController,
            hintText: LoginMessages.passwordHint,
            validator: LoginValidators.password,
            obscureText: true,
          ),
          const SizedBox(height: UiConstants.spacing8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                LoginMessages.forgotPasswordText,
                style: TextStyle(fontSize: UiConstants.fontSize12),
              ),
            ),
          ),
          const SizedBox(height: UiConstants.spacing16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: UiConstants.primaryBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiConstants.borderRadius8),
              ),
              padding: UiConstants.buttonPadding,
            ),
            onPressed: _handleLogin,
            child: const Text(
              LoginMessages.loginButtonText,
              style: TextStyle(
                fontSize: UiConstants.fontSize16,
                color: UiConstants.primaryWhite,
              ),
            ),
          ),
          const SizedBox(height: UiConstants.spacing20),
          const Center(
            child: Text(
              LoginMessages.copyrightText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UiConstants.greyText,
                fontSize: UiConstants.fontSize10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildLogo()),
            Container(
              decoration: const BoxDecoration(
                color: UiConstants.primaryWhite,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(UiConstants.borderRadius24),
                ),
              ),
              padding: UiConstants.containerPadding,
              child: _buildLoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}
