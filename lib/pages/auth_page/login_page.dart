import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/components/app_title.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';
import '../../utils/components/divider_with_text.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                    child: Text("Welcome Back", style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600
                    ), textAlign: TextAlign.center,),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text("Sign in to continue your wellness journey", style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: HexColor.fromHex(AppConstants.graySwatch1)
                    ), textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: 20,),
                  Container(
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
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)
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
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          hintText: "Enter your Password",
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
                              value: false,
                              onChanged: (val) {},
                            ),
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                        },
                        child: Text("Forgot Password?", style: TextStyle(
                          color: Colors.deepPurple
                        ),),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple,
                          Colors.pink
                        ]
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded, color: Colors.white,),
                        SizedBox(width: 5,),
                        Text("Sign In", style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 25,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),textAlign: TextAlign.center,),
                        SizedBox(width: 5,),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                          },
                          child: Text("Sign up", style: TextStyle(
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
