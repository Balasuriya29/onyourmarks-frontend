class StudentModel{
  String? _firstName;
  String? _rollNo;
  String? _id;
  String? _chat_id;
  String? _std_name;
  bool? _posted;


  String? get std_name => _std_name;

  set std_name(String? value) {
    _std_name = value;
  }

  bool? get posted => _posted;

  set posted(bool? value) {
    _posted = value;
  }

  String? get chat_id => _chat_id;

  set chat_id(String? value){
    _chat_id = value;
  }

  String? get firstName => _firstName;

  set firstName(String? value) {
    _firstName = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  String? get rollNo => _rollNo;

  set rollNo(String? value) {
    _rollNo = value;
  }

  StudentModel(this._firstName, this._rollNo, this._id);

  StudentModel.forChat(this._id,this._firstName,this._chat_id);

  StudentModel.forAttendance(this._firstName, this._id, this._std_name, this._posted);

  factory StudentModel.fromJson(Map<String,dynamic> json){
    return StudentModel(json["first_name"], json["roll_no"], json["_id"]);
  }
}