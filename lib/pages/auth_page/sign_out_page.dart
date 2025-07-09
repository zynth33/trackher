import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

import '../../utils/components/avatar.dart';
import '../../sessions/user_session.dart';
import '../../utils/components/dialogs/sign_out_dialog.dart';

import '_components/bullet_point.dart';

class SignOutPage extends StatelessWidget {
  const SignOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: -220,
            right: -150,
            child: Image.asset("assets/gradients/grad_5.png")
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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
                    Text("Sign Out", style: TextStyle(
                      fontSize: 16
                    ),)
                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(20, 0, 0, 0),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: HexColor.fromHex("#DB4193").withValues(alpha: 0.4)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: HexColor.fromHex("#FCF3EC"),
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Icon(
                                Icons.warning_amber_rounded,
                                color: HexColor.fromHex("#EE0000").withValues(alpha: 0.69)
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Before you go…",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const Text(
                                "Make sure your data is backed up",
                                style: TextStyle(color: Colors.black87, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      BulletPoint(text: "Your tracking data will be saved locally", icon: Icon(Symbols.database_rounded, color: HexColor.fromHex("#EC4F7C").withValues(alpha: 0.83), size: 22,)),
                      const SizedBox(height: 20),
                      BulletPoint(text: "Premium features will be disabled", icon: Icon(Symbols.diamond, color: HexColor.fromHex("#EC4F7C").withValues(alpha: 0.83), size: 22,)),
                      const SizedBox(height: 20),
                      BulletPoint(text: "You can sign back in anytime", icon: Icon(Symbols.undo ,color: HexColor.fromHex("#EC4F7C").withValues(alpha: 0.83), size: 22,)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: HexColor.fromHex("#DB4193").withValues(alpha: 0.4)
                    )
                  ),
                  child: Column(
                    children: [
                      Avatar(avatarUrl: "${UserSession().profileImageUrl}", size: 70, isUpdate: false,),
                      const SizedBox(height: 12),
                      Text("${UserSession().name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("${UserSession().email}", style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                      Wrap(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: HexColor.fromHex("#DB4193")
                            ),
                            child: Text("Premium", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 11
                            ),),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            child: Text("Member since 2024", style: TextStyle(
                              color: HexColor.fromHex(AppConstants.primaryText),
                              fontWeight: FontWeight.w500,
                              fontSize: 12
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(20, 0, 0, 0),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: HexColor.fromHex("#DB4193").withValues(alpha: 0.4)
                    )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () => showSignOutDialog(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: HexColor.fromHex("#FF4077"),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout, color: Colors.white),
                              SizedBox(width: 10,),
                              const Text("Sign Out",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                              )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: HexColor.fromHex("#FF4077")
                            )
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
