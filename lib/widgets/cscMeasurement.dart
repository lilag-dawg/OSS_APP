import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class CSCMeasurement extends StatelessWidget {
  final List<bool> isInfo0x2A62; // [RPM, Speed, Power]
  final List<bool> isInfo0x2A5B; // [RPM, Speed]
  final double boxWidth;
  final double boxHeight;


  CSCMeasurement(
      {this.isInfo0x2A62, this.isInfo0x2A5B, this.boxWidth, this.boxHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: (boxHeight * 2) + 20,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Opacity(
                opacity: !isInfo0x2A62[1] & isInfo0x2A5B[1] ? 1 : 0,
                child: Container(
                  // DISTANCE
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(Constants.blueButtonColor)),
                  child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: boxHeight / 12.5),
                          Text(
                            'Distance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: boxWidth / 7.5,
                            ),
                          ),
                          SizedBox(height: 125 / 8.33),
                          Text(
                            '88 km',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[300],
                              fontSize: boxWidth / 6,
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Opacity(
                opacity: !isInfo0x2A62[1] & isInfo0x2A5B[1] ? 1 : 0,
                child: Container(
                  // SPEED
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(Constants.blueButtonColor)),
                  child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: boxHeight / 12.5),
                          Text(
                            'Speed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: boxWidth / 7.5,
                            ),
                          ),
                          SizedBox(height: 125 / 8.33),
                          Text(
                            '12,8 kmph',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[300],
                              fontSize: boxWidth / 6,
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Opacity(
                opacity: !isInfo0x2A62[0] & isInfo0x2A5B[0] ? 1 : 0,
                child: Container(
                  // CADENCE
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(Constants.blueButtonColor)),
                  child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: boxHeight / 12.5),
                          Text(
                            'Cadence',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: boxWidth / 7.5,
                            ),
                          ),
                          SizedBox(height: 125 / 8.33),
                          Text(
                            '62 Rpm',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[300],
                              fontSize: boxWidth / 6,
                            ),
                          )
                        ],
                      )),
                ),
              ),
              Opacity(
                opacity: 0,
                child: Container(
                  // POWER
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(Constants.blueButtonColor)),
                  child: SizedBox(
                      width: boxWidth,
                      height: boxHeight,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: boxHeight / 12.5),
                          Text(
                            'Power',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: boxWidth / 7.5,
                            ),
                          ),
                          SizedBox(height: 125 / 8.33),
                          Text(
                            '99 W',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[300],
                              fontSize: boxWidth / 6,
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}