// ignore_for_file: prefer_const_declaration, prefer_const_declarations, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Events> appointments) {
    this.appointments = appointments;
  }
  Events getEvent(int index) => appointments![index];

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).backgroundColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}

final String EventTotal = 'event';

class Events {
  int id;
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;

  Events(
      {required this.id,
      required this.title,
      required this.description,
      required this.from,
      required this.to,
      this.backgroundColor = Colors.black,
      this.isAllDay = false});
}
