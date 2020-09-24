import 'package:alphabeticnavigation/paixu_tools/az-listview.dart';
import 'package:alphabeticnavigation/paixu_tools/az_common.dart';
import 'package:alphabeticnavigation/paixu_tools/contact_info_model.dart';
import 'package:alphabeticnavigation/paixu_tools/pinyin_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

class AddMembers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AddMembersState();
  }
}

class _AddMembersState extends State<AddMembers> {
  List<ContactInfoModel> _contacts = List();
  List<ContactInfoModel> _selectGroups = List();

  int _suspensionHeight = 30;
  int _itemHeight = 60;
  double _headHeight = 40;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List selects = [];

  void loadData() async {
    //加载联系人列表
    rootBundle.loadString('assets/data/contacts.json').then((value) {
      List list = json.decode(value);
      list.forEach((value) {
        _contacts.add(ContactInfoModel(name: value['name']));
      });
      _handleList(_contacts);
      setState(() {});
    });
  }

  void _handleList(List<ContactInfoModel> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(list);
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: _suspensionHeight.toDouble(),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      color: Color(0xffF5F5F5),
      child: Text(
        '$susTag',
        textScaleFactor: 1.2,
        style: TextStyle(
          color: Color(0xff333333),
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildListItem(ContactInfoModel model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: new InkWell(
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: new Image.asset(
                    model.isSelect
                        ? 'assets/image/drawable-xxxhdpi/select.png'
                        : 'assets/image/drawable-xxxhdpi/un_select.png',
//                    'assets/image/drawable-xxxhdpi/ic_${model.isSelect ? '' : 'un_'}select.png',
                    width: 20.0,
                  ),
                ),
                new CircleAvatar(
                  radius: 36 / 2,
                  child: Text(model.name[0]),
                ),
                new Space(),
                new Expanded(
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 30),
                    height: _itemHeight.toDouble(),
                    decoration: BoxDecoration(
                      border: !model.isShowSuspension
                          ? Border(top: BorderSide(color: Color(0xffF0F0F0)))
                          : null,
                    ),
                    child: new Text(
                      model.name,
                      style:
                          TextStyle(color: Color(0xff999999), fontSize: 14.0),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              model.isSelect = !model.isSelect;
              if (model.isSelect) {
                selects.insert(0, model);
              } else {
                selects.remove(model);
              }
              setState(() {});
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new NavigationBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'assets/image/drawable-xxxhdpi/fanhui.png',
            width: 24,
          ),
        ),
        title: '添加成员',
        rightDMActions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              'assets/image/drawable-xxxhdpi/search.png',
              width: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              'assets/image/drawable-xxxhdpi/baocun.png',
              width: 24,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: AzListView(
              data: _contacts,
              itemBuilder: (context, model) => _buildListItem(model),
              isUseRealIndex: true,
              itemHeight: _itemHeight,
              suspensionHeight: _suspensionHeight,
              header: AzListViewHeader(
                height: _headHeight.toInt(),
                builder: (context) {
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      '好友名单',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationBar({
    this.title = '',
    this.showBackIcon = true,
    this.rightDMActions,
    this.backgroundColor = const Color(0xffFAFAFA),
    this.mainColor = const Color(0xFF212121),
    this.titleW,
    this.bottom,
    this.leading,
    this.isCenterTitle = true,
    this.iconColor = const Color(0xff707070),
    this.brightness = Brightness.light,
    this.automaticallyImplyLeading = true,
    this.icons = Icons.arrow_back_ios,
    this.leadingType = 0,
  });

  final int leadingType;
  final String title;
  final bool showBackIcon;
  final List<Widget> rightDMActions;
  final Color backgroundColor;
  final Color mainColor;
  final Widget titleW;
  final PreferredSizeWidget bottom;
  final Widget leading;
  final bool isCenterTitle;
  final Color iconColor;
  final Brightness brightness;
  final bool automaticallyImplyLeading;
  final IconData icons;

  @override
  Size get preferredSize => new Size(100, bottom != null ? 100 : 48);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      title: titleW == null
          ? new Text(
              title,
              style: new TextStyle(color: mainColor),
            )
          : titleW,
      backgroundColor: backgroundColor,
      elevation: 0.0,
      brightness: brightness,
      leading: leading == null
          ? showBackIcon
              ? new InkWell(
                  child: new Container(
                    width: 22,
                    height: 22,
                    margin: EdgeInsets.symmetric(vertical: 13),
//                      leadingType == 0
//                          ? Icon(icons, color: mainColor, size: 14):
                    child: Image.asset("assets/images/commom/ic_back.png",
                        color: iconColor),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.maybePop(context);
                  },
                )
              : null
          : leading,
      centerTitle: isCenterTitle,
      bottom: bottom != null ? bottom : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: rightDMActions ?? [new Center()],
    );
  }
}

///判断List是否为空
bool listNoEmpty(List list) {
  if (list == null) return false;

  if (list.length == 0) return false;

  return true;
}

/// 间隔组件

class Space extends StatelessWidget {
  final double width;
  final double height;

  Space({this.width = 10.0, this.height = 10.0});

  @override
  Widget build(BuildContext context) {
    return new Container(width: width, height: height);
  }
}
