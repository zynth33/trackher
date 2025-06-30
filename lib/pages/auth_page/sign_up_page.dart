import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackher/pages/period_page/period_page.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/components/app_title.dart';
import 'email_verification_page.dart';
import 'login_page.dart';
import '../../utils/components/divider_with_text.dart';
import '../../utils/components/gradient_rich_text.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  bool _agreeToTerms = false;
  bool _isLoading = false;

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError("Email and password fields cannot be empty.");
      return;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return;
    }

    if (!_agreeToTerms) {
      _showError("You must agree to the terms and privacy policy.");
      return;
    }

    try {
      setState(() => _isLoading = true);

      final user = await AuthController().registerUserWithEmail(email, password);

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmailVerificationPage()),
        );
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EmailVerificationPage()),
          );
        }
      } else {
        if(mounted) {
          _showSuccess("Successfully Signed-in");
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Google sign-in failed.");
    } catch (e) {
      _showError("An unexpected error occurred. $e");
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.pink.shade100],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTitle(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text("Create Account", style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600
                    ), textAlign: TextAlign.center,),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text("Start your wellness journey today", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: HexColor.fromHex(AppConstants.graySwatch1)
                    ), textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () async {
                      await signUpWithGoogle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: HexColor.fromHex(AppConstants.graySwatch1).withValues(alpha: 0.3))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.google, size: 16,),
                          SizedBox(width: 5,),
                          Text("Continue with Google", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          ),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  DividerWithText(text: "OR CONTINUE WITH"),
                  SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),),
                      SizedBox(height: 5,),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2, style: BorderStyle.solid)
                          ),
                          hintText: "Enter your Email",
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0)
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Password", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),),
                      SizedBox(height: 5,),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2, style: BorderStyle.solid)
                          ),
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0)
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text("Confirm Password", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ),),
                      SizedBox(height: 5,),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.deepPurple, width: 2, style: BorderStyle.solid)
                          ),
                          hintText: "Confirm your password",
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0)
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2,),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (val) {
                                setState(() {
                                  _agreeToTerms = val ?? false;
                                });
                              },
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                              ),
                              children: [
                                TextSpan(text: "I agree to the ", style: TextStyle(
                                  color: Colors.black
                                )),
                                TextSpan(text: "Terms of Service", style: TextStyle(
                                  color: Colors.deepPurple
                                )),
                                TextSpan(text: " and ", style: TextStyle(
                                    color: Colors.black
                                )),
                                TextSpan(text: "Privacy Policy", style: TextStyle(
                                    color: Colors.deepPurple
                                )),
                              ]
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: _isLoading ? null : _signUp,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [Colors.purple, Colors.pink]),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Row(
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
                  SizedBox(height: 25,),
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
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          child: Text("Sign in", style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w500
                          ),textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
