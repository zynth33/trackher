import 'package:flutter/material.dart';

import '../../../utils/components/gradient_rich_text.dart';
import 'infinite_date_scroll.dart';

class TopCalender extends StatelessWidget {
  const TopCalender({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 15,),
          GradientRichText(
            textSpans: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(Icons.favorite_outline_outlined, size: 20),
              ),
              TextSpan(
                text: ' How do you feel today?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
            gradient: LinearGradient(colors: [
              Colors.deepPurple,
              Colors.pinkAccent,
            ]),
          ),
          // SizedBox(height: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Divider(color: Colors.pinkAccent.withValues(alpha: 0.5), thickness: 2, height: 20,),
          ),
          InfiniteDateScroll(),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}