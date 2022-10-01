import 'package:flutter/material.dart';
import 'PageStateSetterBuilder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PageStateSetterBuilder(controller: PageStateSetterBuilderController()),    
    );
  }
}