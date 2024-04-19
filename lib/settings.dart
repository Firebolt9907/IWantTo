import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_want_to/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.contex, required this.updateColors});
  final BuildContext contex;
  final Function updateColors;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var oldColor = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldColor = color;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colors[color]!,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
          }),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colors[color]!,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
          }),
        ),
        home: Scaffold(
            body: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    CupertinoSliverNavigationBar(
                      largeTitle: Text("Settings",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                      backgroundColor: Theme.of(context).colorScheme.background,
                      border: Border.all(color: Colors.transparent),
                      leading: CupertinoNavigationBarBackButton(
                        previousPageTitle: "Home",
                        onPressed: () {
                          widget.contex.pop();
                          Future.delayed(const Duration(milliseconds: 400), () {
                            widget.updateColors();
                          });
                        },
                        // onPressed: widget.contex.go("/"),
                      ),
                    ),
                  ];
                },
                body: ListView(children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.background),
                          surfaceTintColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onBackground)),
                      child: IntrinsicWidth(
                        child: Text(
                          "Sign Out",
                        ),
                      ),
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser?.uid == null) {
                          // Navigator.pushNamed(context, "/start");
                        } else {
                          FirebaseAuth.instance.signOut();
                        }
                        setState(() {});
                      }),
                  oldColor != color
                      ? Text("Refresh page to see changes")
                      : Container(),
                  for (var i = 0; i <= colors.length / 3; i++)
                    Row(
                      children: [
                        for (var j = 0; j < 3; j++)
                          SizedBox(
                              height: MediaQuery.sizeOf(context).width / 3,
                              width: MediaQuery.sizeOf(context).width / 3,
                              child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.sizeOf(context).width / 24),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(1212112),
                                    child: IconButton(
                                      icon: (i * 3) + j < colors.length &&
                                              colors[colors.keys
                                                      .toList()[(i * 3) + j]] ==
                                                  color
                                          ? Stack(
                                              children: [
                                                Container(
                                                  color: (i * 3) + j <
                                                          colors.length
                                                      ? colors[
                                                          colors.keys.toList()[
                                                              (i * 3) + j]]
                                                      : Colors.transparent,
                                                ),
                                                Center(
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .checkmark_alt,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              color: (i * 3) + j < colors.length
                                                  ? colors[colors.keys
                                                      .toList()[(i * 3) + j]]
                                                  : Colors.transparent,
                                            ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        print(
                                            colors.keys.toList()[(i * 3) + j]);
                                        FirebaseAuth.instance.currentUser!
                                            .updateDisplayName(colors.keys
                                                .toList()[(i * 3) + j]);
                                        setState(() {
                                          color =
                                              colors.keys.toList()[(i * 3) + j];
                                        });
                                      },
                                    ),
                                  )))
                      ],
                    )
                ]))));
  }
}
