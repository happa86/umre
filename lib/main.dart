import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umre_rehberi/helper/sharedpreferenceshelper.dart';
import 'package:umre_rehberi/screens/dua_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  } catch (e) {
    print('Database initialization error: $e');
  }

  await SharedPreferencesHelper.init();

  // Default olarak true döndürmek için ?? true eklenmiştir
  final isFirstStart = SharedPreferencesHelper.getBool('isFirstStart', true) ?? true;

  if (isFirstStart) {
    SharedPreferencesHelper.resetSharedPreferences();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hac ve Umre Rehberi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DuaListScreen(),
    );
  }

  void fullScreenMode(bool? val) {
    SystemChrome.setEnabledSystemUIMode(
      val == true ? SystemUiMode.manual : SystemUiMode.manual,
      overlays: val == true ? [] : SystemUiOverlay.values,
    );
  }

  void getFullScreen() async {
    fullScreenMode(SharedPreferencesHelper.getBool("fullscreen", true));
  }

  @override
  void initState() {
    super.initState();
    getFullScreen();
  }
}
