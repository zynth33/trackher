import 'package:flutter/material.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/extensions/color.dart';
import '../../../../utils/components/screen_title.dart';
import '../../../../utils/components/mixins/glowing_background_mixin.dart';

class ChattingPage extends StatelessWidget with GlowingBackgroundMixin {
  const ChattingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: withGlowingBackground(
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 20,),
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
                    ScreenTitle(title: "Ovlo AI", size: 24,),
                    Spacer()
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: HexColor.fromHex("#8F8F8F"),
                                  width: 3
                                )
                              ),
                              child: Image.asset(
                                AppAssets.iconAnya,
                                // fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: 15,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.4),
                                    HexColor.fromHex("#51075E").withValues(alpha: 0.4)
                                  ]
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(20, 0, 0, 0),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text("Hi! How can I assist you today?", style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                              ),),
                            )
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: HexColor.fromHex("FDD8D8"),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(20, 0, 0, 0),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Text("What Symptoms are normal during periods?", style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14
                                ),),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: HexColor.fromHex("FDD8D8"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
