import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../utils/components/mixins/glowing_background_mixin.dart';
import '../../utils/components/screen_title.dart';
import '../../pages/auth_page/profile_settings_page.dart';
import '../../pages/auth_page/sign_out_page.dart';
import '../../pages/auth_page/login_page.dart';
import '../../pages/avatar_page/avatar_page.dart';
import '../../utils/components/avatar.dart';
import '../../sessions/user_session.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import '_components/settings_card.dart';
import '_components/language_selector_card.dart';

class SettingsPage extends StatelessWidget with GlowingBackgroundMixin {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: UserSession().userNotifier,
        builder: (context, user, _) {
          return withGlowingBackground(
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 20,
                  children: [
                    SizedBox(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.chevron_left,
                                    size: 40,
                                    color: HexColor.fromHex(AppConstants.primaryText),
                                  ),
                                ),
                              ),
                              Spacer(),
                              ScreenTitle(title: l10n.settings, size: 24,),
                              Spacer()
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(l10n.customizeExperience, style: TextStyle(
                            color: HexColor.fromHex(AppConstants.primaryText).withValues(alpha: 0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ), textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        spacing: 20,
                        children: [
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
                                            gradient: LinearGradient(
                                                colors: [
                                                  HexColor.fromHex(AppConstants.primaryText),
                                                  HexColor.fromHex("#2A0D42").withValues(alpha: 0.7)
                                                ]
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              l10n.login,
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
                          SettingsCard(settings: AppConstants.appearanceSettings, title: l10n.appearance,),
                          // SettingsCard(settings: AppConstants.notificationsSettings, title: "Notifications",),
                          // SettingsCard(settings: AppConstants.privacyAndSecuritySettings, title: "Privacy And Security",),
                          SettingsCard(settings: AppConstants.supportSettings, title: l10n.support,),
                          // const LanguageSelectorCard(),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                                  padding: EdgeInsets.all(7.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: HexColor.fromHex(AppConstants.secondaryBackgroundLight),
                                  ),
                                  child: Icon(
                                    Symbols.calendar_today,
                                    color: HexColor.fromHex(AppConstants.primaryText),
                                    size: 18,
                                    weight: 800,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Ovlo Period Tracker", style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.primaryText) : Colors.white
                                    ),),
                                    Text("Version 1.0.0 \u2022 Built with ♥️", style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: HexColor.fromHex("#333333").withValues(alpha: 0.4)
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
                    )
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