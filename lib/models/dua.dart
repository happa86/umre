class Dua {
  String? KID;
  String? ID;
  String? Ana;
  String? AR;
  String? TR;
  String? Type;

  Dua({
    this.KID,
    this.ID,
    this.Ana,
    this.AR,
    this.TR,
    this.Type,
  });

  Dua.withId({
    required this.KID,
    required this.ID,
    this.Ana,
    this.AR,
    this.TR,
    this.Type,
  });

  Map<String, dynamic> toMap() {
    return {
      "ID": ID,
      "Ana": Ana,
      "AR": AR,
      "TR": TR,
      "Type": Type,
      if (KID != null) "KID": KID,
    };
  }

  Dua.fromObject(Map<String, dynamic> o) {
    KID = o["KID"] as String?;
    ID = o["ID"] as String?;
    Ana = o["Ana"] as String?;
    AR = o["AR"] as String?;
    TR = o["TR"] as String?;
    Type = o["Type"] as String?;
  }
}
