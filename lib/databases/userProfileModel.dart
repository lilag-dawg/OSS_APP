import 'base_model.dart';

class UserProfileModel extends BaseModel {
  String userName;
  String birthday; //ISO-8601
  String sex;
  double height; //cm
  int metricHeight;
  double weight; //kg
  int metricWeight;
  int selected;

  static String primaryKeyWhereString = 'userName = ?';
  static String getSelectedString = 'selected = ?';
  static String tableName = 'userProfile';

  UserProfileModel(
      {this.userName,
      this.birthday,
      this.sex,
      this.height,
      this.metricHeight,
      this.weight,
      this.metricWeight,
      this.selected});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'userName': userName,
      'birthday': birthday,
      'sex': sex,
      'height': height,
      'metricHeight': metricHeight,
      'weight': weight,
      'metricWeight': metricWeight,
      'selected': selected
    };
    return map;
  }

  static UserProfileModel fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
        userName: map['userName'],
        birthday: map['birthday'],
        sex: map['sex'],
        height: map['height'],
        metricHeight: map['metricHeight'],
        weight: map['weight'],
        metricWeight: map['metricWeight'],
        selected: map['selected']);
  }
}
