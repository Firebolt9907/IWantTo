import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, GoogleAuthProvider, AppleAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_want_to/home.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final providers = [];
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordRepeat = TextEditingController();
  final TextEditingController _email = TextEditingController();
  bool login = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          /* crossAxisAlignment: CrossAxisAlignment.center, */ children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(),
                child: Text(
                  login ? 'Sign In' : 'Sign Up',
                  style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IntrinsicWidth(
              child: ElevatedButton(
                  child: Text("Switch to " + (!login ? 'Sign In' : 'Sign Up')),
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  }),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Enter Email...",
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  autofillHints: const [AutofillHints.email],
                  onChanged: (text) {},
                  controller: _email,
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: "Enter Password...",
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  autofillHints: const [AutofillHints.password],
                  onChanged: (text) {},
                  controller: _password,
                  obscureText: true,
                )),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    hintText: "Confirm Password...",
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  autofillHints: const [AutofillHints.password],
                  onChanged: (text) {},
                  controller: _passwordRepeat,
                  obscureText: true,
                )),
          ]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            // bottom: (MediaQuery.viewPaddingOf(context).bottom +
            //         MediaQuery.viewInsetsOf(context).bottom) +
            //     10,
            // left: 10,
            // right: 10
            ),
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.viewInsetsOf(context).bottom <
                    MediaQuery.viewPaddingOf(context).bottom
                ? 80 + MediaQuery.viewPaddingOf(context).bottom
                : MediaQuery.viewInsetsOf(context).bottom + 80,
            child: CupertinoButton(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom <
                            MediaQuery.viewPaddingOf(context).bottom
                        ? MediaQuery.viewPaddingOf(context).bottom
                        : MediaQuery.viewInsetsOf(context).bottom),
                child: Text(
                  login ? 'Sign In' : 'Sign Up',
                  style: TextStyle(
                      color: login
                          ? Theme.of(context).colorScheme.onSecondary
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              color: login
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (login) {
                  try {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _email.text,
                      password: _password.text,
                    )
                        .then((auth) {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => HomePage(),
                          ));
                    });
                  } on FirebaseAuthException catch (e) {
                    print(e);
                  }
                } else {
                  try {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _email.text,
                      password: _password.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            )),
      ),
    );
  }
}
