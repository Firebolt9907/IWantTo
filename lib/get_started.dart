import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, GoogleAuthProvider, AppleAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:i_want_to/home.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key, this.login});
  final login;

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final providers = [];
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.1),
            child: Text(
              widget.login ? 'Login' : 'Sign Up',
              style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
      ]),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: (MediaQuery.viewPaddingOf(context).bottom +
                    MediaQuery.viewInsetsOf(context).bottom) +
                10,
            left: 10,
            right: 10),
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 80,
            child: CupertinoButton(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Text(
                widget.login ? 'Login' : 'Sign Up',
                style: TextStyle(
                    color: widget.login
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.onPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              color: widget.login
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (widget.login) {
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
                  } catch (e) {
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
