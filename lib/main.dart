import 'package:flutter/material.dart';
// import 'package:voyage/travel_diaries.dart';
import 'package:voyage/homescreen.dart';
// import 'package:voyage/planner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voyage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Homescreen(),
    );
  }
}
