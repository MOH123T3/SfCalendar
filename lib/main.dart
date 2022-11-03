// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myapp/Event/EventEditingPage.dart';
import 'package:myapp/Event/EventProvider.dart';
import 'package:myapp/Event/EventViewingPage.dart';
import 'package:myapp/MyCalendar.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<EventProvider>(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyCalendar(),
        routes: {
          '/MyCalendar': (context) => MyCalendar(),
          '/EventEditingPage': (context) => EventEditingPage(),
          '/EventViewingPage': (context) => EventViewingPage(),
        },
      ));
}
