import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthHelper {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
          localizedReason: "Authorize password Access.");
    } on PlatformException catch (e) {
      return false;
    }
  }
}
