import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class QuickQuestions extends StatelessWidget {
  const QuickQuestions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: AppConstants.quickQuestions.map((question){
        return Container(
          width: MediaQuery.of(context).size.width / 2.2,
          padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 13.0),
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade100, width: 2),
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${question.emoji} "),
              Flexible(
                child: Text(
                  question.question,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}