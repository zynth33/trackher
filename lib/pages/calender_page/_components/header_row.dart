import 'package:flutter/material.dart';

class HeaderRow extends StatelessWidget {
  final VoidCallback incrementMonth;
  final VoidCallback decrementMonth;
  final VoidCallback toggleMonthYear;
  final bool isMonth;
  final String text;

  const HeaderRow({
    super.key, required this.incrementMonth, required this.decrementMonth, required this.text, required this.toggleMonthYear, required this.isMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: decrementMonth,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: Offset(1, 1),
                ),
              ]
            ),
            child: Icon(Icons.chevron_left, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, size: 30,),
          ),
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: Offset(1, 1),
                  ),
                ]
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: toggleMonthYear,
                    child: isMonth ? Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: Offset(1, 1),
                            ),
                          ]
                      ),
                      child: Text("Month", style: TextStyle(
                          color: Colors.black
                      ),),
                    ) : Text("Month", style: TextStyle(
                        color: Colors.black
                    )),
                  ),
                  SizedBox(width: 7,),
                  InkWell(
                    onTap: toggleMonthYear,
                    child: !isMonth ? Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: Offset(1, 1),
                            ),
                          ]
                      ),
                      child: Text("Year", style: TextStyle(
                          color: Colors.black
                      ),),
                    ) : Text("Year", style: TextStyle(
                        color: Colors.black
                    ),),
                  ),
                ],
              ),
            ),
            SizedBox(width: 9,),
            Text(text, style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
          ],
        ),
        InkWell(
          onTap: incrementMonth,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              // color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withValues(alpha: 0.2),
              //     blurRadius: 20,
              //     offset: Offset(1, 1),
              //   ),
              // ]
            ),
            child: Icon(Icons.chevron_right, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, size: 35,),
          ),
        ),
      ],
    );
  }
}