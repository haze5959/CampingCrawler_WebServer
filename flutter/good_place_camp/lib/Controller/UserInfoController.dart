import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:good_place_camp/Constants.dart';
import 'package:good_place_camp/Utils/OQDialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserInfoController extends GetxController {
  RxList<String> linkedSNS = RxList<String>();

  RxBool isLoading = false.obs;

  @override
  void onReady() async {
    super.onReady();
    final providerList = Constants.user.value.firebaseUser?.providerData;
    linkedSNS.value =
        providerList?.map((info) => info.providerId).toList() ?? [];
  }

  void reload() async {
    isLoading.value = true;
    await Constants.user.value.reloadInfo();

    isLoading.value = false;
  }

  Future<bool> linkWithGoogle() async {
    isLoading.value = true;

    if (GetPlatform.isWeb) {
      // 웹 지원 안함
      showOneBtnAlert("web_no_available".tr(), "confirm".tr(), () {});
      isLoading.value = false;
      return false;
    }

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
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

    if (GetPlatform.isWeb) {
      // 웹 지원 안함
      showOneBtnAlert("web_no_available".tr(), "confirm".tr(), () {});
      isLoading.value = false;
      return false;
    }

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken? accessToken = result.accessToken;
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken?.token ?? "");

        // Once signed in, return the UserCredential
        isLoading.value = false;
        return _checkSuccess(facebookAuthCredential);
      } else {
        _authEceptionHandler("unknown");
        isLoading.value = false;
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> linkWithTwitter() async {
    isLoading.value = true;
    if (GetPlatform.isWeb) {
      // 웹 지원 안함
      showOneBtnAlert("web_no_available".tr(), "confirm".tr(), () {});
      isLoading.value = false;
      return false;
    }

    try {
      // Create a TwitterLogin instance
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
          isLoading.value = false;
          return _checkSuccess(twitterAuthCredential);
        case TwitterLoginStatus.cancelledByUser:
          isLoading.value = false;
          _authEceptionHandler("popup-closed-by-user");
          return false;
        default:
          isLoading.value = false;
          _authEceptionHandler("unknown");
          return false;
      }
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
        showOneBtnAlert("web_no_available".tr(), "confirm".tr(), () {});
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
        showOneBtnAlert("android_no_available".tr(), "confirm".tr(), () {});
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
      await Constants.user.value.firebaseUser?.linkWithCredential(cred);
      return true;
    } on FirebaseAuthException catch (e) {
      _authEceptionHandler(e.code);
      return false;
    }
  }

  Future<bool> unlinkProvider(String providerId) async {
    if (linkedSNS.length < 2) {
      showOneBtnAlert("login_sns_cancel_error".tr(), "confirm".tr(), () {});
      return false;
    }

    try {
      await Constants.user.value.firebaseUser?.unlink(providerId);
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
        showOneBtnAlert("login_cancel".tr(), "confirm".tr(), () {});
        return;
      case "provider-already-linked":
        showOneBtnAlert("login_already_link".tr(), "confirm".tr(), () {});
        return;
      case "invalid-credential":
        showOneBtnAlert("login_fail_link".tr(), "confirm".tr(), () {});
        return;
      case "no-such-provider":
        showOneBtnAlert("login_alreay_unlink".tr(), "confirm".tr(), () {});
        return;
      default:
        showOneBtnAlert("login_fail".tr(args: [errCode]), "confirm".tr(), () {});
    }
  }
}
