import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../sessions/user_session.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    final session = UserSession();

    return Container(
      padding: EdgeInsets.all(session.selectedAvatar.isNotEmpty ? 5.0 : 10.0),
      decoration: BoxDecoration(
        color: session.selectedColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: session.selectedAvatar.isNotEmpty ? SvgPicture.asset(
        session.selectedAvatar,
        fit: BoxFit.contain,
        height: 40,
        width: 40,
      ) : const Icon(
        Symbols.person_2_rounded,
        color: Colors.red,
        size: 30,
      ),
    );
  }
}
