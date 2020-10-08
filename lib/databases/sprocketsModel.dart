import 'base_model.dart';

class SprocketsModel extends BaseModel {
  String sprocketName;
  int smallGear;
  int gear2;
  int gear3;
  int gear4;
  int gear5;
  int gear6;
  int gear7;
  int gear8;
  int gear9;
  int gear10;
  int gear11;
  int gear12;
  int gear13;

  static String primaryKeyWhereString = 'cranksetName = ?';
  static String tableName = 'sprockets';

  SprocketsModel(
      {this.sprocketName,
      this.smallGear,
      this.gear2,
      this.gear3,
      this.gear4,
      this.gear5,
      this.gear6,
      this.gear7,
      this.gear8,
      this.gear9,
      this.gear10,
      this.gear11,
      this.gear12,
      this.gear13});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'sprocketName': sprocketName,
      'smallGear': smallGear,
      'gear2': gear2,
      'gear3': gear3,
      'gear4': gear4,
      'gear5': gear5,
      'gear6': gear6,
      'gear7': gear7,
      'gear8': gear8,
      'gear9': gear9,
      'gear10': gear10,
      'gear11': gear11,
      'gear12': gear12,
      'gear13': gear13,
    };
    return map;
  }

  static SprocketsModel fromMap(Map<String, dynamic> map) {
    return SprocketsModel(
      sprocketName: map['sprocketName'],
      smallGear: map['smallGear'],
      gear2: map['gear2'],
      gear3: map['gear3'],
      gear4: map['gear4'],
      gear5: map['gear5'],
      gear6: map['gear6'],
      gear7: map['gear7'],
      gear8: map['gear8'],
      gear9: map['gear9'],
      gear10: map['gear10'],
      gear11: map['gear11'],
      gear12: map['gear12'],
      gear13: map['gear13'],
    );
  }
}
