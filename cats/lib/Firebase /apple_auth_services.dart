import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//Apple İle Giriş İşlemleri
class AppleAuth {
  Future<UserCredential?> signInWithApple() async {
    final AuthorizationCredentialAppleID result =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final appleIdCredential = result;
    final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
    final AuthCredential credential = oAuthProvider.credential(
      idToken: String.fromCharCodes(
          appleIdCredential.identityToken! as Iterable<int>),
      accessToken: String.fromCharCodes(
          appleIdCredential.authorizationCode! as Iterable<int>),
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
