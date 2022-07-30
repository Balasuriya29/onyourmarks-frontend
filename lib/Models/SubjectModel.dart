class SubjectModel{
  String? _id;
  String? _subName;
  String? _totalMarks;
  String? _date;

  String? get id => _id;

  String? get date => _date;

  set date(String? value) {
    _date = value;
  }

  set id(String? value) {
    _id = value;
  }

  String? get subName => _subName;

  String? get totalMarks => _totalMarks;

  set totalMarks(String? value) {
    _totalMarks = value;
  }

  set subName(String? value) {
    _subName = value;
  }


  SubjectModel(
      this._id, this._subName, this._totalMarks, this._date);

  factory SubjectModel.fromJson(Map<String, dynamic> json){
    return SubjectModel(json["_id"], json["sub_name"], json["total_marks"].toString(), json["date"].toString());
  }
}