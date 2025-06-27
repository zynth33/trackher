import 'package:flutter/material.dart';
import 'package:trackher/sessions/symptoms_session.dart';

import '../../../utils/enums.dart';

class FlowSelector extends StatefulWidget {
  const FlowSelector({super.key});

  @override
  State<FlowSelector> createState() => _FlowSelectorState();
}

class _FlowSelectorState extends State<FlowSelector> {
  FlowLevel? _selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: FlowLevel.values.map((level) {
          final isSelected = _selected == level;

          Color dotColor;
          switch (level) {
            case FlowLevel.light:
              dotColor = Colors.pink.withValues(alpha: 0.3);
              break;
            case FlowLevel.medium:
              dotColor = Colors.pink.withValues(alpha: 0.7);
              break;
            case FlowLevel.heavy:
              dotColor = Colors.pink;
              break;
            case FlowLevel.spotting:
              dotColor = Colors.orangeAccent;
              break;
          }

          String label = level.name[0].toUpperCase() + level.name.substring(1);

          return InkWell(
            onTap: () {
              setState(() {
                _selected = level;
              });

              SymptomsSession().setSymptoms("flow", ["$label Flow"]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 85,
              decoration: isSelected ? BoxDecoration(
                color: dotColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: dotColor.withValues(alpha: 0.4), width: 2),
              ) : null,
              child: Column(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: dotColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}