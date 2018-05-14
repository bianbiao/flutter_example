import 'package:flutter/material.dart';
import 'package:flutter_codekk/entity/multi_item_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String opTag = 'op_tag';
final String opaTag = 'opa_tag';
final String blogTag = 'blog_tag';

class SettingScreen extends StatefulWidget {
  final VoidCallback voidCallback;

  SettingScreen({this.voidCallback});

  @override
  State<StatefulWidget> createState() =>
      SettingState(voidCallback: voidCallback);
}

class SettingState extends State<SettingScreen> {
  final VoidCallback voidCallback;

  SettingState({this.voidCallback});

  final List<MultiMenu> item = <MultiMenu>[
    MultiMenu(SettingItem.title, '开源项目', opTag),
    MultiMenu(SettingItem.item, '显示TAG', opTag),
    MultiMenu(SettingItem.title, '源码解析', opaTag),
    MultiMenu(SettingItem.item, '显示TAG', opaTag),
    MultiMenu(SettingItem.title, '博客文章', blogTag),
    MultiMenu(SettingItem.item, '显示TAG', blogTag),
  ];

  bool showOpTag = true;
  bool showOpaTag = true;
  bool showBlogTag = true;

  getTag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showOpTag = prefs.getBool(opTag) ?? true;
    showOpaTag = prefs.getBool(opaTag) ?? true;
    showBlogTag = prefs.getBool(blogTag) ?? true;
    setState(() {});
  }

  setTag(String tag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showTag = prefs.getBool(tag);
    await prefs.setBool(tag, showTag == null ? false : !showTag);
    getTag();
  }

  @override
  void initState() {
    getTag(); // currentState null at this time, so the app crashes.
    super.initState();
  }

  Widget titleWidget(MultiMenu entity) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child:
            Text(entity.message, style: TextStyle(color: Colors.pinkAccent)));
  }

  Widget itemWidget(MultiMenu entity) {
    bool value = entity.itemType == opTag
        ? showOpTag
        : entity.itemType == opaTag ? showOpaTag : showBlogTag;
    return InkWell(
        onTap: () {
          setTag(entity.itemType);
          setState(() {});
          voidCallback();
        },
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text(entity.message)),
                Checkbox(
                    value: value == null ? true : value, onChanged: (bool) {}),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('设置')),
        body: ListView.builder(
          padding: kMaterialListPadding,
          itemCount: item.length,
          itemBuilder: (context, index) {
            MultiMenu menu = item[index];
            switch (menu.type) {
              case SettingItem.item:
                return itemWidget(menu);
              case SettingItem.title:
                return titleWidget(menu);
            }
          },
        ));
  }
}
