// ************************************************************
//
// Copyright 2024 Robin Hunter rhunter@crml.com
// All rights reserved
//
// This work must not be copied, used or derived from either
// or via any medium without the express written permission
// and license from the owner
//
// ************************************************************
library ge_package;

import 'package:firebase_auth/firebase_auth.dart';

class ApplicationAuth {
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Unknown error';
    } catch (e) {
      return 'Unexpected error encountered';
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      var newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      newUser.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Unknown error';
    } catch (e) {
      return 'Unexpected error encountered';
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<String> updateEmailAndVerify(User user, String email) async {
    String? action = "";
    try {
      if (user.email != email) {
        await user.verifyBeforeUpdateEmail(email);
        action += "Your email has been changed\n\n";
      }
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        action += "A link has been sent to $email that will allow you to verify your email address and activate your account";
      }
    } on FirebaseAuthException catch (e) {
      action = e.message ?? "An error has occurred. Please try again";
    } catch (e) {
      action = "An error has occurred. Please try again";
    }
    return action;
  }

  Future<bool> reAuthenticate(String password) async {
    try {
      final String? email = FirebaseAuth.instance.currentUser?.email;
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(EmailAuthProvider.credential(email: email!, password: password));
      return true;
    } catch (e) {
      return false;
    }
  }
}