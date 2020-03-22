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

  IconData _iconPlayPause = Icons.play_arrow;
  String _bigButtonText = 'Start';
  bool isStartPressed = true;
  bool isStopPressed = true;
  bool isResetPressed = true;
  bool isStartShown = true;
  var _stopWatch = Stopwatch();
  final _dur = const Duration(milliseconds: 1);

  void startTimer(){
    Timer(_dur, keepRunning);
  }

  void keepRunning(){
    if (_stopWatch.isRunning){
      startTimer();
    }
    setState(() {
      _bigButtonText = _stopWatch.elapsed.inHours.toString().padLeft(2, '0') + ' : '
                      + (_stopWatch.elapsed.inMinutes%60).toString().padLeft(2, '0') + ' : '
                      + (_stopWatch.elapsed.inSeconds%60).toString().padLeft(2, '0') + ' : '
                      + (_stopWatch.elapsed.inMilliseconds%60).toString().padLeft(2, '0');
    });
  }

  void startStopWatch(){
    if (isStopPressed == true){
      setState(() {
        isStartShown = false;
        isStopPressed = false;
        isResetPressed = true;
        _iconPlayPause = Icons.pause;
      });
      _stopWatch.start();
      startTimer();
    }
    else if (isStopPressed == false){
      setState(() {
        isStartShown = false;
        isStopPressed = true;
        isResetPressed = false;
        _iconPlayPause = Icons.play_arrow;
      });
    _stopWatch.stop();
    }
  }

  void resetStopWatch(){
    setState(() {
      isStartShown = true;
      _bigButtonText = 'Start';
      isStartPressed = true;
      isResetPressed = true;
    });
    _stopWatch.reset();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _bigButtonText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),
                    ),
                    Visibility(
                      visible: isStartShown? false:true,
                      child: Text(
                        'Hrs      Min     Sec      Ms',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: isStartPressed? startStopWatch : null,
              ),
            ),
            SizedBox(
              height: 40
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
                      _iconPlayPause,
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