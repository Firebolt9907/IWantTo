// Firebase Authentication is made by the Firebase team at Google
import 'package:firebase_auth/firebase_auth.dart';
// All Flutter packages below are built into Flutter
// made by the Flutter team at Google
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Go Router is made by the Flutter team at Google
import 'package:go_router/go_router.dart';
// imports the file "main.dart" shown in the first file
import 'package:i_want_to/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.contex});
  final BuildContext contex;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var colorsInRow = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Using a condition in the build function for responsiveness
    if ((7 *
                MediaQuery.sizeOf(context).width /
                MediaQuery.sizeOf(context).height)
            .round() !=
        colorsInRow) {
      setState(() {
        colorsInRow = (7 *
                MediaQuery.sizeOf(context).width /
                MediaQuery.sizeOf(context).height)
            .round();
      });
    }
    // Using an embedded MaterialApp to avoid forced refreshes
    return MaterialApp(
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
                          // using context from home page due to embedded materialapp
                          widget.contex.pop();
                        },
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
                        if (FirebaseAuth.instance.currentUser?.uid != null) {
                          FirebaseAuth.instance.signOut();
                          widget.contex.pop();
                        }
                        setState(() {});
                      }),
                      // creating a grid of colors to allow theme customization
                  for (var i = 0; i <= colors.length / colorsInRow; i++)
                    Row(
                      children: [
                        for (var j = 0; j < colorsInRow; j++)
                          SizedBox(
                              height: MediaQuery.sizeOf(context).width /
                                  colorsInRow,
                              width: MediaQuery.sizeOf(context).width /
                                  colorsInRow,
                              child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.sizeOf(context).width /
                                          (colorsInRow * 8)),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(1212112),
                                    child: IconButton(
                                      icon: (i * colorsInRow) + j <
                                                  colors.length &&
                                              colors.keys.toList()[
                                                      (i * colorsInRow) + j] ==
                                                  color
                                          ? Stack(
                                              children: [
                                                Container(
                                                  color: (i * colorsInRow) + j <
                                                          colors.length
                                                      ? colors[colors.keys
                                                              .toList()[
                                                          (i * colorsInRow) +
                                                              j]]
                                                      : Colors.transparent,
                                                ),
                                                Center(
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .checkmark_alt,
                                                    color: Colors.black,
                                                    size: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        (colorsInRow * 2),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              color: (i * colorsInRow) + j <
                                                      colors.length
                                                  ? colors[colors.keys.toList()[
                                                      (i * colorsInRow) + j]]
                                                  : Colors.transparent,
                                            ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        if ((i * colorsInRow) + j <
                                            colors.length) {
                                          FirebaseAuth.instance.currentUser!
                                              .updateDisplayName(
                                                  colors.keys.toList()[
                                                      (i * colorsInRow) + j]);
                                          setState(() {
                                            color = colors.keys.toList()[
                                                (i * colorsInRow) + j];
                                          });
                                        }
                                      },
                                    ),
                                  )))
                      ],
                    )
                ]))));
  }
}
