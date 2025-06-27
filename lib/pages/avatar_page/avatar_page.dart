import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trackher/utils/constants.dart';
import 'package:trackher/utils/extensions/color.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  // List of colors to display in the row
  final List<Color> avatarColors = [
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.brown,
  ];

  Color selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 00.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(100),
                    child: const Icon(Icons.arrow_back, size: 30)
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Create Your Avatar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Container(
              height: 190,
              width: 190,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: selectedColor,
              ),
              child: Transform.translate(
                offset: const Offset(3, 11),
                child: SvgPicture.asset('assets/avatars/avatar_11.svg'),
              ),
            ),
            const SizedBox(height: 40),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: avatarColors.map((color) {
                  final isSelected = color == selectedColor;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.pink, width: 2)
                            : null,
                      ),
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 18,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(height: 40, color: HexColor.fromHex(AppConstants.graySwatch1), thickness: 1,),
            SingleChildScrollView()
          ],
        ),
      ),
    );
  }
}

