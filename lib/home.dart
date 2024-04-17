import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> subjects = [
    {'name': 'Math', 'clickable': true, 'route': '/math'},
    {
      'name': 'Physics',
      'clickable': false,
      'route': '/physics',
    },
    {
      'name': 'Chemistry',
      'clickable': false,
      'route': '/chemistry',
    },
    {
      'name': 'Biology',
      'clickable': false,
      'route': '/biology',
    },
    {
      'name': 'English',
      'clickable': false,
      'route': '/english',
    },
    {
      'name': "More Coming Soon",
      'clickable': false,
    },
  ];

  Map<String, dynamic> icons = {
    'Math': Icons.calculate,
    "Physics": Icons.science,
    "Chemistry": Icons.science_outlined,
    "Biology": Icons.science_outlined,
    "English": Icons.language,
    "History": Icons.history,
  };

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
                trailing: IntrinsicWidth(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.background),
                          surfaceTintColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onBackground)),
                      child: IntrinsicWidth(
                        child: Text(
                            FirebaseAuth.instance.currentUser?.uid == null
                                ? "Sign In"
                                : "Sign Out"),
                      ),
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser?.uid == null) {
                          // Navigator.pushNamed(context, "/start");
                          context.go("/sign-in");
                        } else {
                          FirebaseAuth.instance.signOut();
                        }
                        setState(() {});
                      }),
                ),
              ),
            ];
          },
          body: ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              // return ListTile(
              //   title: Text(subjects[index]['name']),
              //   leading: Icon(icons[subjects[index]['name']]),
              // );

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.background),
                          surfaceTintColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onBackground)),
                      child: Row(children: [
                        Icon(
                          icons[subjects[index]['name']],
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
                          context.go("/" + subjects[index]['name']);
                        }
                      },
                    )),
              );
            },
          )),
    );
  }
}
