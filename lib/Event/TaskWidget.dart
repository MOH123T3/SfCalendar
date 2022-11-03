// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, must_be_immutable, unnecessary_new, unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DataBase/EventDataBase.dart';
import 'package:myapp/Event/EventDataSource.dart';
import 'package:myapp/Event/EventViewingPage.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'EventProvider.dart';

// ignore: must_be_immutable

class TasksWidget extends StatefulWidget {
  TasksWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return FutureBuilder(
      future: dbHelper.getAllRecords(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        List<Events> collectionEvent = <Events>[];
        try {
          if (snapshot != null && snapshot.data!.isNotEmpty) {
            print("snapshot.data------  ${snapshot.data}");
            for (var i = 0; i < snapshot.data!.length; i++) {
              DateTime tempFromDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(snapshot.data![i]["start"].toString());
              DateTime tempToDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                  .parse(snapshot.data![i]["end"].toString());

              collectionEvent.add(Events(
                  title: snapshot.data![i]["name"].toString(),
                  description: snapshot.data![i]["description"].toString(),
                  from: tempFromDate,
                  to: tempToDate,
                  id: snapshot.data![i]["_id"]));

              print("object${snapshot.data![i]["_id"]}");
            }
          } else {
            return Container(
              color: Colors.black12,
              child: Center(
                child: Text(
                  'No event found !',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            );
          }
        } catch (e) {
          e.toString();
        }

        return SfCalendarTheme(
            data: SfCalendarThemeData(
                backgroundColor: Colors.black12,
                todayHighlightColor: Colors.red,
                timeTextStyle: TextStyle(fontSize: 12, color: Colors.black)),
            child: SfCalendar(
              dataSource: EventDataSource(collectionEvent),
              view: CalendarView.week,
              scheduleViewSettings: ScheduleViewSettings(
                  monthHeaderSettings: MonthHeaderSettings(
                      backgroundColor: Colors.black,
                      monthTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w400))),
              monthViewSettings: MonthViewSettings(
                  dayFormat: 'EEE',
                  numberOfWeeksInView: 4,
                  appointmentDisplayCount: 2,
                  agendaItemHeight: 50,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  navigationDirection: MonthNavigationDirection.horizontal,
                  agendaStyle: AgendaStyle(
                    backgroundColor: Colors.transparent,
                  )),
              appointmentBuilder: AppointmentBuilder,
              headerHeight: 50,
              todayHighlightColor: Colors.black,
              selectionDecoration: BoxDecoration(color: Colors.black12),
              viewHeaderStyle: ViewHeaderStyle(
                backgroundColor: Colors.white,
                dayTextStyle: TextStyle(color: Colors.black, fontSize: 15),
              ),
              initialDisplayDate: provider.selectedDate,
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

              // ignore: prefer_const_literals_to_create_immutables
              allowedViews: [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
                CalendarView.schedule
              ],

              onTap: (details) {
                if (details.appointments == null) return;

                final event = details.appointments!.first;

                showDialog(
                    context: context,
                    builder: (context) => EventViewingPage(event: event));
              },
            ));
      },
    );
  }

  Widget AppointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;

    print("Event ${event}");

    return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            event.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
