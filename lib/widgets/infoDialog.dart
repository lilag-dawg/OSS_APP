import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class InfoDialog extends StatefulWidget {
  String info;
  InfoDialog(this.info);
  @override
  State<StatefulWidget> createState() {
    return InfoDialogState();
  }
}

class InfoDialogState extends State<InfoDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
          Text(
            widget.info,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            maxLines: (1 + widget.info.length / 25).toInt(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 1),
              FlatButton(
                child: Text(S.of(context).infoDialogClose),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(true),
              ),
            ],
          )
        ]));
  }
}
