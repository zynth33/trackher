import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';
import '../../pages/category_page/category_page.dart';
import '../../sessions/period_session.dart';
import '../helper_functions.dart';

class DayDetailBottomSheet extends StatelessWidget {
  final DateTime date;
  const DayDetailBottomSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final canAddSymptomsAndActivities = !normalizeDate(date).isAfter(normalizeDate(DateTime.now()));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width-55,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${DateFormat('d MMM').format(date)}${getValueForDateInMap(date, PeriodSession().cycleNumbers) == -1 ? "" : " \u2022 Cycle Day ${getValueForDateInMap(date, PeriodSession().cycleNumbers)}" }",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      // getMessageForDate(date),
                    ],
                  ),

                  Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 15,),
                    ),
                  )
                ],
              ),
            ),
            canAddSymptomsAndActivities ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text('Symptoms and activities', style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(date: date,))),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade100 : Colors.grey.withValues(alpha: 0.3)
                      ),

                      child: Row(
                        children: [
                          Text("Add weight, mood & symptoms", style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),),
                          Spacer(),
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                color: HexColor.fromHex(AppConstants.primaryText),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: Offset(1, 1),
                                  ),
                                ]
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 40,),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ) : SizedBox.shrink(),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   spacing: 10,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //       child: Text("My daily insights",style: TextStyle(
            //           fontWeight: FontWeight.w500,
            //           color: Colors.black,
            //           fontSize: 18
            //       ),),
            //     ),
            //     SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //         child: Row (
            //           spacing: 5,
            //           children: List.filled(20, Container(
            //             height: 150,
            //             width: 130,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(20),
            //                 border: Border.all(color: Colors.red, width: 2)
            //             ),
            //             child: Container(
            //               margin: EdgeInsets.all(4.0),
            //               decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(17),
            //                   color: Colors.red
            //               ),
            //             ),
            //           )),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
            // const SizedBox(height: 24),
            // ElevatedButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: const Text('Close'),
            // )
          ],
        ),
      ),
    );
  }
}

