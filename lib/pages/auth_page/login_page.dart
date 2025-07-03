import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/components/app_title.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';
import '../../utils/components/divider_with_text.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // TODO: Hook into AuthController to sign in
    print('Login with: $email | $password | Remember me: $_rememberMe');
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.pink.shade100],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const AppTitle(),
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(20, 0, 0, 0),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text("Welcome Back", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                          Text(
                            "Sign in to continue your wellness journey",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: HexColor.fromHex(AppConstants.graySwatch1)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              // TODO: Call Google sign-in
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: HexColor.fromHex(AppConstants.graySwatch1).withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.google, size: 16),
                                  SizedBox(width: 5),
                                  Text("Continue with Google", style: TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const DividerWithText(text: "OR CONTINUE WITH"),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Enter your email';
                              if (!value.contains('@')) return 'Enter a valid email';
                              return null;
                            },
                            decoration: _inputDecoration("Enter your Email"),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Enter your password';
                              return null;
                            },
                            decoration: _inputDecoration("Enter your Password").copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                              ),
                              const Text("Remember Me", style: TextStyle(color: Colors.grey, fontSize: 14)),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                                },
                                child: const Text("Forgot Password?", style: TextStyle(color: Colors.deepPurple)),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _isLoading ? null : _signIn,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login_rounded, color: Colors.white),
                                    SizedBox(width: 5),
                                    Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignUpPage()));
                                },
                                child: const Text("Sign up", style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
