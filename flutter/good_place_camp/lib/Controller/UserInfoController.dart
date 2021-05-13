import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Models
import 'package:good_place_camp/Model/CampUser.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class UserInfoController extends GetxController {
  UserRepository repo = UserRepository();

  RxList<String> linkedSNS = RxList<String>();

  RxBool isLoading = true.obs;

  @override
  void onReady() async {
    super.onReady();

  // getUserLinkedSNS 이거 다 만들면 넣어라!!!!!!!
    // isLoading.value = true;
    // final idToken = await Constants.user.value.firebaseUser.getIdToken();
    // final result = await repo.getUserLinkedSNS(idToken);
    // if (result.hasError) {
    //   showOneBtnAlert(Get.context, result.statusText, "재시도", reload);
    // } else if (!result.body.result) {
    //   showOneBtnAlert(Get.context, result.body.msg, "재시도", reload);
    // }

    // isLoading.value = false;
    linkedSNS.add("google");

  }

  void reload() async {
    isLoading.value = true;
    await Constants.user.value.reloadInfo();

    isLoading.value = false;
  }

  Future<bool> linkWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      isLoading.value = false;
      return _checkSuccess(credential);
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
    }
  }

  Future<bool> linkWithFacebook() async {
    isLoading.value = true;
    try {
      final AccessToken result = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);

      isLoading.value = false;
      return _checkSuccess(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return null;
    }
  }

  Future<bool> linkWithApple() async {
    isLoading.value = true;
    try {
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

        return _checkSuccess(oauthCredential);
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

  Future<bool> _checkSuccess(AuthCredential cred) async {
    try {
      await Constants.user.value.firebaseUser.linkWithCredential(cred);
      return true;
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
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
      case "provider-already-linked":
        showOneBtnAlert(Get.context, "이미 연동 된 로그인입니다.", "확인", () {});
        return;
      case "invalid-credential":
        showOneBtnAlert(Get.context, "연동에 실패하였습니다.", "확인", () {});
        return;
      default:
        showOneBtnAlert(Get.context, "로그인에 실패하였습니다. ($errCode", "확인", () {});
    }
  }
}
