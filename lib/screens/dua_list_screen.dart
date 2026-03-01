import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umre_rehberi/helper/dbHelper.dart';
import 'package:umre_rehberi/helper/sharedpreferenceshelper.dart';
import 'package:umre_rehberi/models/dua.dart';
import 'package:umre_rehberi/screens/dua_bab_screen.dart';

class DuaListScreen extends StatefulWidget {
  const DuaListScreen({Key? key}) : super(key: key);

  @override
  _DuaListScreenState createState() => _DuaListScreenState();
}

class _DuaListScreenState extends State<DuaListScreen> {
  final DbHelper dbHelper = DbHelper();
  List<Dua>? dua;
  int duaCount = 0;

  @override
  void initState() {
    super.initState();
    getKitap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            "Hac ve Umre Dua Rehberi",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF15181D),
        ),
        backgroundColor: Color(0xFF15181D),
        body: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: duaCount > 0
                  ? ListView.builder(
                itemCount: duaCount,
                itemBuilder: (BuildContext context, index) {
                  return SizedBox(
                    key: ValueKey(dua![index].KID.toString()),
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      color: Color(0xFF2C2C2C),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFF2C2C2C),
                        ),
                        child: ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dua![index].Ana.toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DuaBabScreen(
                                  kid: dua![index].KID.toString(),
                                )));
                          },
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: CircularProgressIndicator(),
              ), // Yükleniyor göstergesi
            ),
          ],
        ),
      ),
    );
  }

  void getKitap() async {
    try {
      var data = await dbHelper.getKitap();
      setState(() {
        dua = data;
        duaCount = dua?.length ?? 0; // null kontrolü
      });
    } catch (e) {
      print('Error fetching data: $e'); // Hata loglama
      // Kullanıcıya bir hata mesajı göstermek isterseniz:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri yüklenirken hata oluştu.')),
      );
    }
  }
}
