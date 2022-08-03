class StandardModel{
  String? _id;
  String? _stdName;

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  String? get stdName => _stdName;

  set stdName(String? value) {
    _stdName = value;
  }

  StandardModel(this._id, this._stdName);

  StandardModel.fromJson(Map<String,dynamic> json){
    StandardModel(json["_id"], json["std_name"]);
  }
}