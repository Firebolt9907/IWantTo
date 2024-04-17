import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key, this.subject});
  final String? subject;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<String> courses = [];
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
          .get()
          .then((docs) {
        for (var doc in docs.docs) {
          print(doc.data());
          if (!courses.contains(doc.data()['Topic?'])) {
            courses.add(doc.data()['Topic?']);
          }
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
                      widget.subject
                          .toString()
                          .replaceAll(" | ", "/")
                          .replaceAll("_", " "),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground)),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  border: Border.all(color: Colors.transparent),
                  previousPageTitle: "Home",
                ),
              ];
            },
            body: ListView.builder(
                itemCount: courses.isEmpty ? 1 : courses.length,
                itemBuilder: (context, index) {
                  if (courses.isEmpty) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()]);
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
                                    courses[index]
                                        .replaceAll("AP ", "")
                                        .replaceAll("College ", ""),
                                    style: TextStyle(fontSize: 25)),
                              ),
                              IntrinsicWidth(
                                child: Row(
                                  children: [
                                    courses[index].contains("AP")
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
                                                    child: Text(
                                                        "Advanced Placement",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary)),
                                                  )),
                                            ),
                                          )
                                        : Container(),
                                    courses[index].contains("HS")
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
                                    courses[index].contains("AP") ||
                                            courses[index].contains("College")
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
                            courses[index].toString().replaceAll(" ", "_"));
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
