import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/components/screen_title.dart';
import '../../utils/components/divider_with_text.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

import 'email_verification_page.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';

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

  final _authBox = Hive.box('authBox');

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  void _loadRememberedCredentials() {
    final savedEmail = _authBox.get('email');
    final savedPassword = _authBox.get('password');
    final remember = _authBox.get('rememberMe') ?? false;

    if (remember) {
      _emailController.text = savedEmail ?? '';
      _passwordController.text = savedPassword ?? '';
      _rememberMe = true;
    }
  }

  Future<void> _handleRememberMe(String email, String password) async {
    if (_rememberMe) {
      await _authBox.put('email', email);
      await _authBox.put('password', password);
      await _authBox.put('rememberMe', true);
    } else {
      await _authBox.delete('email');
      await _authBox.delete('password');
      await _authBox.put('rememberMe', false);
    }
  }

  void _signIn() async{
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() => _isLoading = true);
      final user = await AuthController().signInWithEmail(email, password);
      await _handleRememberMe(email, password);
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EmailVerificationPage()));
        }

        return;
      } else {
        if(mounted) {
          _showSuccess("Successfully Signed-in");
          Navigator.pop(context);
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Sign in failed.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      setState(() => _isLoading = true);
      final user = await AuthController().signInWithGoogle();

      if (user == null) {
        _showError("Google sign-in was cancelled.");
        return;
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EmailVerificationPage()));
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          _showSuccess("Successfully Signed-in");
          // showCloudSyncDialog(context);
        }
      }
    } catch (e) {
      _showError("An unexpected error occurred. $e");
      if (kDebugMode) print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.25)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryText), width: 2),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Column(
                  children: [
                    ScreenTitle(title: "Ovlo Tracker"),
                    Text("Your personal wellness companion", style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.6),
                      fontSize: 16
                    ),),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.2)
                    )
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Image.asset('assets/posts/post_woman.png'),
                        SizedBox(height: 20,),
                        const Text("Welcome Back", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                        Text(
                          "Sign in to continue your wellness journey",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: HexColor.fromHex(AppConstants.graySwatch1)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: signInWithGoogle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black.withValues(alpha: 0.25)),
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
                              icon: _obscurePassword
                                  ? SvgPicture.asset('assets/icons/icon_eye_cross.svg')
                                  : SvgPicture.asset('assets/icons/icon_eye.svg'),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: HexColor.fromHex(AppConstants.primaryText),
                              side: BorderSide(
                                color: Colors.black.withValues(alpha: 0.7)
                              ),
                              onChanged: (val) => setState(() => _rememberMe = val ?? false),
                            ),
                            Text("Remember Me", style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.35),
                                fontSize: 12
                            )),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                              },
                              child: Text("Forgot Password?", style: TextStyle(
                                color: HexColor.fromHex(AppConstants.primaryText),
                                fontSize: 16
                              )),
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
                              color: HexColor.fromHex(AppConstants.primaryText)
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login_rounded, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text("Sign In", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                  )),
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
                              child: Text("Sign up", style: TextStyle(
                                fontSize: 16,
                                color: HexColor.fromHex(AppConstants.primaryText),
                                fontWeight: FontWeight.w500
                              )),
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
          Positioned(
            top: -60,
            left: -20,
            child: Image.asset('assets/gradients/grad_4.png'),
          )
        ],
      ),
    );
  }
}
