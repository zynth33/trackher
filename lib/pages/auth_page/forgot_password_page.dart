import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import '../../utils/assets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email sent")),
        );
      }
    } on FirebaseAuthException catch (e) {
      final msg = e.message ?? "An error occurred";
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              HexColor.fromHex("#F6DDF8").withValues(alpha: 0.7),
              HexColor.fromHex("#F6DDF8").withValues(alpha: 0.7),
              HexColor.fromHex("#F6DDF8").withValues(alpha: 0.3),
              HexColor.fromHex("#FFFFFF").withValues(alpha: 0.33),
              HexColor.fromHex("#FFFFFF"),
              HexColor.fromHex("#FFFFFF"),
              HexColor.fromHex("#FFFFFF"),
              HexColor.fromHex("#FFFFFF"),
              HexColor.fromHex("#FFFFFF"),
              HexColor.fromHex("#FDFCFD").withValues(alpha: 0.9),
              HexColor.fromHex("#FDFCFD").withValues(alpha: 0.9),
            ]
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.chevron_left, size: 27,)
                    ),
                    SizedBox(width: 15,),
                    Text("Forgot Password", style: TextStyle(
                      fontSize: 16
                    ),)
                  ],
                ),
                // SizedBox(height: 20,),
                // AppTitle(),
                Spacer(),
                Image.asset(AppAssets.postForgotPassword, height: 150, width: 150,),
                SizedBox(height: 90,),
                const Text(
                  "Enter your email and we’ll send you a password reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value == null || value.isEmpty || !value.contains('@')
                    ? 'Enter a valid email'
                    : null,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    hintText: "Enter your email",
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: _isLoading ? null : _resetPassword,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: HexColor.fromHex(AppConstants.primaryText)
                    ),
                    child: Text("Send Reset Link", style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ), textAlign: TextAlign.center,)
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),textAlign: TextAlign.center,),
                      SizedBox(width: 5,),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Text("Sign in", style: TextStyle(
                          fontSize: 16,
                          color: HexColor.fromHex(AppConstants.primaryText),
                          fontWeight: FontWeight.w500
                        ),textAlign: TextAlign.center,),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
