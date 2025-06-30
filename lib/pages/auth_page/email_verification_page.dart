import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/assets.dart';
import 'login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late Timer _checkTimer;
  Timer? _cooldownTimer;
  bool _isVerified = false;
  bool _canResendEmail = true;
  int _cooldownSeconds = 0;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (_) => _checkEmailVerified());
  }

  Future<void> _checkEmailVerified() async {
    await _auth.currentUser?.reload();
    final user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      _checkTimer.cancel();
      setState(() => _isVerified = true);

      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          if (context.mounted && mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        }
      });
    }
  }

  void _startCooldownTimer() {
    setState(() {
      _canResendEmail = false;
      _cooldownSeconds = 120;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds == 0) {
        timer.cancel();
        setState(() => _canResendEmail = true);
      } else {
        setState(() => _cooldownSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _checkTimer.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    return false;
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) => _onWillPop(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.pink.shade100],
            ),
          ),
          child: Center(
            child: _isVerified
                ? const CircularProgressIndicator()
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.postEmailVerification, height: 300, width: 300,),
                const SizedBox(height: 20),
                const Text(
                  "A verification email has been sent to your email address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Please check your inbox.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const Text(
                  "(Occasionally check your spam folder)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: _canResendEmail
                      ? () async {
                    try {
                      await _auth.currentUser?.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Verification email resent")),
                      );
                      _startCooldownTimer();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  } : null,
                  child: Opacity(
                    opacity: _canResendEmail ? 1.0 : 0.5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(colors: [Colors.purple, Colors.pink]),
                      ),
                      child: const Center(
                        child: Text(
                          "Resend Email",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!_canResendEmail) ...[
                  const SizedBox(height: 16),
                  Text(
                    "You can send another email in ${_formatTime(_cooldownSeconds)}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
