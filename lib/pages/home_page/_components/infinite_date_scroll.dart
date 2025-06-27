import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent / 2.1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          final offset = index - centerIndex;
          final date = DateTime.now().add(Duration(days: offset));
          final isToday = _isSameDay(date, DateTime.now());
          final isSelected = _isSameDay(date, _selectedDate);
          final isPastOrToday = !date.isAfter(DateTime.now());

          final dayLetter = _getDayInitial(date);
          final dayNumber = date.day;

          return GestureDetector(
            onTap: isPastOrToday ? () {
              setState(() {
                _selectedDate = date;
              });
            } : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: 53,
                decoration: BoxDecoration(
                  gradient: isSelected ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurpleAccent,
                      Colors.pinkAccent,
                    ],
                  ) : (isToday ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.pinkAccent,
                      Colors.pinkAccent,
                    ],
                  ) : null),
                  boxShadow: isSelected || isToday ? [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3,
                      offset: Offset(1, 1),
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
                        fontSize: 14,
                        color: isSelected || isToday ? Colors.white : Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected || isToday ? Colors.white : Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayInitial(DateTime date) {
    return DateFormat.E().format(date)[0];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}