import 'package:assone/map_utils.dart';
import 'package:assone/model/colors.dart';
import 'package:assone/screens/home.dart';
import 'package:assone/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:assone/screens/startScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //..........when the user once logged in, he directly moves to home
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  //........
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn});
  //'''''''
  //const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Email and password login',
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFFff5003)),
        ),
        home: isLoggedIn ? home() : StartScreen());
  }
}
