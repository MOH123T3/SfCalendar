// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:myapp/Event/EventDataSource.dart';

class EventProvider extends ChangeNotifier {
  final List<Events> _events = [];

  List<Events> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Events> get eventOfSelectedDate => _events;

  void addEvent(Events event) {
    _events.add(event);

    notifyListeners();
  }

  void deleteEvent(Events event) {
    _events.remove(event);

    notifyListeners();
  }

  void editEvent(Events newEvent, Events oldEvent) {
    final index = _events.indexOf(oldEvent);

    _events[index] = newEvent;

    notifyListeners();
  }
}
