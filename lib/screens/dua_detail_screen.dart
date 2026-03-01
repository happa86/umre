import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umre_rehberi/helper/dbHelper.dart';
import 'package:umre_rehberi/helper/sharedpreferenceshelper.dart';
import 'package:umre_rehberi/models/dua.dart';

class DuaDetailScreen extends StatefulWidget {
  final String kid;
  final String id;

  DuaDetailScreen({Key? key, required this.kid, required this.id})
      : super(key: key);
  final List<String> fontList = [
    "Kitab",
    "Shaikh Hamdullah Mushaf",
    "Abay",
    "AmiriQuran",
    "XBNiloofar",
    "DroidNaskh-Regular",
    "Amiri-Regular",
  ];



  @override
  _DuaDetailScreenState createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  late final String kid;
  late final String id;
  DbHelper dbHelper = new DbHelper();
  List<Dua>? dua;
  int duaCount = 0;
  double sliderArabicSize =
      SharedPreferencesHelper.getDouble("textSizeArabic", 26);
  double sliderTranslationSize =
      SharedPreferencesHelper.getDouble("textSizeTranslation", 14);
  String fontType = SharedPreferencesHelper.getString("fontType", "Kitab");

  void fullScreenMode(bool? val) {
    if (val == true) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
    setState(() {});
  }

  void getFullScreen() async {
    fullScreenMode(SharedPreferencesHelper.getBool("fullscreen", true));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFullScreen();
    kid = widget.kid;
    id = widget.id;
    getDua(kid, id);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            dua!.elementAt(0).Ana.toString(),style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF15181d),
            iconTheme: IconThemeData(color: Colors.white)
        ),
        endDrawer: settingDrawer(),
        backgroundColor: Color(0xFF15181d),
        body: GestureDetector(
          onHorizontalDragEnd: (dragDetail) {
            String first = SharedPreferencesHelper.getString("first","1");
            String last = SharedPreferencesHelper.getString("last","1");
            try {
              if (dragDetail.velocity.pixelsPerSecond.dx > 0) {
                if (int.parse(last) > int.parse(dua![0].ID.toString()) &&
                    dua![0].ID
                        .toString()
                        .isNotEmpty && last.isNotEmpty) {
                  int next = int.parse(dua![0].ID.toString()) + 1;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          DuaDetailScreen(
                              kid: dua!.elementAt(0).KID.toString(),
                              id: next.toString())));
                }
              } else if (dragDetail.velocity.pixelsPerSecond.dx < 0) {
                if (int.parse(first) < int.parse(dua![0].ID.toString()) &&
                    dua![0].ID
                        .toString()
                        .isNotEmpty && first.isNotEmpty) {
                  int pre = int.parse(dua![0].ID.toString()) - 1;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          DuaDetailScreen(
                              kid: dua!.elementAt(0).KID.toString(),
                              id: pre.toString())));
                }
              }
            }
            catch(e){

            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8,16,8,8),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: EdgeInsets.all(8.0),
                          color: Color(0xFF2c2c2c),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                dua!.elementAt(0).AR.toString(),
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: sliderArabicSize,
                                    fontFamily: fontType),
                              ),
                            ),
                          )),
                      SizedBox(height: 8.0),
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          margin: EdgeInsets.all(8.0),
                          color: Color(0xFF2c2c2c),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                dua!.elementAt(0).TR.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sliderTranslationSize,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  settingDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF15181d),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                "Görünüm",
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Card(
              color: Color(0xFF15181d),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: SwitchListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text(
                    "Tam Ekran",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  value: SharedPreferencesHelper.getBool("fullscreen", true),
                  onChanged: (bool? value) {
                    setState(() {
                      fullScreenMode(value);
                      SharedPreferencesHelper.setBool("fullscreen", value!);
                      value:
                      SharedPreferencesHelper.getBool("fullscreen", value!)
                          ? SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.manual,
                              overlays: [])
                          : SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.manual,
                              overlays: SystemUiOverlay.values);
                    });
                  }),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Text(
                "Yazı",
                style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Card(
              color: Color(0xFF15181d),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(
                  "Font Tipi",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                subtitle: Text(
                  fontType,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    _showBottomSheetFont();
                  });
                },
              ),
            ),
            Card(
              color: Color(0xFF15181d),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(
                  "Arapça Metin Boyutu",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onTap: () {
                  setState(() {});
                },
              ),
            ),
            Row(children: [
              Expanded(
                flex: 11,
                child: Slider(
                  max: 36,
                  divisions: 18,
                  label: sliderArabicSize.round().toString(),
                  value: sliderArabicSize,
                  onChanged: (double value) {
                    setState(() {
                      updateSubtitleTextArabic(value);
                    });
                  },
                  onChangeEnd: (double value) {
                    SharedPreferencesHelper.setDouble("textSizeArabic", value);
                    updateSubtitleTextArabic(value);
                  },
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    sliderArabicSize.round().toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))
            ]),
            Card(
              color: Color(0xFF15181d),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(
                  "Türkçe Metin Boyutu",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onTap: () {
                  setState(() {});
                },
              ),
            ),
            Row(children: [
              Expanded(
                flex: 11,
                child: Slider(
                  max: 36,
                  divisions: 18,
                  label: sliderTranslationSize.round().toString(),
                  value: sliderTranslationSize,
                  onChanged: (double value) {
                    setState(() {
                      updateSubtitleTextTranslation(value);
                    });
                  },
                  onChangeEnd: (double value) {
                    SharedPreferencesHelper.setDouble(
                        "textSizeTranslation", value);
                    updateSubtitleTextTranslation(value);
                  },
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    sliderTranslationSize.round().toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))
            ]),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetFont() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      backgroundColor: Color(0xFF15181d),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  alignment: Alignment.center,
                  child: Text(
                    "Font Tipi",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.fontList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: widget.fontList[index].contains(
                                SharedPreferencesHelper.getString(
                                    "fontType", "Kitab"))
                            ? Theme.of(context).colorScheme.primary
                            : Color(0xFF15181d),
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          title: Text(
                            widget.fontList[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.fontList[index].contains(
                                      SharedPreferencesHelper.getString(
                                          "fontType", "Kitab"))
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Colors.white,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              SharedPreferencesHelper.setString(
                                  "fontType", widget.fontList[index]);
                            });

                            updateSubtitleFontType(widget.fontList[index]);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            );
          },
        );
      },
    );
  }

  void updateSubtitleTextArabic(double value) {
    setState(() {
      sliderArabicSize = value.roundToDouble();
    });
  }

  void updateSubtitleTextTranslation(double value) {
    setState(() {
      sliderTranslationSize = value.roundToDouble();
    });
  }

  void updateSubtitleSizeTextTranslation(double value) {
    setState(() {
      sliderTranslationSize = value.roundToDouble();
    });
  }

  void updateSubtitleFontType(String FontList) {
    setState(() {
      fontType = FontList;
    });
  }

  void getDua(String kid, String id) async {
    var duaFuture = dbHelper.getDua(kid, id);
    duaFuture.then((data) {
      setState(() {
        this.dua = data;
        var i = duaCount = data.length;
      });
    });
  }
}
