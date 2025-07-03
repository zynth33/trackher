import 'package:flutter/material.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

import 'mood_selector.dart';

class Mood extends StatelessWidget {
  const Mood({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(13.0),
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
          Row(
            children: [
              Icon(Icons.favorite_outline_outlined, color: Colors.red,),
              SizedBox(width: 10,),
              Text("Mood", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.primaryColorLight) : Colors.white
              ),)
            ],
          ),
          SizedBox(height: 15,),
          MoodSelector()
        ],
      ),
    );
  }
}