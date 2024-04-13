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
    },
    {
      'name': 'Chemistry',
    },
    {
      'name': 'Biology',
    },
    {
      'name': 'English',
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
      body: ListView.builder(
        itemCount: subjects.length + 2,
        itemBuilder: (context, index) {
          // return ListTile(
          //   title: Text(subjects[index]['name']),
          //   leading: Icon(icons[subjects[index]['name']]),
          // );
          if (index == subjects.length) {
            return Center(
              child: Text(
                  "uid:" + (FirebaseAuth.instance.currentUser?.uid ?? "null")),
            );
          } else if (index == subjects.length + 1) {
            return IntrinsicWidth(
              child: ElevatedButton(
                  child: IntrinsicWidth(
                    child: Text(FirebaseAuth.instance.currentUser?.uid == null
                        ? "Sign In"
                        : "Sign Out"),
                  ),
                  onPressed: () {
                    if (FirebaseAuth.instance.currentUser?.uid == null) {
                      Navigator.pushNamed(context, "/start");
                    }
                    FirebaseAuth.instance.signOut();
                    setState(() {});
                  }),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Card(
                child: ListTile(
              title:
                  Text(subjects[index]['name'], style: TextStyle(fontSize: 20)),
              leading: Icon(
                icons[subjects[index]['name']],
                size: 40,
              ),
              onTap: () {
                context.go("/s" + subjects[index]['route']);
              },
            )),
          );
        },
      ),
    );
  }
}
