import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:good_place_camp/Constants.dart';

// Repository
import 'package:good_place_camp/Repository/PostsRepository.dart';

class LoginController extends GetxController {
  LoginController() {
    reload();
  }

  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = false;
  }

  Future<UserCredential> logInWithGoogle() async {
    if (GetPlatform.isWeb) {
      // Create a new provider
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');

      // Once signed in, return the UserCredential
      return Constants.auth.signInWithPopup(googleProvider);
    } else {
      // 네이티브
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return Constants.auth.signInWithCredential(credential);
    }
  }

  Future<UserCredential> logInWithFacebook() async {
    if (GetPlatform.isWeb) {
      // Create a new provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      return Constants.auth.signInWithPopup(facebookProvider);
    } else {
      // 네이티브
      // Trigger the sign-in flow
      final AccessToken result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);

      // Once signed in, return the UserCredential
      return Constants.auth
          .signInWithCredential(facebookAuthCredential);
    }
  }

  Future<UserCredential> logInWithApple() async {
    if (GetPlatform.isWeb) {
      // Create and configure an OAuthProvider for Sign In with Apple.
      final provider = OAuthProvider("apple.com")..addScope('email');

      // Sign in the user with Firebase.
      return Constants.auth.signInWithPopup(provider);
    }
    if (GetPlatform.isIOS) {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return Constants.auth.signInWithCredential(oauthCredential);
    } else {
      // 안드로이드는 지원 안함
      return null;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
