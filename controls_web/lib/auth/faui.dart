import 'package:controls_web/auth/FauiAuthScreen.dart';
import 'package:flutter/material.dart';

//import 'FauiAuthScreen.dart';
import 'FauiAuthState.dart';
import 'FauiLocalStorage.dart';
import 'faui_model.dart';

class Faui {
  static FauiUser get user {
    return FauiAuthState.User;
  }

  static set user(v) {
    FauiAuthState.User = v;
  }

  static void signOut() {
    FauiAuthState.User = null;
    FauiLocalStorage.DeleteUserLocally();
  }

  static void saveUserLocallyForSilentSignIn() {
    FauiLocalStorage.SaveUserLocallyForSilentSignIn();
  }

  static Future trySignInSilently({
    @required String firebaseApiKey,
  }) async {
    return await FauiLocalStorage.TrySignInSilently(firebaseApiKey);
  }

  static Widget buildAuthScreen(
      {@required VoidCallback onExit,
      @required String firebaseApiKey,
      bool startWithRegistration = false}) {
    return FauiAuthScreen(
      onExit: onExit,
      onRegisterUser: (a, b) {},
      onLogin: (a, b) {},
      firebaseApiKey: firebaseApiKey,
      startWithRegistration: startWithRegistration,
    );
  }
}
