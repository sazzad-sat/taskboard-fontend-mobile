import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.title});

  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var controller = TextEditingController();

  void onSubmit() async {
    var acs = ActionCodeSettings(
      url: 'https://taskboard.page.link/verify?email=${controller.text.trim()}',
      handleCodeInApp: true,
      androidPackageName: 'com.example.frontend_mobile',
      androidMinimumVersion: '12',
    );

    try {
      await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: controller.text.trim(),
        actionCodeSettings: acs,
      );

      Fluttertoast.showToast(msg: 'Email sent to your device');
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(label: Text("Email")),
              controller: controller,
              autofillHints: const [AutofillHints.email],
            ),
            ElevatedButton(
              onPressed: onSubmit,
              child: const Text("Get Started"),
            )
          ],
        ),
      ),
    );
  }
}