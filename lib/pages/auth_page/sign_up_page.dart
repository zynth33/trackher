import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/components/app_title.dart';
import '../../utils/components/dialogs/cloud_sync_dialog.dart';
import 'email_verification_page.dart';
import 'login_page.dart';
import '../../utils/components/divider_with_text.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.pink.shade100],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
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
                                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
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
                                    children: const [
                                      TextSpan(text: "I agree to the ", style: TextStyle(color: Colors.black)),
                                      TextSpan(text: "Terms of Service", style: TextStyle(color: Colors.deepPurple)),
                                      TextSpan(text: " and ", style: TextStyle(color: Colors.black)),
                                      TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.deepPurple)),
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
                                gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
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
                                child: const Text("Sign in", style: TextStyle(fontSize: 16, color: Colors.deepPurple, fontWeight: FontWeight.w500)),
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
          ),
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
