import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

import '../../sessions/user_session.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import '../../utils/helper_functions.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  Color selectedColor = Colors.blue;
  String selectedAvatar = 'assets/avatars/avatar_1.svg';
  final _box = Hive.box('avatarBox');


  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  void _loadAvatar() {
    final avatarPath = _box.get('selectedAvatar');
    final colorValue = _box.get('selectedColor');

    if (avatarPath is String) {
      selectedAvatar = avatarPath;
    } else {
      selectedAvatar = getRandom(AppConstants.avatars);
    }

    if (colorValue is int) {
      selectedColor = Color(colorValue);
    } else {
      selectedColor = getRandom(AppConstants.avatarColors);
    }
  }

  void _saveAvatar() {
    _box.put('selectedAvatar', selectedAvatar);
    _box.put('selectedColor', selectedColor.toARGB32());

    UserSession().setAvatar(selectedAvatar);
    UserSession().setColor(selectedColor);

    Navigator.pop(context);
  }

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
                  InkWell(
                    onTap: () {
                      setState(() {
                        _saveAvatar();
                      });
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.pink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Container(
              height: 190,
              width: 190,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: selectedColor,
              ),
              child: SvgPicture.asset(selectedAvatar),
            ),
            const SizedBox(height: 40),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AppConstants.avatarColors.map((color) {
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
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: AppConstants.avatars.map((avatar) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedAvatar = avatar;
                        });
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: SvgPicture.asset(avatar),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}