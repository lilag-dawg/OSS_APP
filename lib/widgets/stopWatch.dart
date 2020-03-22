import 'dart:async';
import 'package:flutter/material.dart';


import '../constants.dart' as Constants;

class MyStopWatch extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StopWatchState();
  }
}

class StopWatchState extends State<MyStopWatch>{

  IconData iconPlayPause = Icons.play_arrow;
  String bigButtonText = 'Start';
  bool isStartPressed = true;
  bool isStopPressed = true;
  bool isResetPressed = true;
  var _stopWatch = Stopwatch();
  final dur = const Duration(seconds: 1);

  void startTimer(){
    Timer(dur, keepRunning);
  }

  void keepRunning(){
    if (_stopWatch.isRunning){
      startTimer();
    }
    setState(() {
      bigButtonText = _stopWatch.elapsed.inHours.toString().padLeft(2, '0') + ':'
                      + (_stopWatch.elapsed.inMinutes%60).toString().padLeft(2, '0') + ':'
                      + (_stopWatch.elapsed.inSeconds%60).toString().padLeft(2, '0');
    });
  }

  void startStopWatch(){
    print('$isStopPressed');
    if (isStopPressed == true){
      setState(() {
        isStopPressed = false;
        isResetPressed = true;
        iconPlayPause = Icons.pause;
      });
      _stopWatch.start();
      startTimer();
    }
    else if (isStopPressed == false){
      setState(() {
        isStopPressed = true;
        isResetPressed = false;
        iconPlayPause = Icons.play_arrow;
      });
    _stopWatch.stop();
    }
  }

  void stopStopWatch(){
    setState(() {
      isStopPressed = true;
      isResetPressed = false;
    });
    _stopWatch.stop();
  }

  void resetStopWatch(){
    setState(() {
      isStartPressed = true;
      isResetPressed = true;
    });
    _stopWatch.reset();
    bigButtonText = 'Start';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50
            ),
            SizedBox(
              width: 350,
              height: 350,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(350/2),
                  side: BorderSide(
                    color: Colors.black,
                    width: 3
                  )
                ),
                color: Color(Constants.backGroundBlue),
                child: Text(
                  bigButtonText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40
                  ),
                ),
                onPressed: isStartPressed? startStopWatch : null,
              ),
            ),
            SizedBox(
              height: 70
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(350/2),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1
                    )
                  ),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Icon(
                      iconPlayPause,
                      size: 50,
                    ),
                  ),
                  color: Colors.purple[900],
                  onPressed: isStartPressed? startStopWatch : null,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(350/2),
                    side: BorderSide(
                      color: Colors.black,
                      width: 1
                    )
                  ),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Center(
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                        ),
                      ),
                    )
                  ),
                  color: Colors.purple[900],
                  onPressed: isResetPressed? null : resetStopWatch,
                )
              ],
            )
          ] 
        ),
      )
    );
  }
}