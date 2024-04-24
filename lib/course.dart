import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key, required this.course, this.subject});
  final String? subject;
  final String? course;

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<Map<String, dynamic>> courses = [];
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData(true);
  }

  getData(initial) async {
    if (initial) {
      await db
          .collection(widget.subject.toString().toLowerCase() + "_websites")
          .where("Topic (Lowercase)",
              isEqualTo: widget.course!.replaceAll("_", " ").toLowerCase())
          .get()
          .then((docs) {
        for (var doc in docs.docs) {
          courses.add({"name": doc.id, "data": doc.data()});
        }
      });
      print(courses);
      await Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: CupertinoNavigationBar(
        //   backgroundColor: Colors.transparent,
        //   border: Border.all(color: Colors.transparent),
        //   previousPageTitle: "Home",
        //   middle: Text(
        //     widget.subject.toString(),
        //     style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        //   ),
        // ),
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                      widget.course
                          .toString()
                          .replaceAll(" | ", "/")
                          .replaceAll("_", " "),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground)),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  border: Border.all(color: Colors.transparent),
                  previousPageTitle: widget.subject.toString().cap(),
                ),
              ];
            },
            body: ListView.builder(
                itemCount: courses.isEmpty ? 1 : courses.length,
                itemBuilder: (context, index) {
                  if (courses.isEmpty) {
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
                                child: Row(
                                  children: [
                                    Text(
                                        courses[index]['name']
                                            .split(" | ")
                                            .last,
                                        style: TextStyle(fontSize: 25)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Icon(
                                        CupertinoIcons.arrow_up_right_square,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, bottom: 15.0, right: 5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0,
                                                      vertical: 2),
                                              child: Text(
                                                  courses[index]["data"][
                                                              "How much does the best, yet cost-effective version cost? (NUMBER ONLY, DO NOT USE \$)"] ==
                                                          0
                                                      ? "Free"
                                                      : courses[index]["data"][
                                                              "How much does the best, yet cost-effective version cost? (NUMBER ONLY, DO NOT USE \$)"]
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary)),
                                            )),
                                      ),
                                    ),
                                    for (var value in courses[index]['data']
                                        ['attributes'])
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, bottom: 15.0, right: 5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0,
                                                        vertical: 2),
                                                child: Text(
                                                    value.keys.toList()[0] +
                                                        ": " +
                                                        value[value.keys
                                                                .toList()[0]]
                                                            .toString() +
                                                        "/10",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary)),
                                              )),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onPressed: () {
                        _launchUrl(courses[index]['data']["Website Link?"]);
                      },
                    ),
                  );
                })));
  }
}

Future<void> _launchUrl(url) async {
  Uri _url = Uri.parse(url);
  await launchUrl(_url);
}

extension stringExtension on String {
  String cap() {
    var output = "";
    for (var i = 0; i < this.split(" ").length; i++) {
      output += this.split(" ")[i].substring(0, 1).toUpperCase() +
          this.split(" ")[i].substring(1);
      if (i == this.split(" ").length - 1) {
        output += " ";
      }
    }
    return output;
  }
}
