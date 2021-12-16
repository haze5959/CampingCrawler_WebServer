import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:good_place_camp/Constants.dart';

class LoginController extends GetxController {
  RxBool isLoading = true.obs;

  Future<bool> logInWithGoogle() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create a new provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        if (GetPlatform.isMobile) {
          await Constants.auth.signInWithRedirect(googleProvider);
          final cred = await Constants.auth.getRedirectResult();
          isLoading.value = false;
          return _checkSuccess(cred);
        } else {
          final cred = await Constants.auth.signInWithPopup(googleProvider);
          isLoading.value = false;
          return _checkSuccess(cred);
        }
      } else {
        // 네이티브
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          _authEceptionHandler("not-found-user");
          return false;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        final cred = await Constants.auth.signInWithCredential(credential);
        isLoading.value = false;
        return _checkSuccess(cred);
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> logInWithFacebook() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create a new provider
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();

        facebookProvider.setCustomParameters({
          'display': 'popup',
        });

        // Once signed in, return the UserCredential
        final cred = await Constants.auth.signInWithPopup(facebookProvider);
        isLoading.value = false;
        return _checkSuccess(cred);
      } else {
        // 네이티브
        // Trigger the sign-in flow
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          // you are logged
          final AccessToken? accessToken = result.accessToken;
          // Create a credential from the access token
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken?.token ?? "");

          // Once signed in, return the UserCredential
          final cred =
              await Constants.auth.signInWithCredential(facebookAuthCredential);
          isLoading.value = false;
          return _checkSuccess(cred);
        } else {
          _authEceptionHandler("unknown");
          isLoading.value = false;
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> logInWithTwitter() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create a new provider
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();

        // Once signed in, return the UserCredential
        final cred =
            await FirebaseAuth.instance.signInWithPopup(twitterProvider);
        isLoading.value = false;
        return _checkSuccess(cred);
      } else {
        // 네이티브
        // Trigger the sign-in flow
        final twitterLogin = TwitterLogin(
            apiKey: 'j2gXD3JP3TG30s7oSAHrO4wp9',
            apiSecretKey: 'USe1iu6VZh5w5zR55xlOje4olsOuA6GYwJ6jPMqjmfKDQ3jcjD',
            redirectURI: "twitter-firebase-auth://");
        final authResult = await twitterLogin.login();
        switch (authResult.status) {
          case TwitterLoginStatus.loggedIn:
            final AuthCredential twitterAuthCredential =
                TwitterAuthProvider.credential(
                    accessToken: authResult.authToken ?? "",
                    secret: authResult.authTokenSecret ?? "");
            final userCredential = await FirebaseAuth.instance
                .signInWithCredential(twitterAuthCredential);
            isLoading.value = false;
            return _checkSuccess(userCredential);

          case TwitterLoginStatus.cancelledByUser:
            isLoading.value = false;
            _authEceptionHandler("popup-closed-by-user");
            return false;
          default:
            isLoading.value = false;
            _authEceptionHandler("unknown");
            return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> logInWithApple() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create and configure an OAuthProvider for Sign In with Apple.
        final provider = OAuthProvider("apple.com");
        provider.setCustomParameters({"locale": "kr"});

        // Sign in the user with Firebase.
        final cred = await Constants.auth.signInWithPopup(provider);
        isLoading.value = false;
        return _checkSuccess(cred);
      } else if (GetPlatform.isIOS) {
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
        final cred = await Constants.auth.signInWithCredential(oauthCredential);
        isLoading.value = false;
        return _checkSuccess(cred);
      } else {
        // 안드로이드는 지원 안함
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> _checkSuccess(UserCredential cred) async {
    if (cred.user != null) {
      return true;
    } else {
      showOneBtnAlert("login_fail".trParams({"msg": ""}), "confirm".tr, () {});
      return false;
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

  void _authEceptionHandler(String errCode) {
    switch (errCode) {
      case "popup-closed-by-user":
        showOneBtnAlert("login_cancel".tr, "confirm".tr, () {});
        return;
      default:
        showOneBtnAlert(
            "login_fail".trParams({"msg": errCode}), "confirm".tr, () {});
    }
  }
}
