import 'package:flutter/material.dart';
import 'page_statesetter_builder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PageStateSetterBuilder(
          controller: PageStateSetterBuilderController()),
    );
  }
}
