import 'package:flutter/material.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

import '../../../models/category_item.dart';

class CategoriesCard extends StatefulWidget {
  final List<CategoryItem> categories;
  final String title;
  final Set<String> selectedIndexes;
  final Function(Set<String>) onSelectionChanged;

  const CategoriesCard({
    super.key,
    required this.categories,
    required this.title,
    required this.selectedIndexes,
    required this.onSelectionChanged,
  });

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 3,
          offset: Offset(1, 1),
        ),
      ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
            color: HexColor.fromHex("#FBEEF5").withValues(alpha: 0.5),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.2)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(widget.categories.length, (index) {
                final category = widget.categories[index];
                final isSelected = widget.selectedIndexes.contains(widget.categories[index].name);

                return InkWell(
                  onTap: () {
                    final categoryName = widget.categories[index].name;
                    final updatedSet = Set<String>.from(widget.selectedIndexes);

                    if (isSelected) {
                      updatedSet.remove(categoryName);
                    } else {
                      updatedSet.add(categoryName);
                    }

                    widget.onSelectionChanged(updatedSet);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 5.0, right: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: isSelected ? HexColor.fromHex(AppConstants.tertiaryBackgroundLight) : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.13),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Center(
                                child: Text(
                                  category.emoji,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected ? Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white : Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}