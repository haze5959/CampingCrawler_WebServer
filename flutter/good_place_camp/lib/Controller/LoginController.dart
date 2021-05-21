import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:good_place_camp/Constants.dart';

// Model
import 'package:good_place_camp/Model/CampUser.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class LoginController extends GetxController {
  final UserRepository repo = UserRepository();

  LoginController() {
    reload();
  }

  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = false;
  }

  Future<bool> logInWithGoogle() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create a new provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // Once signed in, return the UserCredential
        final cred = await Constants.auth.signInWithPopup(googleProvider);
        isLoading.value = false;
        return _checkSuccess(cred);
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
        final cred = await Constants.auth.signInWithCredential(credential);
        isLoading.value = false;
        return _checkSuccess(cred);
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
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
        final AccessToken result = await FacebookAuth.instance.login();

        // Create a credential from the access token
        final FacebookAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.token);

        // Once signed in, return the UserCredential
        final cred =
            await Constants.auth.signInWithCredential(facebookAuthCredential);
        isLoading.value = false;
        return _checkSuccess(cred);
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
    }
  }

  Future<bool> logInWithTwitter() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create a new provider
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();

        // Once signed in, return the UserCredential
        final cred = await FirebaseAuth.instance.signInWithPopup(twitterProvider);
        isLoading.value = false;
        return _checkSuccess(cred);
      } else {
        // 네이티브
        // Create a TwitterLogin instance
        final TwitterLogin twitterLogin = new TwitterLogin(
          consumerKey: '<your consumer key>',
          consumerSecret: ' <your consumer secret>',
        );

        // Trigger the sign-in flow
        final TwitterLoginResult loginResult = await twitterLogin.authorize();

        // Get the Logged In session
        final TwitterSession twitterSession = loginResult.session;

        // Create a credential from the access token
        final twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: twitterSession.token,
          secret: twitterSession.secret,
        );

        // Once signed in, return the UserCredential
        final cred = await FirebaseAuth.instance
            .signInWithCredential(twitterAuthCredential);
        isLoading.value = false;
        return _checkSuccess(cred);
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
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
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
    }
  }

  Future<bool> _checkSuccess(UserCredential cred) async {
    if (cred != null && cred.user != null) {
      return await Constants.user.value.login(cred.user);
    } else {
      showOneBtnAlert(Get.context, "로그인에 실패하였습니다.", "확인", () {});
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
        showOneBtnAlert(Get.context, "사용자 취소", "확인", () {});
        return;
      default:
        showOneBtnAlert(Get.context, "로그인에 실패하였습니다. ($errCode", "확인", () {});
    }
  }
}
