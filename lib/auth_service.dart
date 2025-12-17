import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google Sign-In untuk Android/iOS
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // =====================================================================
  // AUTH STATE LISTENER
  // =====================================================================
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // =====================================================================
  // EMAIL + PASSWORD
  // =====================================================================
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Gagal login email & password";
    }
  }

  Future<User?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await result.user?.sendEmailVerification();
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Gagal membuat akun";
    }
  }

  // =====================================================================
  // EMAIL OTP / MAGIC LINK
  // =====================================================================
  final ActionCodeSettings _actionCodeSettings = ActionCodeSettings(
    url: 'https://auth-smart-news-cd536.firebaseapp.com',
    handleCodeInApp: true,
    androidPackageName: 'com.example.auth_smart_news',
    androidInstallApp: true,
    androidMinimumVersion: '21',
  );

  Future<void> sendEmailOtp(String email) async {
    try {
      await _auth.sendSignInLinkToEmail(
        email: email.trim(),
        actionCodeSettings: _actionCodeSettings,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Gagal mengirim OTP Email";
    }
  }

  Future<User?> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    try {
      if (_auth.isSignInWithEmailLink(emailLink)) {
        final result = await _auth.signInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );
        return result.user;
      } else {
        throw "Link tidak valid";
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Gagal login via Email OTP";
    }
  }

  // =====================================================================
  // GOOGLE SIGN-IN (WEB + ANDROID)
  // =====================================================================
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // --------------------------
        // LOGIN VIA POPUP (WEB RESMI)
        // --------------------------
        GoogleAuthProvider provider = GoogleAuthProvider();
        provider.addScope('email');
        provider.addScope('profile');

        final UserCredential userCredential =
            await _auth.signInWithPopup(provider);

        return userCredential.user;
      } else {
        // --------------------------
        // LOGIN VIA GOOGLE SIGN-IN (ANDROID)
        // --------------------------
        final GoogleSignInAccount? googleUser =
            await _googleSignIn.signIn();

        if (googleUser == null) return null; // user membatalkan login

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential result =
            await _auth.signInWithCredential(credential);

        return result.user;
      }
    } catch (e) {
      throw "Google Sign-In gagal: $e";
    }
  }

  // =====================================================================
  // LOGOUT
  // =====================================================================
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) await _googleSignIn.signOut(); // Web tidak perlu logout GoogleSignIn
  }
}
