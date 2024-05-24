// Firebase Authentication is made by the Firebase team at Google
import 'package:firebase_auth/firebase_auth.dart';
// Material is made by the Material Design team at Google
import 'package:flutter/material.dart';
// Cupertino is made by the Flutter team at Google
import 'package:flutter/cupertino.dart';
// Go Router is made by the Flutter team at Google
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> subjects = [
    {
      'name': "search",
    },
    {
      'name': 'Math',
      'clickable': true,
      'route': '/math',
      'icon': Icons.calculate,
    },
    {
      'name': 'Physics',
      'clickable': true,
      'route': '/physics',
      "icon": Icons.science,
    },
    {
      'name': 'Chemistry',
      'clickable': true,
      'route': '/chemistry',
      "icon": Icons.science_outlined,
    },
    {
      'name': 'Biology',
      'clickable': false,
      'route': '/biology',
      "icon": Icons.science_outlined,
    },
    {
      'name': 'English',
      'clickable': false,
      'route': '/english',
      "icon": Icons.language,
    },
    {
      'name': "More Coming Soon",
      'clickable': false,
      "icon": Icons.history,
    },
  ];
  var objectsPerRow = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text("Home",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground)),
                backgroundColor: Theme.of(context).colorScheme.background,
                border: Border.all(color: Colors.transparent),
                trailing: FirebaseAuth.instance.currentUser?.uid == null
                    ? IntrinsicWidth(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.background),
                                surfaceTintColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .onBackground)),
                            child: IntrinsicWidth(
                              child: Text("Sign In"),
                            ),
                            onPressed: () {
                              if (FirebaseAuth.instance.currentUser?.uid ==
                                  null) {
                                context.go("/sign-in");
                              } else {
                                FirebaseAuth.instance.signOut();
                              }
                              setState(() {});
                            }),
                      )
                    : IconButton(
                        //
                        icon: Icon(CupertinoIcons.settings_solid,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          context.go("/settings");
                        },
                      ),
              ),
            ];
          },
          body: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                if (subjects[index]["name"] != "search") {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: ElevatedButton(
                      child: Row(children: [
                        Icon(
                          subjects[index]['icon'],
                          size: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10, bottom: 10),
                          child: Text(
                              subjects[index]['name'] +
                                  "${subjects[index]['clickable'] || subjects[index]['name'] == "More Coming Soon" ? "" : " (Coming Soon)"}",
                              style: TextStyle(fontSize: 25)),
                        ),
                      ]),
                      onPressed: () {
                        if (subjects[index]['clickable']) {
                          context.go(subjects[index]['route']);
                        }
                      },
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 15, left: 10, right: 10),
                    child: Hero(
                      tag: "search",
                      child: ElevatedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                width: 2)),
                            backgroundColor: MaterialStateProperty.all(Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .background
                                    .withBlue(Theme.of(context)
                                            .buttonTheme
                                            .colorScheme!
                                            .background
                                            .blue +
                                        12)
                                    .withGreen(Theme.of(context)
                                            .buttonTheme
                                            .colorScheme!
                                            .background
                                            .green +
                                        12)
                                    .withRed(Theme.of(context)
                                            .buttonTheme
                                            .colorScheme!
                                            .background
                                            .red +
                                        12) ??
                                Colors.black)),
                        child: Row(children: [
                          Icon(
                            CupertinoIcons.search,
                            size: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10),
                            child:
                                Text("Search", style: TextStyle(fontSize: 25)),
                          ),
                        ]),
                        onPressed: () {
                          context.go("/search");
                        },
                      ),
                    ),
                  );
                }
              })),
    );
  }
}
