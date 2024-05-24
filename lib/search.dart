// Firebase Authentication is made by the Firebase team at Google
import 'package:algolia/algolia.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Material is made by the Material Design team at Google
import 'package:flutter/material.dart';
// Cupertino is made by the Flutter team at Google
import 'package:flutter/cupertino.dart';
// Go Router is made by the Flutter team at Google
import 'package:go_router/go_router.dart';
import 'package:i_want_to/algonia.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController search = TextEditingController();
  late Algolia algolia;
  Map<String, String> replaceList = {
    "How would you rate the quality of information given?": "Info Quality",
    "How would you rate the quantity of information given?": "Info Quantity",
    "How would you rate the quality of tests given?": "Test Quality",
    "How would you rate the quantity of tests given?": "Test Quantity"
  };
  List<Map<String, dynamic>> subjects = [
    {
      'objectID': "search",
    },
    {
      'objectID': "icon",
    },
    // {
    //   "Website Link?": "https://www.khanacademy.org/science/ap-chemistry-beta",
    //   "How much does the best, yet cost-effective version cost? (NUMBER ONLY, DO NOT USE \$)":
    //       0,
    //   "How often do you pay?": "One Time Fee",
    //   "Topic?": "AP Chemistry",
    //   "How Much Time Is Need to Complete This Course?": "50 Hours to 100 Hours",
    //   "attributes": [
    //     {"How would you rate the quality of information given?": 5},
    //     {"How would you rate the quantity of information given?": 5},
    //     {"How would you rate the quality of tests given?": 5},
    //     {"How would you rate the quantity of tests given?": 4}
    //   ],
    //   "Does This Course Offer Accreditation/Certification/College Credit?":
    //       "No",
    //   "Timestamp": 1716068800143,
    //   "Email Address": "rishushar99@gmail.com",
    //   "Topic (lowercase)": "ap chemistry",
    //   "path": "websites/'AP®︎ Chemistry | College Chemistry | Khan Academy'",
    //   "lastmodified": {"_operation": "IncrementSet", "value": 1716413003706},
    //   "objectID": 'AP®︎ Chemistry | College Chemistry | Khan Academy',
    // }
  ];
  var objectsPerRow = 2;

  @override
  void initState() {
    // TODO: implement initState
    algolia = Application.algolia;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              if (subjects[index]["objectID"] != "search" &&
                  subjects[index]["objectID"] != "icon") {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: ElevatedButton(
                    child: Column(
                      children: [
                        // Icon(
                        //   subjects[index]['icon'],
                        //   size: 40,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      Text(
                                          subjects[index]['objectID']
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

                        Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 0, bottom: 10),
                            child: Text(subjects[index]['Topic?'],
                                // "${subjects[index]['clickable'] || subjects[index]['name'] == "More Coming Soon" ? "" : " (Coming Soon)"}",
                                style: TextStyle(fontSize: 20))),
                        IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // shows badges below each resource describing the quality, quantity, and cost
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, bottom: 15.0, right: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Container(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                            subjects[index][
                                                        "How much does the best, yet cost-effective version cost? (NUMBER ONLY, DO NOT USE \$)"] ==
                                                    0
                                                ? "Free"
                                                : subjects[index][
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
                                  i < subjects[index]['attributes'].length;
                                  i += 2)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                                  (replaceList[subjects[index]['attributes'][i].keys.toList()[0]] ??
                                                          subjects[index]['attributes'][i]
                                                              .keys
                                                              .toList()[0]) +
                                                      ": " +
                                                      subjects[index]['attributes']
                                                              [i][subjects[index]
                                                                      ['attributes']
                                                                  [i]
                                                              .keys
                                                              .toList()[0]]
                                                          .toString() +
                                                      "/5",
                                                  // value.keys.toList()[0] +
                                                  //     ": " +
                                                  //     value[value.keys
                                                  //             .toList()[0]]
                                                  //         .toString() +
                                                  //     "/5",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary)),
                                            )),
                                      ),
                                    ),
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
                                                  (replaceList[subjects[index]['attributes'][i + 1].keys.toList()[0]] ??
                                                          subjects[index]['attributes'][i + 1]
                                                              .keys
                                                              .toList()[0]) +
                                                      ": " +
                                                      subjects[index]['attributes']
                                                                  [i + 1][
                                                              subjects[index]['attributes'][i + 1]
                                                                  .keys
                                                                  .toList()[0]]
                                                          .toString() +
                                                      "/5",
                                                  // value.keys.toList()[0] +
                                                  //     ": " +
                                                  //     value[value.keys
                                                  //             .toList()[0]]
                                                  //         .toString() +
                                                  //     "/5",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
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
                    onPressed: () {
                        _launchUrl(subjects[index]['Website Link?']);
                    },
                  ),
                );
              } else if (subjects[index]["objectID"] == "icon") {
                return Column(
                  children: [
                    SizedBox(
                        height: 400,
                        width: 400,
                        child: Image(image: AssetImage('assets/search.png'))),
                    Text("Search for anything",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 20)),
                    Text(
                      "ANYTHING",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                );
              } else {
                return Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 15, left: 10, right: 10),
                    child: Hero(
                      tag: 'search',
                      child: ElevatedButton(
                        style: ButtonStyle(
                            side: MaterialStateProperty.all(BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                width: 2)),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor: MaterialStateProperty.all(Theme.of(
                                        context)
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
                                    .withRed(
                                        Theme.of(context).buttonTheme.colorScheme!.background.red + 12) ??
                                Colors.black)),
                        child: Row(children: [
                          IconButton(
                            onPressed: () => context.go("/"),
                            icon: Icon(
                              CupertinoIcons.back,
                              size: 35,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width - 35 - 36,
                              // height: 40,
                              child: TextField(
                                controller: search,
                                autofocus: true,
                                style: TextStyle(
                                    fontSize: 25,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                    fontSize: 25,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // delay used to prevent api spam
                                  Future.delayed(Duration(milliseconds: 200),
                                      () async {
                                    if (value == search.text) {
                                      AlgoliaQuerySnapshot snap = await algolia
                                          .instance
                                          .index("websites")
                                          .query(value)
                                          .getObjects()
                                          .then((snap) {
                                        print(snap.hits
                                            .toList()[0]
                                            .data["Topic?"]);
                                        subjects = [
                                          {
                                            'objectID': "search",
                                          },
                                        ];
                                        for (var item in snap.hits.toList()) {
                                          subjects.add(item.data);
                                        }
                                        if (subjects.length == 1) {
                                          subjects.add({'objectID': 'icon'});
                                        }
                                        setState(() {});
                                        return snap;
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 10.0, top: 10, bottom: 10),
                          //   child:
                          //       Text("Search", style: TextStyle(fontSize: 25)),
                          // ),
                        ]),
                        onPressed: () {},
                      ),
                    ));
              }
            })
        // ),
        );
  }
}

// function written by Flutter team
Future<void> _launchUrl(url) async {
  Uri _url = Uri.parse(url);
  await launchUrl(_url);
}
