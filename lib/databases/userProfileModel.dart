import 'base_model.dart';

class UserProfileModel extends BaseModel {

  int userId;
  String birthday; //ISO-8601
  String sex;
  int height;
  int weight;

  static String primaryKeyWhereString = 'userId = ?';
  static String tableName = 'userProfile';

  String parameter;
  String parameterValue;

UserProfileModel(
      {this.userId,
      this.birthday,
      this.sex,
      this.height,
      this.weight});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'userId': userId,
      'birthday': birthday,
      'sex': sex,
      'height': height,
      'weight': weight
    };
    return map;
  }

  static UserProfileModel fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
        userId: map['userId'],
        birthday: map['birthday'],
        sex: map['sex'],
        height: map['height'],
        weight: map['weight']);
  }
}
