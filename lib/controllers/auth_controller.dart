import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/supabase/supabase_user_service.dart';
import '../sessions/user_session.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> registerUserWithEmail(String email, String password) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = res.user;

    if (user != null) {
      final uid = user.uid;
      await UserSession().registerFirebaseUid(uid);

      final supabaseUserService = SupabaseUserService();
      final existingProfile = await supabaseUserService.getUserProfile(uid);

      if (existingProfile == null) {
        await supabaseUserService.createUserProfile({
          'id': uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'profile_pic_url': user.photoURL ?? '',
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      await UserSession().setMultipleUserDetails({
        'id': uid,
        'name': user.displayName ?? _generateUserName(email: user.email),
        'email': user.email ?? '',
        'profileImageUrl': user.photoURL ?? '',
        'isAnonymous': user.isAnonymous,
        'providerId': user.providerData.first.providerId,
        'dateOfBirth': '',
      });

      await UserSession().init();
    }

    return user;
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final res = await _auth.signInWithCredential(credential);
    final user = res.user;

    if (user != null) {
      final uid = user.uid;
      await UserSession().registerFirebaseUid(uid);

      final supabaseUserService = SupabaseUserService();
      final existingProfile = await supabaseUserService.getUserProfile(uid);

      if (existingProfile == null) {
        await supabaseUserService.createUserProfile({
          'id': uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'profile_pic_url': user.photoURL ?? '',
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      await UserSession().setMultipleUserDetails({
        'id': uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'profileImageUrl': user.photoURL ?? '',
        'isAnonymous': user.isAnonymous,
        'providerId': user.providerData.first.providerId,
        'dateOfBirth': '',
      });

      await UserSession().init();
    }

    return user;
  }


  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  String _generateUserName({required String? email}) {
    final emailPrefix = email?.split('@').first ?? '';
    final cleaned = emailPrefix.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    return cleaned.isNotEmpty ? cleaned : 'User';
  }
}
