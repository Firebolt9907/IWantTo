import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, GoogleAuthProvider, AppleAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
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
  bool showPassword = false;
  var error = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: Border.all(color: Colors.transparent),
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: "Back",
          onPressed: () => context.go("/start"),
        ),
        
      ),
      body: ListView(
          /* crossAxisAlignment: CrossAxisAlignment.center, */ children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(),
                child: Text(
                  showPassword ? "Enter Password" : "Enter Email",
                  // login ? 'Sign In' : 'Sign Up',
                  style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // IntrinsicWidth(
            //   child: ElevatedButton(
            //       child: Text("Switch to " + (!login ? 'Sign In' : 'Sign Up')),
            //       onPressed: () {
            //         setState(() {
            //           login = !login;
            //         });
            //       }),
            // ),
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
                  onChanged: (text) {
                    if (showPassword) {
                      setState(() {
                        showPassword = false;
                      });
                    }
                  },
                  controller: _email,
                )),
            showPassword
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                    ))
                : Container(),
            showPassword && !login
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                    ))
                : Container(),
            Text(error, style: TextStyle(color: Colors.red)),
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
                  showPassword
                      ? login
                          ? 'Sign In'
                          : 'Sign Up'
                      : "Continue",
                  style: TextStyle(
                      color: !showPassword
                          ? Theme.of(context).colorScheme.onSecondary
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              color: !showPassword
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (!showPassword) {
                  FirebaseAuth.instance
                      .fetchSignInMethodsForEmail(_email.text)
                      .then(
                    (value) {
                      if (value.isEmpty) {
                        setState(
                          () {
                            showPassword = true;
                          },
                        );
                      } else {
                        setState(
                          () {
                            showPassword = true;
                            login = true;
                          },
                        );
                      }
                    },
                  ).onError((error, stackTrace) {
                    print(error.toString());
                    if (error.toString().endsWith(
                        "[firebase_auth/invalid-email] The email address is badly formatted.")) {
                      setState(() {
                        error = "Invalid Email";
                      });
                    }
                  });
                } else if (login) {
                  try {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _email.text,
                      password: _password.text,
                    )
                        .then((auth) {
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //       builder: (context) => HomePage(),
                      //     ));
                      // Navigator.pushNamed(context, '/');
                      context.go('/');
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
