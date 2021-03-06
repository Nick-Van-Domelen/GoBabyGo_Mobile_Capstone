import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'constants.dart';


/*constructor, the only thing that must be passed in is the userID. THis way, we can ensure we push the correct
user id to the database when they click a manual save entry.
 */
class timelogManualEntry extends StatefulWidget{
  timelogManualEntry({Key key, this.userId}) : super(key: key);
  final String userId;
  @override
  _timeLogManualEntryState createState() => _timeLogManualEntryState();
}

/*
Description: Using built in flutter objects showDatePicker and showTimePicker, display to the user
the option to pick a date, start time, and end time for a manual entry. If any of these fields are populated,
a small diagram pops up below the buttons using the visibility tag. From here, the user can elect to save the
manual time entry, pushing it to the database. There are a few checks in this code: firstly, the start time, end time, and date
MUST be populated in order to be pushed to the database. Secondly, the total time must not be negative. If these conditions
hold true, the entry is pushed to the database and a confirmation message appears.
Functions:handleSaved(), pickDate(), pickTime()
 */
class _timeLogManualEntryState extends State<timelogManualEntry>{


  //variables to store the return of showDatePicker and showTimePicker
  TimeOfDay startTime = null;
  TimeOfDay endTime = null;
  DateTime date = null;

  //variables to store string representations of dates and times
  String dateString = "";
  String startString = "";
  String endString = "";
  String totalTimeDisplay = "";
  String note = null;



  //generate pop up for choosing a date
  Future <DateTime> pickDate(BuildContext context) => showDatePicker(
    context: context, initialDate: DateTime.now().add(Duration(seconds: 1)), firstDate: DateTime(2021), lastDate: DateTime.now(),

  );

  //generate pop up for choosing a time
  Future <TimeOfDay> pickTime(BuildContext context){
    final now = DateTime.now();
    return showTimePicker(context: context, initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );

  }

