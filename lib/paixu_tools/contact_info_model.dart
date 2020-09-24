

import 'azlistview.dart';

class ContactInfoModel extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;
  bool isSelect;

  ContactInfoModel({
    this.name = 'aTest',
    this.tagIndex = 'A',
    this.namePinyin= 'A',
    this.isSelect = false,
  });

  ContactInfoModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] == null ? "" : json['name'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'tagIndex': tagIndex,
    'namePinyin': namePinyin,
    'isShowSuspension': isShowSuspension,
    'isSelect': isSelect,
  };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => "CityBean {" + " \"name\":\"" + name + "\"" + '}';
}
