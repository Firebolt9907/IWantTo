import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_want_to/firebase_options.dart';
import 'package:i_want_to/get_started.dart';
import 'package:i_want_to/home.dart';

void main() async {
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

class _MyAppState extends State<MyApp> {
  var loggedIn = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: lightColorScheme ??
              ColorScheme.fromSwatch(
                  primarySwatch: Colors.green, brightness: Brightness.light),
          backgroundColor:
              lightColorScheme != null ? Colors.lightGreen[100] : null,
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
          }),
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ??
              ColorScheme.fromSwatch(
                  primarySwatch: Colors.green, brightness: Brightness.dark),
          backgroundColor:
              darkColorScheme != null ? Colors.lightGreen[900] : null,
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            defaultTargetPlatform: CupertinoPageTransitionsBuilder(),
          }),
        ),
        routes: {
          '/start': (context) => FirstPage(),
          '/home': (context) => HomePage()
        },
        initialRoute:
            // FirebaseAuth.instance.currentUser == null ? '/start' : '/home',
            '/start',
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
                  bottom: 240 + MediaQuery.viewPaddingOf(context).bottom),
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
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 80,
                    child: CupertinoButton(
                      borderRadius: BorderRadius.only(
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
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => HomePage(),
                            ));
                      },
                    )),
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
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 80 + MediaQuery.viewPaddingOf(context).bottom,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.zero,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.viewPaddingOf(context).bottom),
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
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => GetStarted(),
                          ));
                    },
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
