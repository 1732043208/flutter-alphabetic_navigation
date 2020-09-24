import 'dart:collection';

import 'package:alphabeticnavigation/paixu_tools/dict_data.dart';




/// Pinyin Resource.
class PinyinResource {
  static Map<String, String> getPinyinResource() {
    return getResource(pinyinDict);
  }

  static Map<String, String> getChineseResource() {
    return getResource(chineseDict);
  }

  static Map<String, String> getMultiPinyinResource() {
    return getResource(multiPinyinDict);
  }

  static Map<String, String> getResource(List<String> list) {
    Map<String, String> map = HashMap();
    List<MapEntry<String, String>> mapEntryList = List();
    for (int i = 0, length = list.length; i < length; i++) {
      List<String> tokens = list[i].trim().split('=');
      MapEntry<String, String> mapEntry = MapEntry(tokens[0], tokens[1]);
      mapEntryList.add(mapEntry);
    }
    map.addEntries(mapEntryList);
    return map;
  }
}
