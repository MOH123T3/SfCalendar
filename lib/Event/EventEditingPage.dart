// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables, prefer_if_null_operators, prefer_typing_uninitialized_variables, avoid_print, must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:myapp/DataBase/EventDataBase.dart';
import 'package:myapp/Event/EventDataSource.dart';
import 'package:myapp/MyCalendar.dart';
import 'package:provider/provider.dart';
import 'EventProvider.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Constant extends GetxController {
  RxBool validationTitle = false.obs;
}

class EventEditingPage extends StatefulWidget {
  Events? event;
  final editEvent;

  EventEditingPage({Key? key, this.event, this.editEvent}) : super(key: key);
  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  final eventController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  DateTime startDate = DateTime.now();
  late final Constant con = Get.put(Constant());
  final _formKey = GlobalKey<FormState>();
  final FocusNode title = FocusNode();
  final FocusNode description = FocusNode();
  String eventTitleError = "";
  bool titleView = false;
  bool _giveVerse = false;
  bool giveVerse = false;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event!;
      eventController.text = event.title;
      descriptionController.text = event.description;
      fromDate = event.from;
      toDate = event.to;
    }

    con.validationTitle.value = false;
  }

  String titleText = '';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AlertDialog(
          actionsPadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          insetPadding: EdgeInsets.only(left: 20, right: 20, top: 100),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.editEvent != null ? widget.editEvent : 'Add Event',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CloseButton()
            ],
          ),
          actions: [
            Center(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Divider(),
                      buildTitle(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Date Range',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  icon: Icon(
                                    Icons.date_range,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'From Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Text(
                                    DateFormat.yMMMEd().format(fromDate),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                              onTap: () {
                                pickFromDateTime(pickDate: true);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  icon: Icon(
                                    Icons.access_time,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'From Time',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Text(DateFormat.jm().format(fromDate),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              onTap: () => pickFromDateTime(pickDate: false),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.date_range,
                                    color: Colors.black,
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'To Date',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Text(DateFormat.yMMMEd().format(toDate),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                              ),
                              onTap: () => pickToDateTime(pickDate: true),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  icon: Icon(
                                    Icons.access_time,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'To Time',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: Text(DateFormat.jm().format(toDate),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              onTap: () {
                                pickToDateTime(pickDate: false);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 150,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              //color: Colors.white
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Whatsapp",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.whatsapp,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Switch(
                            activeColor: Colors.black,
                            value: _giveVerse,
                            onChanged: (bool newValue) {
                              setState(() {
                                _giveVerse = newValue;
                              });
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 150,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // color: Colors.
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.email_outlined,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Switch(
                            activeColor: Colors.black,
                            value: giveVerse,
                            onChanged: (bool newValue) {
                              setState(() {
                                giveVerse = newValue;
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        expands: false,
                        maxLength: 1000,
                        controller: descriptionController,
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            label: Text("Description"),
                            hintText: "Event description"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          description.unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                          saveForm();
                        },
                        focusNode: description,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(
                width: 130,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    child: Text("Save"),
                    onPressed: saveForm),
              ),
              SizedBox(
                width: 130,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  buildTitle() => TextFormField(
        expands: false,
        maxLength: 50,
        onChanged: (value) {
          setState(() {
            eventController.value.text.toString().trim() == ''
                ? con.validationTitle.value = true
                : con.validationTitle.value = false;
          });
          //  value = text;
        },
        controller: eventController,
        decoration: InputDecoration(
          errorText: con.validationTitle.value ? 'title cannot be empty' : null,
          labelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          filled: true,
          fillColor: Colors.white,
          labelText: 'Event title',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          hintText: 'Event title',
        ),
        onFieldSubmitted: (_) {
          title.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
          TextInputAction.next;
        },
      );

  Future saveForm() async {
    if (fromDate.isAfter(toDate)) {
    } else {
      final isValid = _formKey.currentState!.validate();
      if (eventController.value.text.toString().trim() != '') {
        con.validationTitle.value = false;

        if (isValid) {
          final event = Events(
              id: 1,
              title: eventController.text,
              description: descriptionController.text,
              from: fromDate,
              to: toDate,
              isAllDay: false,
              backgroundColor: Colors.black);

          final isEditing = widget.event != null;
          var provider = Provider.of<EventProvider>(context, listen: false);
          final id = await dbHelper.queryRowCount();

          print("Event Provider length ${provider.events.length}");

          if (isEditing) {
            print(
                "----> !!!!!!!!!!!! Editing ------->> ${eventController.text}");

            Map<String, dynamic> row = {
              DatabaseHelper.columnId: widget.event!.id,
              DatabaseHelper.columnName: eventController.text,
              DatabaseHelper.columnDescription: descriptionController.text,
              DatabaseHelper.columnStart: fromDate.toString(),
              DatabaseHelper.columnEnd: toDate.toString()
            };
            final rowsAffected = await dbHelper.update(row);
            print('updated =================> $rowsAffected row(s)');
            Navigator.restorablePushNamedAndRemoveUntil(context, '/MyCalendar',
                ModalRoute.withName('/EventEditingPage'));
            provider.editEvent(event, widget.event!);
          } else {
            Map<String, dynamic> row = {
              DatabaseHelper.columnName: eventController.text,
              DatabaseHelper.columnDescription: descriptionController.text,
              DatabaseHelper.columnStart: fromDate.toString(),
              DatabaseHelper.columnEnd: toDate.toString()
            };
            var id = await dbHelper.insert(row);
            event.id = id;

            provider.addEvent(event);
            Navigator.restorablePushNamedAndRemoveUntil(context, '/MyCalendar',
                ModalRoute.withName('/EventEditingPage'));
          }
        }
      } else {
        setState(() {
          con.validationTitle.value = true;
        });
      }
    }
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final selectedDate = await pickDateTime(fromDate, pickDate: pickDate);

    if (selectedDate == null) return;

    toDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        toDate.hour, toDate.minute);

    if (startDate.isAfter(selectedDate)) {
    } else if (selectedDate.day < fromDate.day) {
      setState(() {
        fromDate = selectedDate;
      });
    } else {
      setState(() {
        fromDate = selectedDate;
      });
    }
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Colors.black),
              ),
              child: child!,
            );
          },
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime.now(),
          lastDate: DateTime(2221));
      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Colors.black),
              ),
              child: child!,
            );
          },
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate));

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);

      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );
      return date.add(time);
    }
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickDate, firstDate: pickDate ? fromDate : null);

    if (date == null) return;
    setState(() {
      if (fromDate.isBefore(date)) {
        toDate = date;
      } else {}
    });
  }
}
