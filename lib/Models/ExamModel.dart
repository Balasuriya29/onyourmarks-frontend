import 'package:onyourmarks/Models/SubjectModel.dart';

class ExamModel{
  String? _exam_id;
  String? _std_id;
  String? _examName;
  String? _std_name;
  List<SubjectModel>? _subjects;
  String? _status;


  String? get exam_id => _exam_id;

  set exam_id(String? value) {
    _exam_id = value;
  }

  String? get examName => _examName;

  String? get status => _status;

  set status(String? value) {
    _status = value;
  }

  List<SubjectModel>? get subjects => _subjects;

  set subjects(List<SubjectModel>? value) {
    _subjects = value;
  }

  set examName(String? value) {
    _examName = value;
  }
  String? get std_id => _std_id;

  String? get std_name => _std_name;

  set std_name(String? value) {
    _std_name = value;
  }

  set std_id(String? value) {
    _std_id = value;
  }


  ExamModel(this._exam_id, this._std_id, this._examName, this._std_name,
      this._subjects, this._status);
  //
  // factory ExamModel.fromJson(Map<String, dynamic> json){
  //   return ExamModel(json["exam_id"] ["_id"], json["std"]["_id"],json["std"] ["std_name"],json["exam_id"] ["examName"],json["exam_id"] ["subjects"], json["exam_id"] ["dates"], json["exam_id"] ["status"]);
  // }


}