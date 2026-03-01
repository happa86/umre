import 'dart:async';
import 'dart:io';
import 'package:umre_rehberi/models/dua.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }


  Future<Database?> initializeDb() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      var databasesPath = await getDatabasesPath();
      databasesPath = databasesPath.replaceAll(
          "\\.dart_tool\\sqflite_common_ffi\\databases", "");
      final dbPath = join(
          appDocumentsDir.path, databasesPath, "assets/databases", "umre.db");
      final winLinuxDB = await databaseFactory.openDatabase(dbPath,
          options: OpenDatabaseOptions(readOnly: true));

      return winLinuxDB;
    }
/*    else if(kIsWeb && !Platform.isWindows)
      {
       print("object");
      }*/
    else if (Platform.isAndroid || Platform.isIOS) {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, "umre.db");
      var exists = await databaseExists(path);
      if (!exists) {
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}

        ByteData data =
        await rootBundle.load(join("assets/databases", "umre.db"));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      }
      var db = await openDatabase(path, readOnly: true);
      return db;
    }
    throw Exception("Unsupported platform");
  }








  Future<List<Dua>> getKitap() async {
    Database? db = await this.db;
    var result = await db?.query("umre where Type='Kitap'");
    return List.generate(result!.length, (i) {
      return Dua.fromObject(result[i]);
    });
  }

  Future<List<Dua>> getBab(String kid) async {
    Database? db = await this.db;
    var result = await db?.query(
        "umre where KID = '$kid' and Type='Bab'");
    return List.generate(result!.length, (i) {
      return Dua.fromObject(result[i]);
    });
  }

  Future<List<Dua>> getDua(String kid, String id) async {
    Database? db = await this.db;
    var result = await db?.query(
        "umre where KID = '$kid' and ID = '$id'");
    return List.generate(result!.length, (i) {
      return Dua.fromObject(result[i]);
    });
  }



}
