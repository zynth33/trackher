import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../sessions/user_session.dart';

class Avatar extends StatelessWidget {
  final String? avatarUrl;
  const Avatar({super.key, this.avatarUrl = ""});

  @override
  Widget build(BuildContext context) {
    final session = UserSession();

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all((avatarUrl != null && avatarUrl!.isNotEmpty) ? 0 : session.selectedAvatar.isNotEmpty ? 5.0 : 10.0),
          decoration: BoxDecoration(
            color: (avatarUrl != null && avatarUrl!.isNotEmpty) ? Colors.transparent : session.selectedColor,
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
          child: (avatarUrl != null && avatarUrl!.isNotEmpty) 
            ? SizedBox(
              height: 45,
              width: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(avatarUrl!) ,
              )
            ) : session.selectedAvatar.isNotEmpty ? SvgPicture.asset(
              session.selectedAvatar,
              fit: BoxFit.contain,
              height: 40,
              width: 40,
            ) : const Icon(
              Symbols.person_2_rounded,
              color: Colors.red,
              size: 30,
            ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.pink.shade100
            ),
            child: Icon(FontAwesomeIcons.pencil, color: Colors.deepPurpleAccent, size: 10,)
          ),
        )
      ],
    );
  }
}
