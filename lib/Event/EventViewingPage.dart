// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DataBase/EventDataBase.dart';
import 'package:myapp/Event/EventEditingPage.dart';
import 'package:myapp/Event/EventProvider.dart';
import 'package:myapp/MyCalendar.dart';
import 'package:provider/provider.dart';

import 'EventDataSource.dart';

class EventViewingPage extends StatefulWidget {
  final Events? event;

  EventViewingPage({Key? key, this.event}) : super(key: key);

  @override
  State<EventViewingPage> createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  TextEditingController descriptionController = TextEditingController();
  String titleEditEvent = 'Edit Event';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.only(left: 20, right: 20, top: 100),
          actionsPadding: EdgeInsets.only(left: 10, right: 10),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event View',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CloseButton()
            ],
          ),
          actions: [
            InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Event Title',
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                widget.event!.title,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Date Range',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        icon: Icon(Icons.date_range, color: Colors.white),
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        labelText: 'From Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        DateFormat.yMMMEd().format(widget.event!.from),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                      // Text(event!.from.toString()),
                      ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        icon: Icon(Icons.access_time, color: Colors.white),
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        labelText: 'From Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        DateFormat.jm().format(widget.event!.from),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                      // Text(event!.from.toString()),
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        icon: Icon(Icons.date_range, color: Colors.white),
                        labelText: 'To Date',
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        DateFormat.yMMMEd().format(widget.event!.to),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                      // Text(event!.from.toString()),
                      ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        icon: Icon(Icons.access_time, color: Colors.white),
                        labelText: 'To Time',
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        DateFormat.jm().format(widget.event!.to),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                      // Text(event!.from.toString()),
                      ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            TextFormField(
              enabled: false,
              readOnly: true,
              controller: TextEditingController()
                ..text = widget.event!.description.isEmpty
                    ? ""
                    : widget.event!.description,
              decoration: InputDecoration(
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                label: Text("Description"),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 32,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 50,
                width: 130,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    label: Text('Edit'),
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (context) => EventEditingPage(
                                event: widget.event!,
                                editEvent: titleEditEvent,
                              ));
                    },
                    icon: Icon(Icons.edit)),
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 50,
                width: 130,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    label: Text('Delete'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                child: Container(
                                    height: 180,
                                    padding: EdgeInsets.all(10),
                                    color: Colors.black12,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Center(
                                          child: Text(
                                            "Are you sure want to delete event",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(height: 40),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 130,
                                              height: 50,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.black,
                                                ),
                                                onPressed: () async {
                                                  final id = widget.event!.id;
                                                  final rowsDeleted =
                                                      await dbHelper.delete(id);
                                                  final provider = Provider.of<
                                                          EventProvider>(
                                                      context,
                                                      listen: false);
                                                  provider.deleteEvent(
                                                      widget.event!);

                                                  Navigator
                                                      .restorablePushNamedAndRemoveUntil(
                                                          context,
                                                          '/MyCalendar',
                                                          ModalRoute.withName(
                                                              '/EventViewingPage'));
                                                },
                                                child: Text(
                                                  'Yes',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: 130,
                                              height: 50,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.black,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'No',
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )));
                          });
                    },
                    icon: Icon(Icons.delete)),
              ),
            ]),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ],
    );
  }
}
