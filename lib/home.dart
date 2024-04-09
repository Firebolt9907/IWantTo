import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> subjects = [
    {
      'name': 'Math',
    },
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
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(subjects[0]['name']),
          );
        },
      ),
    );
  }
}
