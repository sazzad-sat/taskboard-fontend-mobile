import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_mobile/sign_in.dart';
import 'auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {
    retrieveLinkAndSignIn(initialLink);
  }

  FirebaseDynamicLinks.instance.onLink.listen(
    (pendingDynamicLinkData) {
      retrieveLinkAndSignIn(pendingDynamicLinkData);
    },
  );

  runApp(MyApp(authenticated: await isAuthenticated()));
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  final bool authenticated;

  MyApp({super.key, required this.authenticated}) {
    if (authenticated) {
      Fluttertoast.showToast(msg: 'Authenticated');
    } else {
      Fluttertoast.showToast(msg: 'Not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: authenticated
          ? const MyHomePage(title: 'Home')
          : const SignInPage(title: 'Sign In page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            const Text("You are signed in!"),
            ElevatedButton(
                onPressed: FirebaseAuth.instance.signOut,
                child: const Text('Sign Out'))
          ],
        ),
      ),
    );
  }
}
