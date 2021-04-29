import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// Model
import 'package:good_place_camp/Model/CampUser.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class LoginController extends GetxController {
  UserRepository repo = UserRepository();

  LoginController() {
    reload();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;

  void reload() async {
    isLoading.value = false;
  }

  Future<CampUser> logInWithGoogle() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create a new provider
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // Once signed in, return the UserCredential
        final cred = await auth.signInWithPopup(googleProvider);
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
        final cred = await auth.signInWithCredential(credential);
        isLoading.value = false;
        return _checkSuccess(cred);
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
    }
  }

  Future<CampUser> logInWithFacebook() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create a new provider
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();

        facebookProvider.setCustomParameters({
          'display': 'popup',
        });

        // Once signed in, return the UserCredential
        final cred = await auth.signInWithPopup(facebookProvider);
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
        final cred = await auth.signInWithCredential(facebookAuthCredential);
        isLoading.value = false;
        return _checkSuccess(cred);
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
    }
  }

  Future<CampUser> logInWithApple() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // Create and configure an OAuthProvider for Sign In with Apple.
        final provider = OAuthProvider("apple.com");
        provider.setCustomParameters({"locale": "kr"});

        // Sign in the user with Firebase.
        final cred = await auth.signInWithPopup(provider);
        isLoading.value = false;
        return _checkSuccess(cred);
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
        final cred = await auth.signInWithCredential(oauthCredential);
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

  Future<CampUser> _checkSuccess(UserCredential cred) async {
    if (cred != null && cred.user != null) {
      final token = await cred.user.getIdToken();
      print(token);
      // 유저정보 가져오는 로직
      final result = await repo.getUserInfo(token);
      if (result.hasError) {
        showOneBtnAlert(Get.context, result.statusText, "확인", () {});
        return null;
      } else if (!result.body.result) {
        showOneBtnAlert(Get.context, result.body.msg, "확인", () {});
        return null;
      }

      final userInfo = CampUser.fromJson(result.body.data);
      return userInfo;
    } else {
      showOneBtnAlert(Get.context, "로그인에 실패하였습니다.", "확인", () {});
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