// Cloud Firestore is made by the Firebase team at Google
import 'package:cloud_firestore/cloud_firestore.dart';
// Cupertino is made by the Flutter team at Google
import 'package:flutter/cupertino.dart';
// Material is made by the Material Design team at Google
import 'package:flutter/material.dart';
// URL Launcher is made by the Flutter team at Google
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
  var shownName = "";

  @override
  void initState() {
    super.initState();
    getData(true, widget.subject.toString().toLowerCase(),
        widget.course!.replaceAll("_", " ").toLowerCase());
  }

  Map<String, String> replaceList = {
    "How would you rate the quality of information given?": "Info Quality",
    "How would you rate the quantity of information given?": "Info Quantity",
    "How would you rate the quality of tests given?": "Test Quality",
    "How would you rate the quantity of tests given?": "Test Quantity"
  };

  // pulls data from Firestore Database and adds to the array "courses"
  getData(initial, subject, course) {
    if (initial) {
      // pulling data and filtering to the specific course
      db
          .collection("websites")
          .where("Topic (lowercase)", isEqualTo: course)
          .get()
          .then((docs) {
        for (var doc in docs.docs) {
          print(doc.id);
          courses.add({"name": doc.id, "data": doc.data()});
        }

        List<Map<String, dynamic>> temp = [];
        for (var item in courses) {
          var pos = 0;
          for (var i = 0; i < temp.length; i++) {
            if (temp[i][
                    "How much does the best, yet cost-effective version cost? (NUMBER ONLY, DO NOT USE \$)"] >
                item[
                    "How much does the best, yet cost-effective version cost? (NUMBER ONLY, DO NOT USE \$)"]) {
              pos = i;
            } else {
              break;
            }
          }
          temp.insert(pos, item);
        }
        courses = temp;

        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {});
        });
        if (courses.isNotEmpty) {
          print(courses[0]["data"]["Topic?"]);
          shownName = courses[0]["data"]["Topic?"];
        } else {
          shownName = course.replaceAll(" | ", "/");
        }
      });

      // filtering with a selection sort with the lowest price at the top
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
                      shownName == ""
                          ? widget.course
                              .toString()
                              .replaceAll(" | ", "/")
                              .replaceAll("_", " ")
                          : shownName,
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
                  // shows a loading indicator if the array "subjects" is empty
                  // which only happens when getData() is loading data
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              .last.replaceAll("'", ""),
                                          style: TextStyle(fontSize: 25)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
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
                                IntrinsicHeight(
                                  child: Column(
                                    children: [
                                      // shows badges below each resource describing the quality, quantity, and cost
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
                                                        : courses[index]["data"]
                                                                [
                                                                "How much does the best, yet cost-effective version cost? (NUMBER ONLY, DO NOT USE \$)"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary)),
                                              )),
                                        ),
                                      ),
                                      // adds all attributes pulled from the db
                                      for (int i = 0;
                                          i <
                                              courses[index]['data']
                                                  ['attributes'].length; i+=2)
                                        // for (var value in courses[index]['data']
                                        //     ['attributes'])
                                          Row(
                                            children: [
                                              Padding(
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
                                                        child: Text(
                                                            (replaceList[courses[index]['data']['attributes'][i].keys
                                                                            .toList()[
                                                                        0]] ??
                                                                    courses[index]['data']['attributes'][i].keys
                                                                            .toList()[
                                                                        0]) +
                                                                ": " +
                                                                courses[index]['data']['attributes'][i][courses[index]['data']['attributes'][i].keys
                                                                            .toList()[
                                                                        0]]
                                                                    .toString() +
                                                                "/5",
                                                            // value.keys.toList()[0] +
                                                            //     ": " +
                                                            //     value[value.keys
                                                            //             .toList()[0]]
                                                            //         .toString() +
                                                            //     "/5",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimary)),
                                                      )),
                                                ),
                                              ),Padding(
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
                                                        child: Text(
                                                            (replaceList[courses[index]['data']['attributes'][i+1].keys
                                                                            .toList()[
                                                                        0]] ??
                                                                    courses[index]['data']['attributes'][i+1].keys
                                                                            .toList()[
                                                                        0]) +
                                                                ": " +
                                                                courses[index]['data']['attributes'][i+1][courses[index]['data']['attributes'][i+1].keys
                                                                            .toList()[
                                                                        0]]
                                                                    .toString() +
                                                                "/5",
                                                            // value.keys.toList()[0] +
                                                            //     ": " +
                                                            //     value[value.keys
                                                            //             .toList()[0]]
                                                            //         .toString() +
                                                            //     "/5",
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimary)),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        _launchUrl(courses[index]['data']["Website Link?"]);
                      },
                    ),
                  );
                })));
  }
}

// function written by Flutter team
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
