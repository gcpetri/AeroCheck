// Amplify Flutter Packages
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math';
import 'package:overlay/overlay.dart';

// Generated in previous step
import 'amplifyconfiguration.dart';

// the app
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  // ############## amplify stuff
  bool _amplifyConfigured = false;

  @override
  initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {

    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    Amplify.addPlugins([authPlugin, analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    await Amplify.configure(amplifyconfig);
    try {
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }

  }
  // ########## end amplify stuff

  // #### global variables ######
  var stopWatch = new Stopwatch();
  bool buttonState = true;
  String pauseStr = "Pause";
  String _selectedValue = "0.0";
  bool intervalBool = false;
  String flightStr = "\nStart Flight\n(Manual)";
  String flightStrAuto = "\nStart Flight\n(Auto)";
  String noflightStr = "\nEnd Flight\n(Manual)";
  String noflightStrAuto = "\nEnd Flight\n(Auto)";
  bool inFlightMan = false;
  bool inFlightAuto = false;
  String _elevation = "0";
  List<String> planeLst = ["Airbus A319-100", "Airbus A320-200", "Airbus A321-200",
  "Airbus A321neo", "Boeing 737-800", "Boeing 737 MAX 8", "Boeing 777-200ER",
  "Boeing 777-300ER", "Boeing 787-8", "Boeing 787-9"];
  List<int> seatLst = [128, 150, 190, 196, 160, 172, 172, 273, 304, 234, 285];
  String _selectedPlane = "Airbus A319-100";
  int seats = 128;
  String time = "00:00:00";
  int secs = 0;
  Timer _timer;
  var rng = new Random();
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
            (Timer timer) => setState(() {
            secs = secs + 1;
            time = stopWatch.elapsed.toString().substring(0, 7);
        }));
  }
  void stopTimer() {
    _timer.cancel();
  }
  void _buttonChange() {
    setState(() {
      buttonState = !buttonState;
    });
    if (buttonState) {
      pauseStr = "Pause";
      stopWatch.start();
      startTimer();
    } else {
      pauseStr = "Resume";
      stopWatch.stop();
    }
  }
  DataRow _getDataRow(int indx) {
    int i = rng.nextInt(4);
    int j = rng.nextInt(3);
    Color c = Colors.white;
    if (j == 1) c = Colors.red[100];
    else if (j == 2) c = Colors.red;
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(indx.toString()),),
        DataCell(Center(child:Icon(i == 0 ? Icons.crop_square_outlined : Icons.person, size: 15, color: i == 0 ? Colors.white:c),),),
        DataCell(Center(child:Icon(i == 1 ? Icons.crop_square_outlined : Icons.person, size: 15, color: i == 1 ? Colors.white:c),),),
        DataCell(Center(child:Icon(i == 2 ? Icons.crop_square_outlined : Icons.person, size: 15, color: i == 2 ? Colors.white:c),),),
        DataCell(Center(child:Icon(i == 3 ? Icons.crop_square_outlined : Icons.person, size: 15, color: i == 3 ? Colors.white:c),),),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'AeroCheck',
        home: Scaffold(
      // top bar
      appBar: AppBar(
        title:
        Center(
          child: Text('AeroCheck'),
        ),
        backgroundColor: const Color(0xff131313),
      ),
      body: SafeArea(
        child:
        Expanded(
          child:
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(margin: const EdgeInsets.all(10.0), padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: const Color(0xff0078D2),
                    ),
                    child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container( margin: const EdgeInsets.all(15.0), child:
                        Center( child: Text('Plane Type', style: TextStyle(fontSize: 30, color: Colors.white),),),
                      ),
                      Container(
                        width: 200,
                        color: Colors.white,
                        margin: const EdgeInsets.all(10.0),
                        child: Center(
                          child: DropdownButton(
                            value: _selectedPlane,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedPlane = newValue;
                                seats = seatLst[planeLst.indexOf(newValue)];
                              });
                            },
                            items: planeLst.map((String val) {
                              return new DropdownMenuItem<String>(
                              value: val,
                              child: new Text(val),
                              );
                            }).toList(),),
                        ),
                      ),
                      Text(seats.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                      ListView(shrinkWrap: true, children: <Widget>[SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                        physics: ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 900),
                          child: DataTable(
                          columns: [
                            DataColumn(label: Text(' ')),
                            DataColumn(label: Text('A')),
                            DataColumn(label: Text('B')),
                            DataColumn(label: Text('C')),
                            DataColumn(label: Text('D')),
                          ], rows: List<DataRow>.generate(seats, (int index) => _getDataRow(index)),
                            dataRowHeight: 30.0,
                            columnSpacing: 65,
                            horizontalMargin: 30,
                        ),),),
                      ],),
                    ],),
                  ),
              ),
              Expanded(
                  child: Container( // right column
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: const Color(0xffC30019),
                    ),
                    child:
                    Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // flight start ########
                          Column( children: <Widget>[Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Column( children: <Widget>[Text(flightStr, style: TextStyle(fontSize: 15, color: Colors.white),textAlign: TextAlign.center,),
                          Container( // start flight
                            margin: const EdgeInsets.all(15.0),
                            child: RawMaterialButton(
                              onPressed: () {
                                if (!inFlightAuto) {
                                  stopWatch.reset();
                                  _buttonChange();
                                  setState(() {
                                    inFlightMan = !inFlightMan;
                                  });
                                  setState(() {
                                    flightStr = inFlightMan ? "End Flight\n(manual)" : "End Flight\n(manual)";
                                  });
                                }
                                if (inFlightMan && !inFlightAuto) {
                                  setState(() {
                                    flightStr = inFlightMan ? "End Flight\n(manual)" : "End Flight\n(manual)";
                                  });
                                  _buttonChange();
                                }
                              },
                              fillColor: inFlightMan ? Colors.grey : Colors.white,
                              child: Icon(
                                Icons.flight_takeoff,
                                size: 35.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ),
                          ),
                            ],),
                            Column( children: <Widget>[Text(flightStrAuto, style: TextStyle(fontSize: 15, color: Colors.white),textAlign: TextAlign.center,),
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              child: RawMaterialButton(
                                onPressed: () {
                                  if (!inFlightMan) {
                                    stopWatch.reset();
                                    _buttonChange();
                                    setState(() {
                                      inFlightAuto = !inFlightAuto;
                                    });
                                    setState(() {
                                      flightStrAuto = inFlightAuto ? "End Flight\n(Auto)" : "End Flight\n(Auto)";
                                    });
                                  }
                                  if (!inFlightMan && inFlightAuto) {
                                    _buttonChange();
                                  }
                                },
                                fillColor: Colors.white,
                                child: inFlightAuto ? Text('Elev.\n$_elevation', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,) : Icon(
                                  Icons.alt_route,
                                  size: 35.0,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                            ),
                              ],),
                          ],),
                          ],),
                          // ####### end flight start
                        Container( // Flight duration text
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Flight Duration', style: TextStyle(fontSize: 30, color: Colors.white),
                          ),),
                          width: 300.0,
                          height: 150.0,
                        ),
                        Container( // flight duration timer
                          height: 100,
                          width: 300,
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xff36495A)),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Center( child: Text(time, style: TextStyle(fontSize: 45, color: Colors.white), textAlign: TextAlign.center,),),
                        ),
                        Column( // pause button
                          children: [
                            RaisedButton(
                              //     disabledColor: Colors.red,
                              // disabledTextColor: Colors.black,
                              padding: const EdgeInsets.all(20),
                              textColor: Colors.white,
                              color: buttonState ? Colors.grey[200] : Colors.grey[600],
                              onPressed: _buttonChange,
                              child: Text(pauseStr, style: TextStyle(fontSize: 20, color: buttonState ? Colors.black : Colors.white),),
                            ),
                          ],
                        ),
                        Container( // set unmasked time text
                            child: Center(child: Text('Passenger Allowed\nUn-masked Time', style: TextStyle(fontSize: 30, color: Colors.white), textAlign: TextAlign.center,),),
                            width: 300.0,
                            height: 300.0,
                        ),
                          Container(
                            height: 30,
                            child: Center(child: Text('Enable', style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.center,),),
                          ),
                          Container(// switch for time
                            child: Center (child:
                            Switch(
                              value: intervalBool,
                              onChanged: (value) {
                                setState(() {
                                  intervalBool = !intervalBool;
                                });
                                activeTrackColor: Color(0xff36495A);
                                activeColor: Color(0xff0078D2);
                              },
                            ),),
                          ),
                          Container( // set to time text
                            child: Center(child: intervalBool ? Text('Restricted to:  $_selectedValue s', style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,) : null),
                            height: 50,
                            width: 100,
                            margin: const EdgeInsets.all(15.0),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                color: intervalBool ? Colors.white70 : null,
                              ),
                              margin: const EdgeInsets.all(15.0),
                              width: 350,
                              height: 60,
                              child: intervalBool ? Slider(
                              value: double.parse(_selectedValue),
                              min: 0.0,
                              max: 10.0,
                              divisions: 50,
                              label: double.parse(_selectedValue).round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _selectedValue= value.toString();
                                });
                              },
                          ): Text(''),
                          ),
                        ],
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    ),);
    }
}
void main() {
  runApp(MyApp());
}