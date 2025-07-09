import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/components/screen_title.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/components/dialogs/cloud_sync_dialog.dart';
import '../../utils/components/divider_with_text.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

import 'email_verification_page.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_agreeToTerms) {
      _showError("You must agree to the terms and privacy policy.");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return;
    }

    try {
      setState(() => _isLoading = true);
      final user = await AuthController().registerUserWithEmail(email, password);
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EmailVerificationPage()));
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Sign up failed.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> signUpWithGoogle() async {
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
          showCloudSyncDialog(context);
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.centerLeft,
            colors: [
              HexColor.fromHex("#F6DDF8"),
              HexColor.fromHex("#F6DDF8"),
              HexColor.fromHex("#F6DDF8").withValues(alpha: 0.3),
              HexColor.fromHex("#FFFFFF").withValues(alpha: 0.33),
              HexColor.fromHex("#FFFFFF"),
              HexColor.fromHex("#FDFCFD").withValues(alpha: 0.9),
              HexColor.fromHex("#FDFCFD").withValues(alpha: 0.9),
            ]
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 60,),
            Column(
              children: [
                ScreenTitle(title: "Ovlo Tracker"),
                Text("Your personal wellness companion", style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.6),
                    fontSize: 16
                ),),
              ],
            ),
            SizedBox(height: 40,),
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
                    const Text("Create Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                    Text(
                      "Start your wellness journey today",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: HexColor.fromHex(AppConstants.graySwatch1)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _isLoading ? null : signUpWithGoogle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: HexColor.fromHex(AppConstants.graySwatch1).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                        if (value == null || value.isEmpty) return 'Please enter your email';
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
                        if (value == null || value.length < 6) return 'Password must be at least 6 characters';
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                      decoration: _inputDecoration("Confirm your password").copyWith(
                        suffixIcon: IconButton(
                          icon: _obscureConfirmPassword
                              ? SvgPicture.asset('assets/icons/icon_eye_cross.svg')
                              : SvgPicture.asset('assets/icons/icon_eye.svg'),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(text: "I agree to the ", style: TextStyle(color: Colors.black)),
                                TextSpan(text: "Terms of Service", style: TextStyle(color: HexColor.fromHex(AppConstants.primaryText))),
                                TextSpan(text: " and ", style: TextStyle(color: Colors.black)),
                                TextSpan(text: "Privacy Policy", style: TextStyle(color: HexColor.fromHex(AppConstants.primaryText))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _isLoading ? null : _signUp,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                              Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
                              SizedBox(width: 5),
                              Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                          },
                          child: Text("Sign in", style: TextStyle(
                            fontSize: 16,
                            color: HexColor.fromHex(AppConstants.primaryText),
                            fontWeight: FontWeight.w500
                          )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}
