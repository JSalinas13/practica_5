import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> createUser(String user, String email, String password) async {
    try {
      final credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      credentials.user!.sendEmailVerification();
      return true;
    } catch (e) {
      print('Error al crear usuario: ${e}');
    }

    return false;
  }

  Future<bool> validateUser(String email, String password) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user!.emailVerified) {
        return true;
      }
    } catch (e) {
      print('Error al verificar usuario: ${e}');
    }

    return false;
  }
}
