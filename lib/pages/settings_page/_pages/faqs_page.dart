import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trackher/utils/extensions/color.dart';

import '../../../utils/constants.dart';
import '../_components/help_button.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({super.key});

  @override
  State<FaqsPage> createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: SizedBox(
          height: 1300,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      SizedBox(height: 80,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () => Navigator.pop(context),
                                child: Icon(Icons.chevron_left, size: 27,)
                            ),
                            SizedBox(width: 15,),
                            Text("Help Center", style: TextStyle(
                                fontSize: 16
                            ))
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                          width: double.infinity,
                          child: Text("FAQs and support articles", style: TextStyle(
                              fontSize: 16,
                              color: HexColor.fromHex("#666666").withValues(alpha: 0.82)
                          ),textAlign: TextAlign.center,)
                      ),
                      SizedBox(height: 20,),
                      
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(40),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.07)
                            )
                        ),
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("#6B21A8").withValues(alpha: 0.02),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.07)
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                            child: Column(
                              children: [
                                Spacer(),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search for help...",
                                    hintStyle: TextStyle(
                                        color: Colors.black.withValues(alpha: 0.44)
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                                    isDense: true,
                                    prefixIcon: Icon(Icons.search, color: Colors.black.withValues(alpha: 0.6), size: 28,),
                                    filled: true,
                                    fillColor: HexColor.fromHex("#D9D9D9").withValues(alpha: 0.27),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.7)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.7)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(40),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                                color: Colors.black.withValues(alpha: 0.07)
                            )
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: HexColor.fromHex("#6B21A8").withValues(alpha: 0.02),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Need Help?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    HelpButton(
                                      icon: SvgPicture.asset('assets/icons/icon_bubble_chat.svg'),
                                      label: "Live Chat",
                                      bgColor: HexColor.fromHex("#DFC2FE").withValues(alpha: 0.32),
                                      textColor: HexColor.fromHex(AppConstants.primaryText),
                                      strokeColor: Colors.black.withValues(alpha: 0.07),
                                    ),
                                    HelpButton(
                                      icon: SvgPicture.asset('assets/icons/icon_email.svg'),
                                      label: "Email Us",
                                      bgColor: HexColor.fromHex("#C8FFE3").withValues(alpha: 0.32),
                                      textColor: HexColor.fromHex("#01813E"),
                                      strokeColor: HexColor.fromHex("#C8FFE3"),
                                    ),
                                    HelpButton(
                                      icon: SvgPicture.asset('assets/icons/icon_phone.svg'),
                                      label: "Call",
                                      bgColor: HexColor.fromHex("#F884A5").withValues(alpha: 0.32),
                                      textColor: HexColor.fromHex("#9E3452"),
                                      strokeColor: Colors.black.withValues(alpha: 0.07),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.black.withValues(alpha: 0.07)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor.fromHex(AppConstants.primaryText).withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Frequently Asked Questions", style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black.withValues(alpha: 0.9)
                              )),
                              const SizedBox(height: 12),
                              ...AppConstants.faqs.map((faq) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    title: Text(
                                      faq.question,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    trailing: const Icon(Icons.help_outline_rounded, color: Colors.grey),
                                    onExpansionChanged: (expanded) {},
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)), // rounded corners
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                          child: Text(faq.answer),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.black.withValues(alpha: 0.07)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Still Need Help?", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              )),
                              SizedBox(height: 15,),
                              Text("📧 Email: support@trackher.com", style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),),
                              SizedBox(height: 8,),
                              Text("📞 Phone: +1 (555) 123-HELP", style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),),
                              SizedBox(height: 8,),
                              Text("🕒 Hours: Mon-Fri 9AM-6PM EST", style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -290,
                left: -20,
                child: IgnorePointer(
                  child: Image.asset('assets/gradients/grad_14.png'),
                ),
              ),
              Positioned(
                top: 770,
                right: -50,
                child: IgnorePointer(
                  child: Image.asset('assets/gradients/grad_15.png'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


