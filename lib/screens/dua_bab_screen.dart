import 'package:flutter/material.dart';
import 'package:umre_rehberi/helper/dbHelper.dart';
import 'package:umre_rehberi/helper/sharedpreferenceshelper.dart';
import 'package:umre_rehberi/models/dua.dart';
import 'package:umre_rehberi/screens/dua_detail_screen.dart';

class DuaBabScreen extends StatefulWidget {
  final String kid;

  const DuaBabScreen({Key? key, required this.kid}) : super(key: key);

  @override
  _DuaBabScreenState createState() => _DuaBabScreenState();
}

class _DuaBabScreenState extends State<DuaBabScreen> {
  late final String kid;
  final DbHelper dbHelper = DbHelper();
  List<Dua>? dua;

  @override
  void initState() {
    super.initState();
    kid = widget.kid;
    _fetchDua();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hac ve Umre Rehberi", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF15181d),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: Color(0xFF15181d),
        body: dua == null
            ? Center(child: CircularProgressIndicator())
            : _buildDuaList(),
      ),
    );
  }

  Widget _buildDuaList() {
    return Column(
      children: [
        SizedBox(height: 30),
        Expanded(
          child: ListView.builder(
            itemCount: dua!.length,  // dua is guaranteed to be not null here
            itemBuilder: (context, index) {
              return _buildDuaCard(dua![index]);  // Use null assertion operator as dua is not null
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDuaCard(Dua duaItem) {
    return SizedBox(
      key: ValueKey(duaItem.ID.toString()),
      child: Card(
        margin: EdgeInsets.all(8.0),
        color: Color(0xFF2c2c2c),
        child: ListTile(
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              duaItem.Ana.toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          onTap: () => _onDuaTap(duaItem),
        ),
      ),
    );
  }

  void _onDuaTap(Dua duaItem) {
    SharedPreferencesHelper.setString("first", dua!.first.ID.toString());
    SharedPreferencesHelper.setString("last", dua!.last.ID.toString());
    SharedPreferencesHelper.setString("title", duaItem.Ana.toString());
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DuaDetailScreen(kid: duaItem.KID.toString(), id: duaItem.ID.toString()),
    ));
  }

  void _fetchDua() async {
    try {
      final data = await dbHelper.getBab(kid);
      setState(() {
        dua = data;  // data could still be null
      });
    } catch (e) {
      // Handle errors here if needed
      print('Error fetching dua: $e');
    }
  }
}
