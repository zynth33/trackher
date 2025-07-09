import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import '../../sessions/dates_session.dart';

class InfiniteDateScroll extends StatefulWidget {
  final bool fromNotes;
  const InfiniteDateScroll({super.key, this.fromNotes = false});

  @override
  State<InfiniteDateScroll> createState() => _InfiniteDateScrollState();
}

class _InfiniteDateScrollState extends State<InfiniteDateScroll> {
  static const int initialIndex = 500000;
  static const double itemExtent = 51.0;
  static const int daysToScroll = 7;

  late final ScrollController _scrollController;
  late DateTime _baseDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _baseDate = DateTime.now().subtract(const Duration(days: initialIndex));
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerToday());
    _updateDateSession();
  }

  void _centerToday() {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = initialIndex * itemExtent - (screenWidth - itemExtent) / 2.1;
    _scrollController.jumpTo(targetOffset);
  }

  void _updateDateSession() {
    final isPastOrToday = !_selectedDate.isAfter(DateTime.now());
    DatesSession().setDate(_selectedDate);
    DatesSession().setSelectedDatePastToday(isPastOrToday);
  }

  DateTime _dateFromIndex(int index) => _baseDate.add(Duration(days: index));

  int _indexFromDate(DateTime date) => date.difference(_baseDate).inDays;

  void _scrollByDays(int days) {
    final offset = _scrollController.offset + (days * itemExtent);
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemExtent: itemExtent,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final date = _dateFromIndex(index);
                    final isToday = _isSameDay(date, DateTime.now());
                    final isSelected = _isSameDay(date, _selectedDate);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          _updateDateSession();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
                        decoration: BoxDecoration(
                          gradient: widget.fromNotes ? null : isSelected
                              ? AppConstants.pillGradient
                              : isToday
                              ? LinearGradient(
                            colors: [
                              HexColor.fromHex(AppConstants.primaryPurple),
                              HexColor.fromHex(AppConstants.primaryPurple),
                            ],
                          ) : null,
                          boxShadow: isSelected || isToday ? const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ] : null,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: widget.fromNotes && isSelected ? HexColor.fromHex(AppConstants.primaryText) : Colors.transparent
                          ),
                          color: widget.fromNotes && isSelected
                              ? Colors.white
                              : widget.fromNotes && isToday
                                ? Colors.white
                                : isSelected || isToday
                                  ? null
                                  : Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getDayInitial(date),
                              style: TextStyle(
                                fontSize: isSelected || isToday ? 14 : 10,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected || isToday
                                    ? Colors.black
                                    : Colors.black.withAlpha(125),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          top: 25,
          child: _buildArrowButton(Icons.chevron_left, () => _scrollByDays(-daysToScroll))
        ),
        Positioned(
          right: 0,
          top: 25,
          child: _buildArrowButton(Icons.chevron_right, () => _scrollByDays(daysToScroll))
        ),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withAlpha(50),
              blurRadius: 10,
              offset: const Offset(1, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 30),
      ),
    );
  }

  String _getDayInitial(DateTime date) {
    return DateFormat.E().format(date)[0];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
