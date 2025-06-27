import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/constants.dart';

class RecentChats extends StatelessWidget {
  const RecentChats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: AppConstants.recentChats.map((chat) {
        return Container(
          padding: EdgeInsets.all(13.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(9.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.deepPurple.shade100
                ),
                child: Icon(FontAwesomeIcons.comment, color: Colors.deepPurple, size: 15,),
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(chat.question, style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold
                  ),),
                  Text(chat.answer, style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  ),)
                ],
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}