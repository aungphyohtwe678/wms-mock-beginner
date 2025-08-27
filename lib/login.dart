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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Constrain SVG size for Safari compatibility
        SizedBox(
          width: UiConstants.logoWidth,
          height: UiConstants.logoWidth * 0.6, // Maintain aspect ratio
          child: SvgPicture.asset(
            'assets/images/wms.svg',
            width: UiConstants.logoWidth,
            fit: BoxFit.contain,
            // Add Safari-specific properties
            placeholderBuilder: (BuildContext context) => Container(
              width: UiConstants.logoWidth,
              height: UiConstants.logoWidth * 0.6,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: UiConstants.spacing8),
        const Text(
          LoginMessages.monolithText,
          style: TextStyle(
            color: UiConstants.primaryWhite,
            fontSize: UiConstants.fontSize24,
            fontWeight: FontWeight.bold,
            letterSpacing: UiConstants.letterSpacing2,
            fontFamily: 'Arial', // Fallback font for Safari
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: UiConstants.spacing4),
        const Text(
          LoginMessages.pikkingText,
          style: TextStyle(
            color: UiConstants.primaryWhite,
            fontSize: UiConstants.fontSize18,
            fontWeight: FontWeight.w500,
            letterSpacing: UiConstants.letterSpacing8,
            fontFamily: 'Arial', // Fallback font for Safari
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: UiConstants.fontSize16,
        fontFamily: 'Arial', // Fallback font for Safari
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius8)),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius8)),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(UiConstants.borderRadius8)),
          borderSide: BorderSide(color: UiConstants.primaryBlack, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: UiConstants.primaryWhite,
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
              foregroundColor: UiConstants.primaryWhite,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiConstants.borderRadius8),
              ),
              padding: UiConstants.buttonPadding,
              minimumSize: const Size(double.infinity, 48), // Ensure minimum height
              textStyle: const TextStyle(
                fontSize: UiConstants.fontSize16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Arial', // Fallback font for Safari
              ),
            ),
            onPressed: _handleLogin,
            child: const Text(
              LoginMessages.loginButtonText,
              style: TextStyle(
                fontSize: UiConstants.fontSize16,
                color: UiConstants.primaryWhite,
                fontFamily: 'Arial', // Fallback font for Safari
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
    // Get screen dimensions for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: UiConstants.primaryBlack,
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Logo section with fixed height for Safari
                    SizedBox(
                      height: screenHeight * 0.4, // 40% of screen height
                      child: Center(child: _buildLogo()),
                    ),
                    // Form section with flexible height
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: screenHeight * 0.6, // Minimum 60% of screen height
                        ),
                        decoration: const BoxDecoration(
                          color: UiConstants.primaryWhite,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(UiConstants.borderRadius24),
                          ),
                        ),
                        padding: UiConstants.containerPadding,
                        child: _buildLoginForm(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
