import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fluttertoast/fluttertoast.dart';

void retrieveLinkAndSignIn(PendingDynamicLinkData dynamicLinkData) async {
  try {
    print("firebase: ${dynamicLinkData.link}");
    bool isValidLink = FirebaseAuth.instance
        .isSignInWithEmailLink(dynamicLinkData.link.toString());
    if (!isValidLink) {
      Fluttertoast.showToast(msg: 'Not a valid link');
      return;
    }

    final continueUrl =
        dynamicLinkData.link.queryParameters['continueUrl'] ?? "";
    final email = Uri.parse(continueUrl).queryParameters['email'] ?? "";

    final userCredential = await FirebaseAuth.instance.signInWithEmailLink(
      email: email,
      emailLink: dynamicLinkData.link.toString(),
    );

    if (userCredential.user == null) {
      Fluttertoast.showToast(msg: 'Unable to sign in');
      return;
    }

    Fluttertoast.showToast(msg: 'Signed in successfully');
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    print(e);
  }
}

Future<bool> isAuthenticated() async {
  var completer = Completer<bool>();
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      completer.complete(false);
    } else {
      completer.complete(true);
    }
  });

  return completer.future;
}
