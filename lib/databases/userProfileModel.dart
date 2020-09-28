import 'base_model.dart';

class UserProfileModel extends BaseModel {

  String userName;
  String birthday; //ISO-8601
  String sex;
  int height;
  int weight;
  int selected;

  static String primaryKeyWhereString = 'userName = ?';
  static String getSelectedString = 'selected = ?';
  static String tableName = 'userProfile';

  String parameter;
  String parameterValue;

UserProfileModel(
      {this.userName,
      this.birthday,
      this.sex,
      this.height,
      this.weight,
      this.selected});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'userName': userName,
      'birthday': birthday,
      'sex': sex,
      'height': height,
      'weight': weight,
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
        weight: map['weight'],
        selected: map['selected']);
  }
}
