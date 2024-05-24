// Firebase Authentication is made by the Firebase team at Google
import 'package:firebase_auth/firebase_auth.dart';
// Material is made by the Material Design team at Google
import 'package:flutter/material.dart';
// Cupertino is made by the Flutter team at Google
import 'package:flutter/cupertino.dart';
// Go Router is made by the Flutter team at Google
import 'package:go_router/go_router.dart';

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

  // decides if email exists or not
  void checkEmail() {
    FirebaseAuth.instance.fetchSignInMethodsForEmail(_email.text).then(
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
  }

  // attempts to sign in
  void signIn() {
    if (login) {
      try {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        )
            .then((auth) {
          context.go('/');
        });
      } on FirebaseAuthException catch (e) {
        print(e);
      }
    } else {
      try {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        )
            .then((u) {
          context.go('/');
        });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                    // only shown if screen is narrow
                    MediaQuery.sizeOf(context).width /
                                MediaQuery.sizeOf(context).height >
                            9 / 16
                        ? ""
                        : showPassword
                            ? "Enter Password"
                            : "Enter Email",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
                backgroundColor: Theme.of(context).colorScheme.background,
                border: Border.all(color: Colors.transparent),
                previousPageTitle: "Back",
              ),
            ];
          },
          body: AutofillGroup(
            child: ListView(children: [
              // text only shown if screen is wide
              MediaQuery.sizeOf(context).width /
                          MediaQuery.sizeOf(context).height >
                      9 / 16
                  ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Text(
                          showPassword ? "Enter Password" : "Enter Email",
                          style: TextStyle(
                              fontSize: 60.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),

              // textfield for entering email
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
                    autofillHints: const [AutofillHints.username],
                    autofocus: !showPassword,
                    onChanged: (text) {
                      if (showPassword) {
                        setState(() {
                          showPassword = false;
                        });
                      }
                    },
                    onSubmitted: (u) {
                      checkEmail();
                    },
                    controller: _email,
                  )),

              // text field for entering password
              // only shown if continue is pressed
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
                        autofocus: true,
                        onChanged: (text) {},
                        onSubmitted: (u) {
                          if (login) {
                            signIn();
                          }
                        },
                        controller: _password,
                        obscureText: true,
                      ))
                  : Container(),

              // only shown if email doesnt already exist
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
                        onSubmitted: (u) {
                          if (!login) {
                            signIn();
                          }
                        },
                        controller: _passwordRepeat,
                        obscureText: true,
                      ))
                  : Container(),

              // shows error if sign in attempt fails
              Text(error, style: TextStyle(color: Colors.red)),

              // sign in / continue button
              // only shown if screen is wide
              MediaQuery.sizeOf(context).width /
                          MediaQuery.sizeOf(context).height >
                      9 / 16
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.viewInsetsOf(context).bottom <
                                  MediaQuery.viewPaddingOf(context).bottom
                              ? 80 + MediaQuery.viewPaddingOf(context).bottom
                              : MediaQuery.viewInsetsOf(context).bottom + 80,
                          child: CupertinoButton(
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.viewInsetsOf(context)
                                              .bottom <
                                          MediaQuery.viewPaddingOf(context)
                                              .bottom
                                      ? MediaQuery.viewPaddingOf(context).bottom
                                      : MediaQuery.viewInsetsOf(context)
                                          .bottom),
                              child: Text(
                                showPassword
                                    ? login
                                        ? 'Sign In'
                                        : 'Sign Up'
                                    : "Continue",
                                style: TextStyle(
                                    color: !showPassword
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSecondary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            color: !showPassword
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              if (!showPassword) {
                                checkEmail();
                              } else {
                                signIn();
                              }
                            },
                          )),
                    )
                  : Container(),
            ]),
          )),
      // only shown if screen is narrow
      bottomNavigationBar: MediaQuery.sizeOf(context).width /
                  MediaQuery.sizeOf(context).height <=
              9 / 16
          ? SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.viewInsetsOf(context).bottom >
                      MediaQuery.viewPaddingOf(context).bottom
                  ? 80 + MediaQuery.viewPaddingOf(context).bottom
                  : MediaQuery.viewInsetsOf(context).bottom + 80,
              child: CupertinoButton(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
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
                    checkEmail();
                  } else {
                    signIn();
                  }
                },
              ),
            )
          : null,
    );
  }
}
