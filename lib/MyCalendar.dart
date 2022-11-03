// ignore: file_names
// ignore_for_file: camel_case_types, prefer_const_constructors, avoid_print, prefer_final_fields, unused_element, unnecessary_new, deprecated_member_use, unused_local_variable, unused_import, unnecessary_brace_in_string_interps, non_constant_identifier_names, file_names, duplicate_ignore, must_be_immutable, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison, prefer_is_empty, prefer_typing_uninitialized_variables
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:myapp/DataBase/EventDataBase.dart';
import 'package:myapp/Event/EventEditingPage.dart';
import 'package:myapp/Event/EventProvider.dart';
import 'package:myapp/Event/TaskWidget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'Event/EventDataSource.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({Key? key}) : super(key: key);

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  var data;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('SfCalendar (SQL database) '),
          backgroundColor: Colors.black,
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black26),
            child: FutureBuilder(
              future: dbHelper.getAllRecords(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                List<Events> collection = <Events>[];
                data = snapshot.data;

                try {
                  if (snapshot != null && snapshot.data!.length != 0) {
                    print("snapshot.data------  ${snapshot.data}");
                    for (var i = 0; i < snapshot.data!.length; i++) {
                      DateTime tempFromDate =
                          new DateFormat("yyyy-MM-dd hh:mm:ss")
                              .parse(snapshot.data![i]["start"].toString());
                      DateTime tempToDate =
                          new DateFormat("yyyy-MM-dd hh:mm:ss")
                              .parse(snapshot.data![i]["end"].toString());

                      collection.add(Events(
                          title: snapshot.data![i]["name"].toString(),
                          description:
                              snapshot.data![i]["description"].toString(),
                          from: tempFromDate,
                          to: tempToDate,
                          id: snapshot.data![i]["_id"]));
                    }
                  } else {
                    print("No events");
                  }
                } catch (e) {
                  e.toString();
                }
                return SfCalendar(
                  scheduleViewSettings: ScheduleViewSettings(
                      monthHeaderSettings: MonthHeaderSettings(
                          monthTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w400))),
                  monthViewSettings: MonthViewSettings(
                      agendaViewHeight: 45,
                      dayFormat: 'EEE',
                      numberOfWeeksInView: 4,
                      appointmentDisplayCount: 2,
                      agendaItemHeight: 50,
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment,
                      //showAgenda: true,
                      navigationDirection: MonthNavigationDirection.horizontal,
                      agendaStyle: AgendaStyle(
                        backgroundColor: Colors.transparent,
                      )),
                  view: CalendarView.month,
                  initialSelectedDate: DateTime.now(),

                  selectionDecoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    shape: BoxShape.rectangle,
                  ),
                  todayHighlightColor: Colors.black,
                  viewHeaderStyle: ViewHeaderStyle(
                    backgroundColor: Colors.white,
                    dayTextStyle: TextStyle(color: Colors.black, fontSize: 15),
                  ),

                  blackoutDatesTextStyle: TextStyle(fontSize: 30),
                  todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  cellBorderColor: Colors.white,
                  showCurrentTimeIndicator: true,
                  allowAppointmentResize: true,
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(fontSize: 25),
                  ),
                  headerHeight: 120,
                  // ignore: prefer_const_literals_to_create_immutables
                  allowedViews: [
                    CalendarView.day,
                    CalendarView.week,
                    CalendarView.month,
                    CalendarView.schedule
                  ],
                  initialDisplayDate: provider.selectedDate,

                  dataSource: EventDataSource(collection),

                  onTap: (details) {
                    try {
                      // List<String> listEvent = [];
                      // collection.forEach((element) {
                      //   listEvent.add(element.id.toString());
                      //   listEvent.add(element.title);
                      //   listEvent.add(element.description);
                      //   listEvent.add(element.from.toString());
                      //   listEvent.add(element.to.toString());
                      //   listEvent.add(element.backgroundColor.toString());
                      // });
                      // print("collection-------- ${data}");
                      // print(" list Event  ---->  ${listEvent}");

                      // for (var i = 0; i < listEvent.length; i++) {
                      //   print(listEvent[i].toString());
                      // }

                      final provider = Provider.of<EventProvider>(
                        context,
                        listen: false,
                      );

                      provider.setDate(
                        details.date!,
                      );

                      showModalBottomSheet(
                          context: context,
                          builder: (context) => TasksWidget());
                    } catch (e) {
                      e.toString();
                    }
                  },
                );
              },
            )),
        floatingActionButton: Container(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton(
              child: Icon(
                Icons.add_task_sharp,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
              onPressed: () {
                showDialog<void>(
                    useSafeArea: true,
                    context: context,
                    builder: (context) => EventEditingPage());
              }),
        ),
      ),
    );
  }
}
