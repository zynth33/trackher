import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    return res.user;
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // User canceled sign-in

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final res = await _auth.signInWithCredential(credential);
    final user = res.user;

    if (user != null) {
      // Populate session with user details
      UserSession().setMultipleUserDetails({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'profileImageUrl': user.photoURL ?? '',
        'isAnonymous': user.isAnonymous,
        'dateOfBirth': '', // optional, can be added later
        'providerId': user.providerData.first.providerId,
      });
    }

    return user;
  }


  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
