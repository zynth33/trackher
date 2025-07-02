import 'dart:io';

import 'package:flutter/material.dart';
import '../../pages/auth_page/profile_settings_page.dart';
import '../../pages/auth_page/sign_out_page.dart';
import '../../pages/auth_page/login_page.dart';
import '../../pages/avatar_page/avatar_page.dart';
import '../../utils/components/avatar.dart';
import '../../sessions/user_session.dart';
import '../../utils/constants.dart';

import '_components/settings_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: UserSession().userNotifier,
        builder: (context, user, _) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.pink.shade100,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 20,
                  children: [
                    SizedBox(height: Platform.isIOS ? 50 : 20),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text("Settings", style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ), textAlign: TextAlign.center,),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text("Customize your TrackHer experience", style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal
                          ), textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => UserSession().isLoggedIn
                        ? Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsPage()))
                        : Navigator.push(context, MaterialPageRoute(builder: (context) => AvatarPage())),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(20, 0, 0, 0),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UserSession().isLoggedIn ? Avatar(avatarUrl: UserSession().profileImageUrl,) : ValueListenableBuilder(
                                  valueListenable: UserSession().anonNotifier,
                                  builder: (context, _, __) => Avatar(),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(height: 13,),
                                    Text(UserSession().name ?? "User", style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                                      fontWeight: FontWeight.w500
                                    ),),
                                    UserSession().isLoggedIn ? Text("${UserSession().email}", style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500
                                    ),) : SizedBox.shrink()
                                  ],
                                ),
                                Spacer(),
                                !UserSession().isLoggedIn ? InkWell(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: const LinearGradient(colors: [Colors.deepPurpleAccent, Colors.purple]),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : SizedBox.shrink(),
                              ],
                            ),
                            // SizedBox(height: 15,),
                            // Wrap(
                            //   spacing: 8,
                            //   children: [
                            //     Container(
                            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(100),
                            //           color: Colors.pink.shade50
                            //       ),
                            //       child: Text("Premium", style: TextStyle(
                            //           color: Colors.red,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 13
                            //       ),),
                            //     ),
                            //     Container(
                            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(100),
                            //           color: Colors.deepPurple.shade50
                            //       ),
                            //       child: Text("Since 2024", style: TextStyle(
                            //           color: Colors.deepPurple,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 13
                            //       ),),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ),

                    // SettingsCard(settings: AppConstants.accountSettings, title: "Account",),
                    SettingsCard(settings: AppConstants.appearanceSettings, title: "Appearance",),
                    // SettingsCard(settings: AppConstants.notificationsSettings, title: "Notifications",),
                    // SettingsCard(settings: AppConstants.privacyAndSecuritySettings, title: "Privacy And Security",),
                    SettingsCard(settings: AppConstants.supportSettings, title: "Support",),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(20, 0, 0, 0),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(20, 0, 0, 0),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(Icons.calendar_today_outlined, color: Colors.red, size: 18,),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("TrackHer", style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
                              ),),
                              Text("Version 1.0.0 \u2022 Built with ♥️", style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.grey
                              ),)
                            ],
                          )
                        ],
                      ),
                    ),
                    UserSession().isLoggedIn ? InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SignOutPage()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(20, 0, 0, 0),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.logout_rounded, color: Colors.red, size: 18,),
                            ),
                            Text("Sign Out", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.red
                            ),),
                          ],
                        ),
                      ),
                    ) : SizedBox.shrink(),
                    SizedBox(height: 90,)
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}