  //push to the database IF conditions hold true
  Future handleSaved() async{
    BuildContext dialogContext;
    await showDialog(
        context: context,
        builder: (BuildContext context)
    {
      dialogContext = context;
      /*it shows a popup with few options which you can select, for option we
        created enums which we can use with switch statement, in this first switch
        will wait for the user to select the option which it can use with switch cases*/
      return SimpleDialog(
        title: ListTile(
          title: const Text("TIME SAVED", style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25)),
          trailing: Icon(
              Icons.check,
              color: Colors.orange[900],
              size: 34.0),
        ),
        titlePadding: EdgeInsets.fromLTRB(45.0, 30.0, 45.0, 0.0),
        contentPadding: EdgeInsets.fromLTRB(70.0, 10.0, 60.0, 0.0),
        children: <Widget>[
          SizedBox(height: 30),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('Continue', style: TextStyle(fontSize: 20.0)),),
          ),
          SizedBox(height: 30),
        ],
      );
    });




  }
  @override
  TextEditingController _notes;
  Widget build(BuildContext context) {
    //variable to store what the user inputs into the notes field
    final _notes = TextEditingController();
    _notes.text = note;
    //generates the UI for the page. There are four main buttons, 3 of which are used to populate
    //1 button used to save. There are a few vbisiblity tags to only show the dates and times IF they have
    //been selected by the user
    return new Scaffold(
        appBar: AppBar(
          title: Text(manualEntryPageTitle, style: TextStyle(color: Colors.white, fontSize:24)),
          backgroundColor: Colors.orange[900],
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 230.0,
                      height: 40.0,
                      child: ElevatedButton(
                          onPressed: () async{

                            final d = await pickDate(context);
                            if (d!=null) {
                              date = d;
                              dateString = date.month.toString() + "/" +
                                  date.day.toString() + "/" + date.year.toString();


                              setState(() { });
                            }






                          },

                          child: Text("Date", style: TextStyle(fontSize: 20.0))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      child: SizedBox(

                          width: 250.0,
                          height: 30.0,

                          child: Text(dateString, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 30),)
                      ),
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: (date != null) ? true : false,
                    ),
                    SizedBox(height: 28),
                    SizedBox(
                      width: 230.0,
                      height: 40.0,
                      child: ElevatedButton(
                          onPressed: () async{


                            final st = await pickTime(context);
                            if (st!=null){
                              startTime = st;
                              startString = startTime.hour.toString() + ":" + startTime.minute.toString();


                              if (date != null && startTime != null && endTime != null){
                                int totTimeMinute = 0;
                                int subtractHour = 0;
                                if (endTime.minute>= startTime.minute)
                                  totTimeMinute = endTime.minute - startTime.minute;
                                else {
                                  totTimeMinute = 60 + endTime.minute - startTime
                                      .minute; //startTime.minute - endTime.minute;
                                  subtractHour = 1;
                                }

                                String hour = (endTime.hour - startTime.hour - subtractHour).toString();
                                if (hour.length == 1)
                                  hour = "0" + hour;
                                String min = totTimeMinute.toString();

                                if (min.length == 1)
                                  min = "0" + min;


                                totalTimeDisplay = hour + ":" + min;
                              }

                              setState(() { });
                            }


                          },
                          child: Text("Start Time", style: TextStyle(fontSize: 20.0))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      child: SizedBox(

                          width: 250.0,
                          height: 30.0,

                          child: Text(startString, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 30),)
                      ),
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: (startTime != null) ? true : false,
                    ),
                    SizedBox(height: 28),
                    SizedBox(
                      width: 230.0,
                      height: 40.0,
                      child: ElevatedButton(
                          onPressed: () async{

                            final et = await pickTime(context);
                            if (et!=null) {

                              endTime = et;
                              endString = endTime.hour.toString() + ":" + endTime.minute.toString();

                              if (date != null && startTime != null && endTime != null){
                                int totTimeMinute = 0;
                                int subtractHour = 0;
                                if (endTime.minute>= startTime.minute)
                                  totTimeMinute = endTime.minute - startTime.minute;
                                else {
                                  totTimeMinute = 60 + endTime.minute - startTime
                                      .minute; //startTime.minute - endTime.minute;
                                  subtractHour = 1;
                                }

                                String hour = (endTime.hour - startTime.hour - subtractHour).toString();
                                if (hour.length == 1)
                                  hour = "0" + hour;
                                String min = totTimeMinute.toString();

                                if (min.length == 1)
                                  min = "0" + min;


                                totalTimeDisplay = hour + ":" + min;
                              }

                              setState(() { });
                            }


                          },
                          child: Text("End Time", style: TextStyle(fontSize: 20.0))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      child: SizedBox(

                          width: 250.0,
                          height: 30,

                          child: Text(endString, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 30),)
                      ),
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: (endTime != null) ? true : false,
                    ),
                    // SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: TextField(
                        onChanged: (text){
                          //on change of value
                          note = _notes.text;

                        },
                        controller: _notes,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(40.0),
                            ),
                          ),
                          //contentPadding: EdgeInsets.all(20.0),
                          labelText: "Enter notes about your activity!",
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          // hintText: _notes.text,
                          hintStyle: TextStyle(color: Colors.orange[900]),
                        ),
                      ),
                    ),
                    //SizedBox(height:20),

                    Visibility(
                      child: SizedBox(

                          width: 250.0,
                          height: 30,

                          child: Text("Total Time: " + totalTimeDisplay, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 24),)
                      ),
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: (endTime != null && startTime != null && date != null) ? true : false,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 250.0,
                      height: 50.0,
                      child: RaisedButton(
                          onPressed: () async{
                            if (endTime != null && startTime != null && date != null){
                              final dbRef = FirebaseDatabase.instance.reference().child("TimeLogs");
                              String logdate = date.month.toString()+date.day.toString() + date.year.toString();
                              int totTimeMinute = 0;
                              int subHour = 0;
                              //generate number of total minutes
                              if (endTime.minute>= startTime.minute)
                                totTimeMinute = endTime.minute - startTime.minute;
                              else {
                                totTimeMinute = 60 + endTime.minute - startTime
                                    .minute; //startTime.minute - endTime.minute;
                                subHour = 1;
                              }

                              //manually construct minutes string
                              String hour = (endTime.hour - startTime.hour - subHour).toString();
                              if (hour.length == 1)
                                hour = "0" + hour;
                              String min = totTimeMinute.toString();

                              if (min.length == 1)
                                min = "0" + min;

                              String totTime = hour + ":" + min + ":" + "00";
                              String k = widget.userId;

                              String endD = "";
                              String endM = "";

                              //add extra 0 to ensure that single months and days are still pushed
                              //to the database with 2 digits
                              if (date.month.toString().length == 1)
                                endM = "0" + date.month.toString();
                              else
                                endM = date.month.toString();

                              if (date.day.toString().length == 1)
                                endD = "0" + date.day.toString();
                              else
                                endD = date.day.toString();

                              String endT = date.year.toString() + "-" + endM + "-" + endD + " " + endTime.hour.toString() + ":" + endTime.minute.toString() + ":" + "00";
                              String startT = date.year.toString() + "-" + endM + "-" + endD + " " + startTime.hour.toString() + ":" + startTime.minute.toString() + ":" + "00";
                              //check that we can push to the database.
                              //using our manually generated strings for each of the fields
                              if (endTime.hour - startTime.hour - subHour >= 0) {


                                dbRef.push().set({
                                  'ActivityID': null,
                                  //need to be YYYY-MM-DD
                                  'EndTime': endT,
                                  'LogDate': logdate,
                                  'Notes': note,
                                  //need to be YYYY-MM-DD
                                  'StartTime': startT,
                                  'TotalTime': totTime,
                                  'UserID': k
                                });
                                await handleSaved();
                                //await showDialog(context: context, builder: )
                                //do back navigation
                                Navigator.pop(context);
                              }

                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          child: Text("Save Manual Entry", style: TextStyle(fontSize: 20.0))),
                    ),


                  ]

              ),
            ),
          ),
        )
    );
  }

}