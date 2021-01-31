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

// Generated in previous step
import 'amplifyconfiguration.dart';
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
  String flightStr = "Start Flight (Manual)";
  String flightStrAuto = "Start Flight (Auto)";
  bool inFlightMan = false;
  bool inFlightAuto = false;
  void _buttonChange() {
    setState(() {
      buttonState = !buttonState;
    });
    if (buttonState) {
      pauseStr = "Pause";
      stopWatch.start();
    } else {
      pauseStr = "Resume";
      stopWatch.stop();
    }
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
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SafeArea(
        child:
        Expanded(
          child:
          Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                    children: <Widget>[
                      Text('Plane'),
                    ],
                  )
              ),
              Expanded(
                  child: Container( // right column
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.red[400],
                    child:
                    Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column( children: <Widget>[Expanded( child: Row( children: [
                            Column( children: <Widget>[Text(flightStr, style: TextStyle(fontSize: 15, color: Colors.white),),
                          Container( // start flight
                            margin: const EdgeInsets.all(15.0),
                            child: RawMaterialButton(
                              onPressed: () {
                                stopWatch.start();
                                inFlightMan = !inFlightMan;
                                flightStr = "Start Flight (Manual)";
                                if (!inFlightAuto) {
                                  flightStr = "End Flight (Manual)";
                                  inFlightAuto = !inFlightAuto;
                                }
                              },
                              elevation: 2.0,
                              fillColor: inFlightMan ? Colors.grey[200] : Colors.white,
                              child: Icon(
                                Icons.flight_takeoff,
                                size: 35.0,
                              ),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                            ),
                          ),
                            ],),
                            Column( children: <Widget>[Text(flightStrAuto, style: TextStyle(fontSize: 15, color: Colors.white),),
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              color: inFlightAuto ? Colors.grey[200] : null,
                              child: RawMaterialButton(
                                onPressed: () {
                                  stopWatch.start();
                                  flightStrAuto = "Start Flight (Manual)";
                                  if (!inFlightAuto) {
                                    flightStrAuto = "End Flight (Manual)"; inFlightAuto = !inFlightAuto;
                                  }
                                },
                                elevation: 2.0,
                                fillColor: inFlightAuto ? Colors.grey[200] : Colors.white,
                                child: Icon(
                                  Icons.alt_route,
                                  size: 35.0,
                                ),
                                padding: EdgeInsets.all(15.0),
                                shape: CircleBorder(),
                              ),
                            ),
                              ],),
                          ],),),],),
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
                              border: Border.all(color: Colors.blueGrey),
                          ),
                          child: Center( child: Text(stopWatch.elapsed.toString().substring(0, 7), style: TextStyle(fontSize: 45, color: Colors.white), textAlign: TextAlign.center,),),
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
                            height: 200.0,
                        ),
                          Container( // set to time text
                            child: Center(child: intervalBool ? Text('Restricted to:  $_selectedValue s', style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,) : null),
                            height: 50,
                            width: 100,
                            margin: const EdgeInsets.all(15.0),
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
                                  //if(intervalBool) _showPicker(context);
                                });
                                activeTrackColor: Colors.green[200];
                                activeColor: Colors.green;
                              },
                            ),),
                          ),
                          Container(
                              margin: const EdgeInsets.all(15.0),
                              color: Colors.white70,
                              width: 350,
                              height: 100,
                              child: intervalBool ? Slider(
                              value: double.parse(_selectedValue),
                              min: 0,
                              max: 10,
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