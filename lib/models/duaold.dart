class Dua {

  int id;
  String ana;
  String arapca;
  String turkce;


  Dua({this.id = 1,
    this.ana  = "",
    this.arapca = "",
    this.turkce = "",
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'],
      ana : json['ana'],
      arapca: json['arapca'],
      turkce: json['turkce'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ana'] = this.ana;
    data['arapca'] = this.arapca;
    data['turkce'] = this.turkce;
    return data;
  }
  static getDuaById(int id,List<Dua> duas) async {
    for (Dua dua in duas) {
      // If the doa id matches the given id, return the doa
      if (dua.id == id) {
        return dua;
      }
    }
    // If no doa is found, return null
    return null;



  }

}