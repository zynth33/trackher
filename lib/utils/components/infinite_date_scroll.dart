import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';
import '../../sessions/dates_session.dart';

class InfiniteDateScroll extends StatefulWidget {
  const InfiniteDateScroll({super.key});

  @override
  State<InfiniteDateScroll> createState() => _InfiniteDateScrollState();
}

class _InfiniteDateScrollState extends State<InfiniteDateScroll> {
  static const int totalItems = 7;
  static const int centerIndex = 3;

  final ScrollController _scrollController = ScrollController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent / 2.1);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {
            
          },
          child: Container(
            padding: EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: Offset(1, 4),
                ),
              ]
            ),
            child: Icon(Icons.chevron_left, size: 30,),
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              height: 100,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalItems, (index) {
                      final offset = index - centerIndex;
                      final date = DateTime.now().add(Duration(days: offset));
                      final isToday = _isSameDay(date, DateTime.now());
                      final isSelected = _isSameDay(date, _selectedDate);
                      final isPastOrToday = !date.isAfter(DateTime.now());

                      final dayLetter = _getDayInitial(date);
                      final dayNumber = date.day;

                      return GestureDetector(
                        onTap: isPastOrToday
                            ? () {
                          setState(() {
                            _selectedDate = date;
                          });
                          DatesSession().setDate(date);
                        } : null,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1, vertical: 14),
                          width: 43,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppConstants.pillGradient
                                : (isToday
                                ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                HexColor.fromHex(AppConstants.primaryPurple),
                                HexColor.fromHex(AppConstants.primaryPurple)
                              ],
                            ) : null),
                            boxShadow: isSelected || isToday ? [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ] : null,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayLetter,
                                style: TextStyle(
                                  fontSize: isSelected || isToday ? 14 : 10,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  dayNumber.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected || isToday
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(7.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: Offset(1, 4),
                ),
              ]
          ),
          child: Icon(Icons.chevron_right, size: 30,),
        ),
      ],
    );
  }


  String _getDayInitial(DateTime date) {
    return DateFormat.E().format(date)[0];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}