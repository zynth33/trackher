import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../sessions/user_session.dart';
import '../../extensions/build_context.dart';

void showSignOutDialog(BuildContext context) {
  context.showAnimatedDialog(
    builder: (context) => AlertDialog(
      title: const Text('Confirm Sign Out', textAlign: TextAlign.center,),
      content: const Text('You\'ll need to sign in again to access your premium features and cloud sync.', textAlign: TextAlign.center,),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(
            color: Colors.black
          ),),
        ),
        ElevatedButton(
          onPressed: () async {
            await AuthController().signOut();
            UserSession().clearSession();
            UserSession().userNotifier.value++;
            if(context.mounted) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Sign Out', style: TextStyle(
              color: Colors.white
          ),),
        ),
      ],
    ),
  );
}
