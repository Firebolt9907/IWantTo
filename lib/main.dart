import 'dart:js';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:i_want_to/course.dart';
import 'package:i_want_to/firebase_options.dart';
import 'package:i_want_to/get_started.dart';
import 'package:i_want_to/home.dart';
import 'package:i_want_to/settings.dart';
import 'package:i_want_to/subject.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarDividerColor: Colors.transparent,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

var color = "green";
Map<String, Color> colors = {
  "green": Colors.green,
  "blue": Colors.blue,
  "red": Colors.red,
  "yellow": Colors.yellow,
  "purple": Colors.purple,
  "orange": Colors.orange,
  "teal": Colors.teal,
  "brown": Colors.brown,
  "grey": Colors.grey,
  "indigo": Colors.indigo,
  "cyan": Colors.cyan,
  "lime": Colors.lime,
  "amber": Colors.amber,
  "pink": Colors.pink,
};

class _MyAppState extends State<MyApp> {
  var loggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    color = FirebaseAuth.instance.currentUser?.displayName ?? "green";
  }

  void updateColors() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: lightColorScheme ??
              ColorScheme.fromSeed(
                seedColor: colors[color]!,
                brightness: Brightness.light,
                // background: const Color.fromARGB(255, 238, 243, 224),
                // onBackground: Color.fromARGB(255, 6, 95, 0)
              ),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
          }),
        ),
        /* darkTheme: ThemeData(
          colorScheme: darkColorScheme ??
              ColorScheme.fromSwatch(
                primarySwatch: Colors.green,
                brightness: Brightness.dark,
                backgroundColor: darkColorScheme == null
                    ? Color.fromARGB(255, 20, 28, 20)
                    : null,
              ),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
          }),
        ), */
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ??
              ColorScheme.fromSeed(
                seedColor: colors[color]!,
                brightness: Brightness.dark,
                // backgroundColor: Color.fromARGB(255, 20, 28, 20),
              ),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
          }),
        ),
        routerConfig:  GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null ? '/start' : '/',
  routes: [
    GoRoute(
      path: '/start',
      builder: (context, state) => FirstPage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) => GetStarted(),
        ),
      ],
    ),
    GoRoute(path: '/', builder: (context, state) => HomePage(), routes: [
      GoRoute(
        path: 'sign-in',
        builder: (context, state) => GetStarted(),
      ),
      GoRoute(
        path: 'settings',
        builder: (context, state) => SettingsPage(contex: context, updateColors: updateColors,),
      ),
      GoRoute(
          path: ":subject",
          builder: (context, state) => SubjectPage(
                subject: state.pathParameters['subject'],
              ),
          routes: [
            GoRoute(
                path: ":course",
                builder: (context, state) => CoursePage(
                      course: state.pathParameters["course"],
                      subject: state.pathParameters["subject"],
                    ))
          ])
    ]),
  ],
),
        // routes: {
        //   '/start': (context) => FirstPage(),
        //   '/': (context) => HomePage(),
        // },
        // initialRoute:
        //     FirebaseAuth.instance.currentUser == null ? '/start' : '/',
        // '/start',
      );
    });
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var sampleText = [
    {'name': 'Prove Math', 'color': Colors.red},
    {'name': 'Do Chemistry', 'color': Colors.teal},
    {'name': 'Learn CS', 'color': Colors.green},
    {'name': 'Study History', 'color': Colors.pink},
    {'name': 'Create Art', 'color': Colors.yellow},
    {'name': 'Analyze Economy', 'color': Colors.purple},
    {'name': 'Compose Music', 'color': Colors.orange},
    {'name': 'Understand Climate Change', 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).brightness == Brightness.light
      //     ? Colors.white
      //     : Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  bottom: MediaQuery.sizeOf(context).width /
                              MediaQuery.sizeOf(context).height >
                          9 / 16
                      ? 0
                      : 240 + MediaQuery.viewPaddingOf(context).bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'I Want To... ',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        for (Map<String, dynamic> item in sampleText)
                          TypewriterAnimatedText(item["name"],
                              textStyle: TextStyle(
                                  color: item["color"],
                                  fontWeight: FontWeight.bold)),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: MediaQuery.sizeOf(context).width /
                        MediaQuery.sizeOf(context).height >
                    9 / 16
                ? Alignment.centerRight
                : Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              9 / 16
                          ? 10.0
                          : 0,
                      right: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              9 / 16
                          ? 10
                          : 0),
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              9 / 16
                          ? MediaQuery.sizeOf(context).width / 2 - 10
                          : MediaQuery.sizeOf(context).width,
                      height: 80,
                      child: CupertinoButton(
                        borderRadius: MediaQuery.sizeOf(context).width /
                                    MediaQuery.sizeOf(context).height >
                                9 / 16
                            ? BorderRadius.circular(20)
                            : BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                        child: Text(
                          'Skip Login',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //       builder: (context) => HomePage(),
                          //     ));
                          // Navigator.pushNamed(context, '/');
                          context.go("/");
                        },
                      )),
                ),
                // SizedBox(
                //     width: MediaQuery.sizeOf(context).width,
                //     height: 80,
                //     child: CupertinoButton(
                //       borderRadius: BorderRadius.all(Radius.zero),
                //       child: Text(
                //         'Login',
                //         style: TextStyle(
                //             color: Theme.of(context).colorScheme.onSecondary,
                //             fontSize: 30,
                //             fontWeight: FontWeight.bold),
                //       ),
                //       color: Theme.of(context).colorScheme.secondary,
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             CupertinoPageRoute(
                //               builder: (context) => GetStarted(login: true),
                //             ));
                //       },
                //     )),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              9 / 16
                          ? 10.0 + MediaQuery.viewPaddingOf(context).bottom
                          : 0,
                      right: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              9 / 16
                          ? 10
                          : 0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width /
                                MediaQuery.sizeOf(context).height >
                            9 / 16
                        ? MediaQuery.sizeOf(context).width / 2 - 10
                        : MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).width /
                                MediaQuery.sizeOf(context).height >
                            9 / 16
                        ? 80
                        : 80 + MediaQuery.viewPaddingOf(context).bottom,
                    child: CupertinoButton(
                      borderRadius: MediaQuery.sizeOf(context).width /
                                  MediaQuery.sizeOf(context).height >
                              9 / 16
                          ? BorderRadius.circular(20)
                          : BorderRadius.zero,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.sizeOf(context).width /
                                        MediaQuery.sizeOf(context).height >
                                    9 / 16
                                ? 0
                                : MediaQuery.viewPaddingOf(context).bottom),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     CupertinoPageRoute(
                        //       builder: (context) => GetStarted(),
                        //     ));
                        context.go("/start/sign-in");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
