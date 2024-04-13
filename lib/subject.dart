import 'package:flutter/material.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key, required this.subject});
  final String? subject;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [Text(widget.subject.toString())],
    ));
  }
}
