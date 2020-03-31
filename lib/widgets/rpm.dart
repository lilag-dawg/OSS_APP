import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../constants.dart' as Constants;

class Rpm extends StatelessWidget {
  Rpm({this.characteristic, this.boxWidth, this.boxTitle, this.boxHeight}) {
    if (this.characteristic != null) {
      this.characteristic.setNotifyValue(true);
    }
  }

  final BluetoothCharacteristic characteristic;
  final double boxWidth;
  final double boxHeight;
  final String boxTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                boxTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: boxWidth / 7.5,
                ),
              ),
              SizedBox(height: 125 / 8.33),
              (characteristic != null)
                  ? StreamBuilder<List<int>>(
                      stream: characteristic.value,
                      initialData: characteristic.lastValue,
                      builder: (c, snapshot) {
                        final value = snapshot.data;
                        return Text(
                          value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[300],
                            fontSize: boxWidth / 6,
                          ),
                        );
                      },
                    )
                  : Text(
                      "N/A",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[300],
                        fontSize: boxWidth / 6,
                      ),
                    ),
            ],
          )),
    );
  }
}

/*return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        /*if(!snapshot.hasData){
          if(charName == "0x2A19"){
            print(value.toString());
          }
          else{
            characteristic.setNotifyValue(!characteristic.isNotifying);
          }
        }*/
        switch(snapshot.connectionState){
          case ConnectionState.none:
            print("no connection");
            break;
          case ConnectionState.waiting:
            print("waiting");
            break;
          case ConnectionState.active:
            print("active");
            if(value.length == 0){
              if(charName == "0x2A19"){
                characteristic.read();
              }
              else{
                characteristic.setNotifyValue(!characteristic.isNotifying);
              }
            }
            

            break;
          case ConnectionState.done:
            print("finish");
            break;
        }
        return ExpansionTile(
          title: ListTile(
            title: Column(
              children: <Widget>[
                Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}')
              ],
            ),
            subtitle: Text(value.toString()),
          ),
        );
      },*/
