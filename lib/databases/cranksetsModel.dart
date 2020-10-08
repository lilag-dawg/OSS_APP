import 'base_model.dart';

class CranksetsModel extends BaseModel {
  String cranksetName;
  int bigGear;
  int gear2;
  int gear3;

  static String primaryKeyWhereString = 'cranksetName = ?';
  static String tableName = 'cranksets';

  CranksetsModel({this.cranksetName, this.bigGear, this.gear2, this.gear3});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'cranksetName': cranksetName,
      'bigGear': bigGear,
      'gear2': gear2,
      'gear3': gear3
    };
    return map;
  }

  static CranksetsModel fromMap(Map<String, dynamic> map) {
    return CranksetsModel(
        cranksetName: map['cranksetName'],
        bigGear: map['bigGear'],
        gear2: map['gear2'],
        gear3: map['gear3']);
  }
}
