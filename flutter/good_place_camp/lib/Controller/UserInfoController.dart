import 'package:get/get.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Models
import 'package:good_place_camp/Model/CampUser.dart';

// Repository
import 'package:good_place_camp/Repository/UserRepository.dart';

class UserInfoController extends GetxController {
  final UserRepository repo = UserRepository();

  RxList<String> linkedSNS = RxList<String>();

  RxBool isLoading = false.obs;

  @override
  void onReady() async {
    super.onReady();
    final providerList = Constants.user.value.firebaseUser.providerData;
    linkedSNS.value = providerList.map((info) => info.providerId).toList();
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
      return false;
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
      return false;
    }
  }

  Future<bool> linkWithTwitter() async {
    isLoading.value = true;
    try {
      // Create a TwitterLogin instance
      final TwitterLogin twitterLogin = new TwitterLogin(
        consumerKey: 'j2gXD3JP3TG30s7oSAHrO4wp9',
        consumerSecret: 'USe1iu6VZh5w5zR55xlOje4olsOuA6GYwJ6jPMqjmfKDQ3jcjD',
      );

      // Trigger the sign-in flow
      final TwitterLoginResult loginResult = await twitterLogin.authorize();

      // Get the Logged In session
      final TwitterSession twitterSession = loginResult.session;

      final twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: twitterSession.token,
        secret: twitterSession.secret,
      );

      isLoading.value = false;
      return _checkSuccess(twitterAuthCredential);
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> linkWithApple() async {
    isLoading.value = true;
    try {
      if (GetPlatform.isWeb) {
        // 웹 지원 안함
        showOneBtnAlert(Get.context, "웹에서는 지원하지 않습니다.", "확인", () {});
        isLoading.value = false;
        return false;
      } else if (GetPlatform.isIOS || GetPlatform.isMacOS) {
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

        isLoading.value = false;
        return _checkSuccess(oauthCredential);
      } else {
        // 안드로이드는 지원 안함
        showOneBtnAlert(Get.context, "아이폰 앱에서만 지원됩니다.", "확인", () {});
        isLoading.value = false;
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return false;
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

  Future<bool> unlinkProvider(String providerId) async {
    if (linkedSNS.length < 2) {
      showOneBtnAlert(
          Get.context, "로그인 연동된 SNS가 하나일 경우 해제할 수 없습니다.", "확인", () {});
      return false;
    }

    try {
      await Constants.user.value.firebaseUser.unlink(providerId);
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
      case "no-such-provider":
        showOneBtnAlert(Get.context, "이미 해제되었습니다.", "확인", () {});
        return;
      default:
        showOneBtnAlert(Get.context, "로그인에 실패하였습니다. ($errCode", "확인", () {});
    }
  }
}
