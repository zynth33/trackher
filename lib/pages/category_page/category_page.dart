import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trackher/utils/extensions/color.dart';
import '../../utils/constants.dart';

import '_components/categories_card.dart';
import '_components/day_navigator.dart';

class CategoryPage extends StatefulWidget {
  final DateTime date;
  const CategoryPage({super.key, required this.date});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final Set<String> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            // Positioned(
            //   top: -90,
            //   left: -190,
            //   child: Image.asset('assets/gradients/grad_2.png'),
            // ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, color: Colors.black, size: 35,),
                    ),
                    DayNavigator(date: widget.date,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey.shade100
                      ),
                      child: Row(
                        spacing: 20,
                        children: [
                          Icon(Icons.search, color: Colors.grey, size: 30,),
                          Text("Search", style: TextStyle(
                            color: Colors.grey.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600
                          ),)
                        ],
                      ),
                    ),
                    Text("Categories", style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),),
                    CategoriesCard(
                      categories: AppConstants.categoryMood,
                      title: "Mood",
                      selectedIndexes: selectedIndexes,
                      onSelectionChanged: (updated) {
                        setState(() {
                          selectedIndexes
                            ..clear()
                            ..addAll(updated);
                        });
                      },
                    ),
                    CategoriesCard(
                      categories: AppConstants.categoryDigestion,
                      title: "Digestion",
                      selectedIndexes: selectedIndexes,
                      onSelectionChanged: (updated) {
                        setState(() {
                          selectedIndexes
                            ..clear()
                            ..addAll(updated);
                        });
                      },
                    ),
                    CategoriesCard(
                      categories: AppConstants.categorySymptoms,
                      title: "Symptoms",
                      selectedIndexes: selectedIndexes,
                      onSelectionChanged: (updated) {
                        setState(() {
                          selectedIndexes
                            ..clear()
                            ..addAll(updated);
                        });
                      },
                    ),
                    CategoriesCard(
                      categories: AppConstants.categoryOther,
                      title: "Other",
                      selectedIndexes: selectedIndexes,
                      onSelectionChanged: (updated) {
                        setState(() {
                          selectedIndexes
                            ..clear()
                            ..addAll(updated);
                        });
                      },
                    ),
                    SizedBox(height: selectedIndexes.isNotEmpty ? 90 : 20,)
                  ],
                ),
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   right: -100,
            //   child: Image.asset('assets/gradients/grad_3.png'),
            // ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.linear,
              switchOutCurve: Curves.linear,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: selectedIndexes.isNotEmpty
                  ? Align(
                key: const ValueKey('apply-button'),
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    if (kDebugMode) {
                      print(selectedIndexes);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width - 50,
                    decoration: BoxDecoration(
                      color: HexColor.fromHex(AppConstants.primaryText),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink(
                key: ValueKey('empty-space'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}