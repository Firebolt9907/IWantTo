// Cloud Firestore is made by the Firebase team at Google
import 'package:cloud_firestore/cloud_firestore.dart';
// Cupertino is made by the Flutter team at Google
import 'package:flutter/cupertino.dart';
// Material is made by the Material Design team at Google
import 'package:flutter/material.dart';
// Go Router is made by the Flutter team at Google
import 'package:go_router/go_router.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key, this.subject});
  final String? subject;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<String> subjects = [];
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData(true, widget.subject.toString().toLowerCase());
  }

  // pulls data from Firestore Database and adds to the array "subjects"
  getData(initial, subject) async {
    if (initial) {
      print(cap(subject).substring(0, subject.length));
      await db
          .collection("websites")
          .where("Subject",
              isEqualTo: cap(subject).substring(0, subject.length))
          .get()
          .then((docs) {
        for (var doc in docs.docs) {
          print(doc.id);
          if (!subjects.contains(doc.data()['Topic?'])) {
            subjects.add(doc.data()['Topic?'].replaceAll("'", ""));
          }
          setState(() {});
        }
      });
      await Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                      cap(widget.subject
                          .toString()
                          .replaceAll(" | ", "/")
                          .replaceAll("_", " ")),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground)),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  border: Border.all(color: Colors.transparent),
                  previousPageTitle: "Home",
                ),
              ];
            },
            body: ListView.builder(
                itemCount: subjects.isEmpty ? 1 : subjects.length,
                itemBuilder: (context, index) {
                  // shows a loading indicator if the array "subjects" is empty
                  // which only happens when getData() is loading data
                  if (subjects.isEmpty) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        ]);
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.background),
                          surfaceTintColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onBackground)),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, top: 10, bottom: 5),
                                child: Text(
                                    subjects[index]
                                        .replaceAll("AP ", "")
                                        .replaceAll("College ", "")
                                        .replaceAll("HS ", ""),
                                    style: TextStyle(fontSize: 25)),
                              ),
                              // shows the AP, High School, and College tags
                              // if the course contains them
                              IntrinsicWidth(
                                child: Row(
                                  children: [
                                    subjects[index].contains("AP")
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                bottom: 15.0,
                                                right: 5),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 2),
                                                    child: Text("AP",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary)),
                                                  )),
                                            ),
                                          )
                                        : Container(),
                                    subjects[index].contains("HS")
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                bottom: 15.0,
                                                right: 5),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 2),
                                                    child: Text("High School",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary)),
                                                  )),
                                            ),
                                          )
                                        : Container(),
                                    subjects[index].contains("AP") ||
                                            subjects[index].contains("College")
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5,
                                                bottom: 15.0,
                                                right: 5),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Container(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 2),
                                                    child: Text("College",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary)),
                                                  )),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onPressed: () {
                        context.go('/' +
                            widget.subject.toString() +
                            "/" +
                            subjects[index]
                                .toString()
                                .replaceAll(" ", "_")
                                .toLowerCase());
                      },
                    ),
                  );
                })));
  }
}

cap(String str) {
  var output = "";
  for (var i = 0; i < str.split(" ").length; i++) {
    output += str.split(" ")[i].substring(0, 1).toUpperCase() +
        str.split(" ")[i].substring(1);
    if (i == str.split(" ").length - 1) {
      output += " ";
    }
  }
  return output;
}
